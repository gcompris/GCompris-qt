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
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: background
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
        }

        onStart: {
            items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
            score.numberOfSubLevels = 5;
            score.currentSubLevel = 1;
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    background.audioDisabled = true;
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
                margins: 10 * ApplicationInfo.ratio
            }
            source: items.url + 'xylofon.svg'
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
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
                              && !anim.running && !bonus.isPlaying
                    onClicked: {
                        anim.start()
                        background.playNote(index)
                        items.answer.push(index)
                        background.checkAnswer()
                    }
                }
            }
        }

        function playNote(index) {
            activity.audioEffects.play(ApplicationInfo.getAudioFilePath(items.url +
                                       'xylofon_son' + (index + 1) + ".wav"))
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
                    background.playNote(partIndex)
                    start()
                }
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
                score.currentSubLevel = 1
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
                parent.nextSubLevel();
                introDelay.restart();
            }
            onLoose: introDelay.restart();
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.top: parent.top
        }

        function initLevel() {
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
        }

        function nextSubLevel() {
            if(score.currentSubLevel < score.numberOfSubLevels) {
                score.currentSubLevel++
                initLevel()
                return
            }
            nextLevel()
        }

        function nextLevel() {
            score.currentSubLevel = 1
            items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
            initLevel();
        }

        function repeat() {
            if(items.running == true) {
                introDelay.stop()
                activity.audioVoices.stop()
                questionPlayer.stop()
                activity.audioEffects.play(ApplicationInfo.getAudioFilePath(items.url + 'knock.wav'))
                items.questionToPlay = items.question.slice()
                items.answer = []
                knock.start()
            }
        }

        function checkAnswer() {
            if(items.answer.join() == items.question.join())
                bonus.good('note')
            else if(items.answer.length >= items.question.length)
                bonus.bad('note')
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
                    initLevel();
                    items.running = true;
                    introDelay.start();
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
