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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
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
    isMusicalActivity: true

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
            property alias metronomeOscillation: metronomeOscillation
            property bool isMetronomeVisible: false
            property bool isWrongRhythm: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property string clefType: "Treble"
        property bool isRhythmPlaying: false

        Keys.onSpacePressed: tempo.tempoPressed()

        Rectangle {
            id: instructionBox
            radius: 10
            width: background.width * 0.7
            height: background.height / 9
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                id: instructionText
                color: "black"
                z: 3
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.02
                anchors.leftMargin: parent.width * 0.02
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: items.isMetronomeVisible ? qsTr("Use the metronome to estimate the time intervals and play the rhythm correctly.")
                                               : qsTr("Follow the vertical line and click on the tempo or press space key and play the rhythm correctly.")
            }
        }

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
            numberOfSubLevels: 3
            width: horizontalLayout ? parent.width / 10 : (parent.width - instructionBox.x - instructionBox.width - 1.5 * anchors.rightMargin)
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.6 : parent.width * 0.9
            height: horizontalLayout ? parent.height * 1.1 : parent.height * 0.76
            nbStaves: 1
            clef: clefType
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: horizontalLayout ? 0 : parent.height * 0.1
            centerNotesPosition: true
            firstCenteredNotePosition: width / (2 * (musicElementModel.count - 1))
            spaceBetweenNotes: width / (2.5 * (musicElementModel.count - 1))
            enableNotesSound: false
            onPulseMarkerAnimationFinished: background.isRhythmPlaying = false
            onPlayDrumSound: {
                if(background.isRhythmPlaying && !metronomeOscillation.running)
                    items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
            }
        }

        Image {
            id: tempo
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/drumhead.png"
            width: horizontalLayout ? parent.width / 7 : parent.width / 4
            height: width / 2
            anchors.top: metronome.top
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                enabled: !background.isRhythmPlaying && !bonus.isPlaying && (!items.isWrongRhythm || multipleStaff.isPulseMarkerRunning)
                onPressed: tempo.tempoPressed()
                onReleased: tempo.scale = 1
            }

            function tempoPressed() {
                tempo.scale = 0.85
                if(!multipleStaff.isMusicPlaying) {
                    Activity.currentNote = 0
                    multipleStaff.play()
                }
                if(!metronomeOscillation.running)
                    items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                Activity.checkAnswer(multipleStaff.pulseMarkerX)
            }
        }

        Image {
            id: metronome
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/metronome_stand.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: parent.width / 3
            sourceSize.height: parent.height / 4
            width: sourceSize.width
            height: sourceSize.height
            anchors.bottom: bar.top
            anchors.bottomMargin: 20
            visible: items.isMetronomeVisible
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(metronomeOscillation.running)
                        metronomeOscillation.stop()
                    else
                        metronomeOscillation.start()
                }
            }

            Image {
                id: metronomeNeedle
                source: "qrc:/gcompris/src/activities/play_rhythm/resource/metronome_needle.svg"
                fillMode: Image.PreserveAspectFit
                width: parent.height
                height: parent.height
                anchors.centerIn: parent
                transformOrigin: Item.Bottom
                SequentialAnimation {
                    id: metronomeOscillation
                    loops: Animation.Infinite
                    onStopped: metronomeNeedle.rotation = 0
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 0
                        to: 12
                        direction: RotationAnimator.Shortest
                        duration: 463
                    }
                    ScriptAction {
                        script: items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 12
                        to: 0
                        direction: RotationAnimator.Shortest
                        duration: 463
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 0
                        to: 348
                        direction: RotationAnimator.Shortest
                        duration: 463
                    }
                    ScriptAction {
                        script: items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 348
                        to: 0
                        direction: RotationAnimator.Shortest
                        duration: 463
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                background.isRhythmPlaying = true
                Activity.initSubLevel()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
