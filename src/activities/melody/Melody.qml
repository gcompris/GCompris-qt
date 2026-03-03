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
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

     onActivityNextLevel: {
         Activity.nextLevel()
    }

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
            property var question
            property var questionToPlay
            property var answer
            property alias questionInterval: questionPlayer.interval
            property int currentLevel: 0
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            readonly property int numberOfLevel: 10
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
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
            source: activity.resourceUrl + 'xylofon.svg'
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        GCSoundEffect {
            id: knockSound
            source: activity.resourceUrl + 'knock.wav'
        }

        component PartDelegate : Image {
            id: part
            required property int index
            property alias anim: anim
            source: activity.resourceUrl + 'xylofon_part' + (index + 1) + '.svg'
            rotation: - 80
            anchors.horizontalCenter: xylofon.horizontalCenter
            anchors.horizontalCenterOffset: (- xylofon.paintedWidth) * 0.3 + xylofon.paintedWidth * index * 0.22
            anchors.verticalCenter: xylofon.verticalCenter
            anchors.verticalCenterOffset: - xylofon.paintedHeight * 0.1
            sourceSize.width: xylofon.paintedWidth * 0.5
            fillMode: Image.PreserveAspectFit

            function play() {
                partSound.play()
            }

            GCSoundEffect {
                id: partSound
                source: activity.resourceUrl + 'xylofon_son' + (part.index + 1) + ".wav"
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
                    activityBackground.playNote(part.index)
                    items.answer.push(part.index)
                    if(items.answer.length >= items.question.length) {
                        items.buttonsBlocked = true;
                        feedbackTimer.restart();
                    }
                }
            }
        }

        Repeater {
            id: parts
            model: 4
            delegate: PartDelegate {}
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
                    activityBackground.repeat()
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
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | repeat }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: {
                score.stopWinAnimation();
                score.currentSubLevel = 0;
                items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
                activityBackground.initLevel();
                activityBackground.repeat();
            }
            onNextLevelClicked: {
                activityBackground.nextLevel();
                activityBackground.repeat();
            }
            onHomeClicked: activity.home()
            onRepeatClicked: activityBackground.repeat()
        }

        Bonus {
            id: bonus
            onWin: {
                activityBackground.nextLevel();
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
                activityBackground.nextSubLevel();
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
                    activityBackground.initLevel();
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
