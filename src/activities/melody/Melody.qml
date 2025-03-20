/* GCompris - melody.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Jose JORGE <jjorge@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: "#ABCDEF"

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property string url: "qrc:/gcompris/src/activities/melody/resource/"
            property var question
            property var questionToPlay
            property var answer
            property alias questionInterval: questionPlayer.interval
            readonly property int numberOfLevel: 10
            property int currentLevel: 0
            property bool running: false
            property bool buttonsBlocked: false
        }

        onStart: {
            items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
            score.numberOfSubLevels = 5;
            score.currentSubLevel = 0;
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    activityBackground.audioDisabled = true;
            } else {
                initLevel();
                items.running = true;
                introDelay.start();
            }
        }

        onStop: {
            introDelay.stop()
            knock.stop()
            questionPlayer.stop()
            items.running = false
        }

        Item {
            id: layoutArea
            width: parent.width
            height: parent.height - bar.height * 1.5 - score.height * 1.3
            anchors.top: score.bottom
            anchors.left: parent.left
        }

        Image {
            id: xylofon
            anchors {
                fill: layoutArea
                margins: GCStyle.baseMargins
            }
            source: items.url + 'xylofon.svg'
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        GCSoundEffect {
            id: knockSound
            source: items.url + 'knock.wav'
        }

        Repeater {
            id: parts
            model: 4
            Image {
                id: part
                source: items.url + 'xylofon_part' + (index + 1) + '.svg'
                rotation: - 80
                anchors.horizontalCenter: xylofon.horizontalCenter
                anchors.horizontalCenterOffset: (- xylofon.paintedWidth) * 0.3 + xylofon.paintedWidth * index * 0.22
                anchors.verticalCenter: xylofon.verticalCenter
                anchors.verticalCenterOffset: - xylofon.paintedHeight * 0.1
                sourceSize.width: xylofon.paintedWidth * 0.5
                fillMode: Image.PreserveAspectFit

                property alias anim: anim
                function play() {
                    partSound.play()
                }

                GCSoundEffect {
                    id: partSound
                    source: items.url + 'xylofon_son' + (index + 1) + ".wav"
                }

                SequentialAnimation {
                    id: anim
                    NumberAnimation {
                        target: part
                        property: "scale"
                        from: 1; to: 0.95
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: part
                        property: "scale"
                        from: 0.95; to: 1
                        duration: 150
                        easing.type: Easing.OutElastic
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !questionPlayer.running && !knock.running && !introDelay.running
                              && !anim.running && !items.buttonsBlocked
                    onClicked: {
                        anim.start()
                        activityBackground.playNote(index)
                        items.answer.push(index)
                        if(items.answer.length >= items.question.length) {
                            items.buttonsBlocked = true;
                            feedbackTimer.restart();
                        }
                    }
                }
            }
        }

        function playNote(index: int) {
            parts.itemAt(index).play()
        }
        Timer {
            id: introDelay
            interval: 1000
            repeat: false
            onTriggered: {
                if(activity.audioVoices.playbackState == 1) {
                    introDelay.restart()
                }
                else {
                    parent.repeat()
                }
            }
        }


        Timer {
            id: knock
            interval: 1000
            repeat: false
            onTriggered: {
                questionPlayer.start()
            }
        }

        Timer {
            id: questionPlayer
            onTriggered: {
                var partIndex = items.questionToPlay.shift()
                if(partIndex !== undefined) {
                    parts.itemAt(partIndex).anim.start()
                    activityBackground.playNote(partIndex)
                    start()
                }
            }
        }

        Timer {
            id: feedbackTimer
            interval: 500
            onTriggered: {
                activityBackground.checkAnswer()
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: layoutArea
            imageSize: 60 * ApplicationInfo.ratio
            function releaseControls() {
                introDelay.restart();
                items.buttonsBlocked = false;
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | repeat }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: {
                score.stopWinAnimation();
                score.currentSubLevel = 0;
                items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
                initLevel();
                parent.repeat();
            }
            onNextLevelClicked: {
                parent.nextLevel();
                parent.repeat();
            }
            onHomeClicked: activity.home()
            onRepeatClicked: parent.repeat()
        }

        Bonus {
            id: bonus
            onWin: {
                parent.nextLevel();
                introDelay.restart();
            }
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins
            anchors.top: parent.top
            onStop: {
                parent.nextSubLevel();
                introDelay.restart();
            }
        }

        function initLevel() {
            errorRectangle.resetState();
            items.question = []
            questionPlayer.stop()

            var numberOfParts = 4
            if(items.currentLevel < 2)
                numberOfParts = 2
            else if(items.currentLevel < 4)
                numberOfParts = 3

            for(var i = 0; i < items.currentLevel + 3; ++i) {
                items.question.push(Math.floor(Math.random() * numberOfParts))
            }
            items.questionInterval = 1200 - Math.min(500, 100 * (items.currentLevel + 1))
            items.answer = []
            items.buttonsBlocked = false
        }

        function nextSubLevel() {
            if(score.currentSubLevel < score.numberOfSubLevels) {
                initLevel()
                return
            }
            bonus.good("note")
        }

        function nextLevel() {
            score.stopWinAnimation();
            score.currentSubLevel = 0;
            items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
            initLevel();
        }

        function repeat() {
            if(items.running == true) {
                introDelay.stop()
                activity.audioVoices.stop()
                questionPlayer.stop()
                knockSound.play()
                items.questionToPlay = items.question.slice()
                items.answer = []
                knock.start()
            }
        }

        GCSoundEffect {
            id: goodAnswer
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswer
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        function checkAnswer() {
            if(items.answer.join() === items.question.join()) {
                score.currentSubLevel += 1
                score.playWinAnimation()
                goodAnswer.play()
            } else {
                badAnswer.play()
                errorRectangle.startAnimation()
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
                    initLevel();
                    items.running = true;
                    introDelay.start();
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
