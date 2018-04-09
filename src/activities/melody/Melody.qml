/* GCompris - melody.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Jose JORGE <jjorge@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: items.url + 'xylofon_background.svg'
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop

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
            property int numberOfLevel: 10
            property bool running: false
        }

        onStart: {
            bar.level = 1
            score.numberOfSubLevels = 5
            score.currentSubLevel = 1
            initLevel()
            items.running = true
        }

        onStop: {
            knock.stop()
            questionPlayer.stop()
            items.running = false
        }

        Image {
            id: xylofon
            anchors {
                fill: parent
                margins: 10 * ApplicationInfo.ratio
            }
            source: items.url + 'xylofon.svg'
            sourceSize.width: parent.width * 0.7
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
                    enabled: !questionPlayer.running
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
            content: BarEnumContent { value: help | home | level | repeat }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: {
                score.currentSubLevel = 1
                if(bar.level == 1) {
                    bar.level = items.numberOfLevel
                } else {
                    bar.level--
                }
                initLevel();
            }
            onNextLevelClicked: parent.nextLevel()
            onHomeClicked: activity.home()
            onRepeatClicked: parent.repeat()
        }

        Bonus {
            id: bonus
            onWin: {
                parent.nextSubLevel()
                parent.repeat()
            }
            onLoose: parent.repeat()
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
            if(bar.level < 3)
                numberOfParts = 2
            else if(bar.level < 5)
                numberOfParts = 3

            for(var i = 0; i < bar.level + 2; ++i) {
                items.question.push(Math.floor(Math.random() * numberOfParts))
            }
            items.questionInterval = 1200 - Math.min(500, 100 * bar.level)
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
            if(items.numberOfLevel === bar.level ) {
                bar.level = 1
            } else {
                bar.level++
            }
            initLevel();
        }

        function repeat() {
            if(items.running == true) {
                questionPlayer.stop()
                activity.audioEffects.play(ApplicationInfo.getAudioFilePath(items.url + 'knock.wav'))
                items.questionToPlay = items.question.slice()
                items.answer = []
                knock.start()
            }
        }

        function checkAnswer() {
            if(items.answer.join() == items.question.join())
                bonus.good('lion')
            else if(items.answer.length >= items.question.length)
                bonus.bad('lion')
        }
    }
}
