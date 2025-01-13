/* GCompris - PlayRhythm.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "play_rhythm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false
        readonly property bool horizontalLayout: width >= height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias parser: parser
            property alias score: score
            property alias multipleStaff: multipleStaff
            property alias iAmReady: iAmReady
            property alias introductoryAudioTimer: introductoryAudioTimer
            property alias metronomeOscillation: metronomeOscillation
            property alias answerFeedbackTimer: answerFeedbackTimer
            property bool isMetronomeVisible: false
            property bool isWrongRhythm: false
            property bool buttonsBlocked: false
            property bool crashPlayed: false
        }

        onStart: {
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    background.audioDisabled = true;
            }
            Activity.start(items);
        }
        onStop: { Activity.stop() }

        property string clefType: "Treble"
        property bool isRhythmPlaying: false
        property int metronomeSpeed: 60000 / multipleStaff.bpmValue - 53
        property real weightOffset: metronome.height * multipleStaff.bpmValue * 0.004

        Keys.onSpacePressed: if(!background.isRhythmPlaying && !items.buttonsBlocked)
                                tempo.tempoPressed();
        Keys.onTabPressed: if(metronome.visible && metronomeOscillation.running)
                             metronomeOscillation.stop();
                          else if(metronome.visible && !metronomeOscillation.running)
                                  metronomeOscillation.start();
        Keys.onEnterPressed: Activity.initSubLevel();
        Keys.onReturnPressed: Activity.initSubLevel();
        Keys.onUpPressed: optionsRow.bpmIncreased();
        Keys.onDownPressed: optionsRow.bpmDecreased();
        Keys.onReleased: (event) => {
            if(iAmReady.visible) {
                iAmReady.visible = false;
                Activity.initLevel();
            } else if(event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                bpmChangeDelay.restart();
            }
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: clickSound
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/click.wav"
        }

        Rectangle {
            id: instructionBox
            radius: 10
            width: instructionText.contentWidth + 20 * ApplicationInfo.ratio
            height: instructionText.contentHeight + 10 * ApplicationInfo.ratio
            anchors.centerIn: instructionText
            opacity: 0.8
            border.width: 2 * ApplicationInfo.ratio
            color: "white"
            border.color: "#87A6DD"
        }

        GCText {
            id: instructionText
            color: "#303030"
            anchors.right: score.left
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 20 * ApplicationInfo.ratio
            height: score.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            text: items.isMetronomeVisible ? qsTr("Use the metronome to estimate the time intervals and play the rhythm correctly.")
            : qsTr("Follow the vertical line and click on the drum or press space key to play the rhythm correctly.")
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

        Timer {
            id: bpmChangeDelay
            interval: 500
            onTriggered: {
                Activity.initSubLevel();
                background.isRhythmPlaying = true;
            }
        }

        Timer {
            id: answerFeedbackTimer
            interval: 1000
            onRunningChanged: {
                if (!running) {
                    if(!items.crashPlayed)
                        Activity.answerFeedback();
                    else {
                        items.crashPlayed = false;
                        Activity.initSubLevel();
                    }
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
            onStop: Activity.nextSubLevel()
        }

        MultipleStaff {
            id: multipleStaff
            width: background.horizontalLayout ? parent.width * 0.6 : parent.width * 0.9
            height: background.horizontalLayout ? parent.height * 1.1 : parent.height * 0.76
            bpmValue: 90
            nbStaves: 1
            clef: clefType
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: background.horizontalLayout ? 0 : parent.height * 0.1
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
            width: background.horizontalLayout ? parent.width / 7 : parent.width / 4
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
                enabled: !background.isRhythmPlaying && !items.buttonsBlocked
                onPressed: tempo.tempoPressed()
            }

            function tempoPressed() {
                tempoAnim.start()
                if(!multipleStaff.isMusicPlaying && Activity.currentNote == 0) {
                    multipleStaff.play()
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
                        script: clickSound.play()
                    }
                    RotationAnimator {
                        target: metronomeNeedle
                        from: 12
                        to: 348
                        direction: RotationAnimator.Shortest
                        duration: metronomeSpeed
                    }
                    ScriptAction {
                        script: clickSound.play()
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
                bpmChangeDelay.restart();
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
                win.connect(Activity.nextLevel)
            }
        }

        Loader {
            id: audioNeededDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("This activity requires sound, so it will play some sounds even if the audio voices or effects are disabled in the main configuration.")
                button1Text: qsTr("Quit")
                button2Text: qsTr("Continue")
                onButton1Hit: activity.home();
                onClose: {
                    background.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
