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
import core 1.0

import "../../core"
import "../piano_composition"
import "play_rhythm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: activityBackground
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
            property alias activityBackground: activityBackground
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
                    activityBackground.audioDisabled = true;
            }
            Activity.start(items);
        }
        onStop: { Activity.stop() }

        property string clefType: "Treble"
        property bool isRhythmPlaying: false
        property int metronomeSpeed: 60000 / multipleStaff.bpmValue - 53
        property real weightOffset: metronome.height * multipleStaff.bpmValue * 0.004

        Keys.onSpacePressed: if(!activityBackground.isRhythmPlaying && !items.buttonsBlocked)
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

        GCTextPanel {
            id: instructionPanel
            color: GCStyle.lightBg
            border.width: GCStyle.thinBorder
            border.color: GCStyle.blueBorder
            textItem.color: GCStyle.darkText
            panelWidth: parent.width - 2 * GCStyle.baseMargins - score.width
            panelHeight: score.height
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -(score.width + GCStyle.baseMargins) * 0.5
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: items.isMetronomeVisible ? qsTr("Use the metronome to estimate the time intervals and play the rhythm correctly.")
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
                activityBackground.isRhythmPlaying = true;
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
            anchors.top: activityBackground.top
            anchors.bottom: undefined
            numberOfSubLevels: 3
            onStop: Activity.nextSubLevel()
        }

        Item {
            id: staffLayoutArea
            anchors.top: instructionPanel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: optionsRow.top
            anchors.margins: GCStyle.baseMargins
        }

        MultipleStaff {
            id: multipleStaff
            anchors.centerIn: staffLayoutArea

            // we count maximum 4 notes + the clef, but in case there is more someday, add a Math.max check...
            property int maxItemsOnTheStaff: Math.max(5, multipleStaff.musicElementModel.count)
            // To make sure all the notes fit on one line.
            property int relativeSizeUnit: Math.min(staffLayoutArea.height / 14, staffLayoutArea.width / (5 * maxItemsOnTheStaff))

            height: relativeSizeUnit * 14
            width: relativeSizeUnit * (5 * maxItemsOnTheStaff)
            bpmValue: 90
            nbStaves: 1
            clef: clefType
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: activityBackground.horizontalLayout ? 0 : parent.height * 0.1
            enableNotesSound: false
            onPulseMarkerAnimationFinished: activityBackground.isRhythmPlaying = false
            onPlayDrumSound: {
                if(activityBackground.isRhythmPlaying && !metronomeOscillation.running)
                    GSynth.generate(60, 100)
            }
        }

        Image {
            id: tempo
            source: "qrc:/gcompris/src/activities/play_rhythm/resource/drumhead.svg"
            width: activityBackground.horizontalLayout ? parent.width / 7 : parent.width / 4
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
                enabled: !activityBackground.isRhythmPlaying && !items.buttonsBlocked
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
                    activityBackground.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
