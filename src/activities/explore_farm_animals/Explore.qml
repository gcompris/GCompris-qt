/* GCompris - Explore.qml
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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

import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "explore.js" as Activity

ActivityBase {
    id: activity

    property string backgroundImage
    property var dataset
    property bool hasAudioQuestions

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background

        /* In order to accept any screen ratio the play area is always a 1000x1000
         * square and is centered in a big background image that is 2000x2000
         */

        Image {
            id: bg
            source: backgroundImage
            sourceSize.width: 2000 * ApplicationInfo.ratio
            sourceSize.height: 2000 * ApplicationInfo.ratio
            width: 2000 * background.playRatio
            height: width
            anchors.centerIn: parent
        }

        Rectangle {
            width: background.playWidth
            height: background.playHeight
            anchors.centerIn: parent
            border.width: 2
            border.color: "black"
            color: "transparent"
            visible: false /* debug to see the play area */
        }

        property bool horizontalLayout: background.width > background.height
        property int playX: (activity.width - playWidth) / 2
        property int playY: (activity.height - playHeight) / 2
        property int playWidth: horizontalLayout ? activity.height : activity.width
        property int playHeight: playWidth
        property double playRatio: playWidth / 1000

        focus: true

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items

            property GCAudio audioEffects: activity.audioEffects
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias dataModel: dataModel
            property alias instruction: instruction
            property alias instructionText: instructionText
            property alias descriptionPanel: descriptionPanel
            property bool hasAudioQuestions: activity.hasAudioQuestions
            property int currentLevel
            property string currentAudio
            property var questionOrder
            property var currentQuestion: activity.dataset.tab[items.questionOrder[score.currentSubLevel]]
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        Keys.onEscapePressed: {
            descriptionPanel.visible ? descriptionPanel.visible = false : home()
        }

        Repeater {
            id: dataModel
            model: dataset.tab.length
            Animals {
                questionId: index
                source: dataset.tab[index].image
                x: background.playX + background.playWidth * dataset.tab[index].x - width / 2
                y: background.playY + background.playHeight * dataset.tab[index].y - height / 2
                width: background.playWidth * dataset.tab[index].width
                height: background.playHeight * dataset.tab[index].height
                title: dataset.tab[index].title
                description: dataset.tab[index].text
                imageSource: dataset.tab[index].image2
                question: dataset.tab[index].text2
                audio: dataset.tab[index].audio !== undefined ? dataset.tab[index].audio : ""
                Component.onCompleted: {
                    displayDescription.connect(displayDescriptionItem)
                }
            }
        }

        function displayDescriptionItem(animal) {
            descriptionPanel.title = animal.title
            descriptionPanel.description = animal.description
            descriptionPanel.imageSource = animal.imageSource
            descriptionPanel.visible = true
        }

        AnimalDescription {
            id: descriptionPanel
            width: parent.width
            height: parent.height
            visible: false
            z: instruction.z + 1
            onVisibleChanged: {
                if(visible) {
                    animDescription.start()
                }
                else {
                    // stop if audio was playing
                    items.audioEffects.stop()
                }
            }

            NumberAnimation {
                id: animDescription
                target: descriptionPanel
                property: horizontalLayout ? "x" : "y"
                from: horizontalLayout ? -width : -height
                to: 0
                duration: 1200
                easing.type: Easing.OutBack
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 80 * ApplicationInfo.ratio
            z: bar.z + 1

            visible: items.currentLevel == 1 && activity.hasAudioQuestions //&& ApplicationSettings.isAudioVoicesEnabled
            anchors {
                bottom: parent.bottom
                right: score.left
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: Activity.repeat();
        }


        Rectangle {
            id: question
            width: parent.width * 0.9
            height: questionText.height
            color: '#CCCCCCCC'
            radius: 10
            border.width: 3
            border.color: "black"
            visible: items.currentLevel == 2 || (items.currentLevel == 1 && !items.hasAudioQuestions)
            anchors {
                top: instruction.visible ? instruction.bottom : parent.top
                horizontalCenter: parent.horizontalCenter
                margins: 10 * ApplicationInfo.ratio
            }
            GCText {
                id: questionText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent.Center
                color: "black"
                width: parent.width
                wrapMode: Text.Wrap
                text: items.currentQuestion.text2
            }
        }

        Rectangle {
            id: instruction
            width: parent.width * 0.9
            height: instructionText.height
            color: "#CCCCCCCC"
            radius: 10
            border.width: 3
            border.color: "black"
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                margins: 5 * ApplicationInfo.ratio
            }

            GCText {
                id: instructionText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent.Center
                color: "black"
                width: parent.width
                wrapMode: Text.Wrap
                text: activity.dataset.instruction[items.currentLevel].text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.visible = false
                enabled: instruction.visible
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

        Score {
            id: score
            z: 1003
            visible: items.currentLevel != 0
            anchors.bottom: background.bottom
            anchors.right: background.right
        }

        Bonus {
            id: bonus
        }
    }
}
