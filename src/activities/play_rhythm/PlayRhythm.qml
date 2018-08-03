/* GCompris - PlayRhythm.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "play_rhythm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: width > height

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        property string backgroundImagesUrl: ":/gcompris/src/activities/piano_composition/resource/background/"
        property var backgroundImages: directory.getFiles(backgroundImagesUrl)

        Directory {
            id: directory
        }

        source: {
            if(items.bar.level === 0)
                return "qrc" + backgroundImagesUrl + backgroundImages[0]
            else
                return "qrc" + backgroundImagesUrl + backgroundImages[(items.bar.level - 1) % backgroundImages.length]
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias parser: parser
            property alias score: score
            property alias multipleStaff: multipleStaff
            property alias iAmReady: iAmReady
            property alias introductoryAudioTimer: introductoryAudioTimer
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property string clefType: "Treble"
        property bool isRhythmPlaying: false

        Timer {
            id: introductoryAudioTimer
            interval: 3500
            onRunningChanged: {
                if(running)
                    Activity.isIntroductoryAudioPlaying = true
                else {
                    Activity.isIntroductoryAudioPlaying = false
                    Activity.initSubLevel()
                }
            }
        }

        JsonParser {
            id: parser
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.3
            visible: iAmReady.visible
            z: 10
            MouseArea {
                anchors.fill: parent
            }
        }

        ReadyButton {
            id: iAmReady
            focus: true
            z: 10
            onClicked: {
                Activity.initLevel()
            }
        }

        Score {
            id: score
            anchors.top: background.top
            anchors.bottom: undefined
            numberOfSubLevels: 5
            width: parent.width / 10
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.6 : parent.width * 0.8
            height: horizontalLayout ? parent.height : parent.height * 0.7
            nbStaves: 1
            clef: clefType
            isPulseMarkerDisplayed: items.bar.level % 2
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: horizontalLayout ? parent.height * 0.1 : parent.height * 0.15
            noteHoverEnabled: false
            centerNotesPosition: true
            enableNotesSound: false
            onPulseMarkerAnimationFinished: background.isRhythmPlaying = false
            onPlayDrumSound: {
                if(background.isRhythmPlaying)
                    items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
            }
        }

        Piano {
            id: piano
            visible: false
        }

        Rectangle {
            id: optionDeck
            width: optionsRow.iconsWidth * 3
            height: optionsRow.iconsWidth * 1.7
            border.width: 2
            border.color: "black"
            color: "black"
            opacity: 0.5
            radius: 10
            y: background.height / 2 - height
            x: background.width - width - 25
        }

        OptionsRow {
            id: optionsRow
            anchors.top: optionDeck.top
            anchors.topMargin: 15
            anchors.horizontalCenter: optionDeck.horizontalCenter
            iconsWidth: horizontalLayout ? Math.min(50, (background.width - piano.x - piano.width) / 5) : 45

            playButtonVisible: !multipleStaff.isPulseMarkerRunning && !multipleStaff.isMusicPlaying
            clearButtonVisible: playButtonVisible

            onClearButtonClicked: Activity.initSubLevel()
            onPlayButtonClicked: background.isRhythmPlaying = true
        }

        Image {
            id: tempo
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/drumhead.png"
            width: parent.width / 7
            height: width / 2
            anchors.bottom: bar.top
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                enabled: !background.isRhythmPlaying
                onPressed: {
                    tempo.scale = 0.85
                    if(!multipleStaff.isMusicPlaying) {
                        Activity.currentNote = 0
                        multipleStaff.play()
                    }
                    items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                    Activity.checkAnswer(multipleStaff.pulseMarkerX)
                }
                onReleased: tempo.scale = 1
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
