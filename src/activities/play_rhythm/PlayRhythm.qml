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

    property bool horizontalLayout: width >= height

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"

        signal start
        signal stop

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
        property int metronomeSpeed: 60000 / multipleStaff.bpmValue - 53
        property real weightOffset: metronome.height * multipleStaff.bpmValue * 0.004

        Keys.onSpacePressed: if (!background.isRhythmPlaying && !bonus.isPlaying)
                                tempo.tempoPressed()

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
            bpmValue: 90
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
                    GSynth.generate(60, 100)
            }
        }

        Image {
            id: tempo
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/drumhead.svg"
            width: horizontalLayout ? parent.width / 7 : parent.width / 4
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors.top: metronome.top
            anchors.horizontalCenter: parent.horizontalCenter
            transform: Scale {
                id: tempoScale
                origin.y: tempo.height
                yScale: 1
                SequentialAnimation on yScale {
                    id: tempoAnim
                    PropertyAnimation { to: 0.5; duration: 50 }
                    PropertyAnimation { to: 1; duration: 50 }
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: !background.isRhythmPlaying && !bonus.isPlaying
                onPressed: tempo.tempoPressed()
            }

            function tempoPressed() {
                tempoAnim.start()
                if(!multipleStaff.isMusicPlaying && Activity.currentNote == 0) {
                    multipleStaff.play()
                } else if (!multipleStaff.isMusicPlaying && Activity.currentNote > 0){
                    items.bonus.bad("flower")
                }
                GSynth.generate(60, 100)
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
                    onStarted: metronomeNeedle.rotation = 12
                    onStopped: metronomeNeedle.rotation = 0
                    ScriptAction {
                        script: items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 12
                        to: 348
                        direction: RotationAnimator.Shortest
                        duration: metronomeSpeed
                    }
                    ScriptAction {
                        script: items.audioEffects.play("qrc:/gcompris/src/activities/play_rhythm/resource/click.wav")
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 348
                        to: 12
                        direction: RotationAnimator.Shortest
                        duration: metronomeSpeed
                    }
                }
                Image {
                    id: metronomeWeight
                    source: "qrc:/gcompris/src/activities/play_rhythm/resource/metronome_weight.svg"
                    fillMode: Image.PreserveAspectFit
                    width: parent.height
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: weightOffset
                }
                
            }
            Image {
                id: metronomeFront
                source: "qrc:/gcompris/src/activities/play_rhythm/resource/metronome_front.svg"
                fillMode: Image.PreserveAspectFit
                width: parent.height
                height: parent.height
                anchors.centerIn: parent
            }
        }
        
        OptionsRow {
            id: optionsRow
            anchors.verticalCenter: tempo.verticalCenter
            anchors.left: tempo.right

            bpmVisible: true
            onBpmDecreased: {
                if(multipleStaff.bpmValue >= 51)
                    multipleStaff.bpmValue--
            }
            onBpmIncreased: {
                if(multipleStaff.bpmValue <= 179)
                multipleStaff.bpmValue++
            }
            onBpmChanged: {
                Activity.initSubLevel()
                background.isRhythmPlaying = true
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
                Activity.initSubLevel()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
                loose.connect(Activity.initSubLevel)
            }
        }
    }
}
