/* GCompris - ExploreLevels.qml
*
* Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
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

import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.5

import "../../core"
import "explore-level.js" as Activity

ActivityBase {
    id: activity

    property int numberOfLevels
    property string url
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
            source: dataset.item.backgroundImage
            sourceSize.width: 2000 * ApplicationInfo.ratio
            sourceSize.height: 2000 * ApplicationInfo.ratio
            width: 2000 * background.playRatio
            height: width
            anchors.centerIn: parent
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

            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias progressbar: progressbar
            property alias ok: ok
            property alias dataModel: dataModel
            property alias dataset: dataset
            property alias instruction: instruction
            property alias instructionText: instructionText
            property alias descriptionPanel: descriptionPanel
            property alias nextQuestion: nextQuestion
            property bool hasAudioQuestions: activity.hasAudioQuestions
            property string currentAudio
            property var questionOrder
            property var currentQuestion: items.dataset ? items.dataset.item.tab[items.questionOrder[progressbar.value]] : ""
        }
        
        Timer {
            id: nextQuestion
            repeat: false
            interval: 2000
            onTriggered: {
                Activity.repeat();
            }
        }

        Loader{
            id: dataset
            asynchronous: false
            onStatusChanged: {
                if (status == Loader.Ready) {
                    // create table of size N filled with numbers from 0 to N
                    items.questionOrder = Array.apply(null, {length: items.dataModel.count}).map(Number.call, Number)
                }
            }
        }

        onStart: { Activity.start(items, url, numberOfLevels) }
        onStop: { Activity.stop() }

        Keys.onEscapePressed: {
            descriptionPanel.visible ? descriptionPanel.closeDescriptionPanel() : home()
        }

        Repeater {
            id: dataModel
            model: dataset && dataset.item && dataset.item.tab ? dataset.item.tab.length : 0
            AnimalLevels {
                questionId: index
                source: dataset.item.tab[index].image
                x: background.playX + background.playWidth * dataset.item.tab[index].x - width / 2
                y: background.playY + background.playHeight * dataset.item.tab[index].y - height / 2
                width: background.playWidth * dataset.item.tab[index].width
                height: background.playHeight * dataset.item.tab[index].height
                title: dataset.item.tab[index].title
                description: dataset.item.tab[index].text
                imageSource: dataset.item.tab[index].image2
                question: dataset.item.tab[index].text2
                audio: dataset.item.tab[index].audio !== undefined ? dataset.item.tab[index].audio : ""
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
            descriptionPanel.showDescriptionPanel()
        }

        AnimalDescriptionLevels {
            id: descriptionPanel
            width: parent.width
            height: parent.height
            z: instruction.z + 1
        }

        Column {
            id: progress
            visible: items.score.currentSubLevel != 1
            anchors.bottom: bar.top
            anchors.right: parent.right
            anchors.margins: 10 * ApplicationInfo.ratio
            ProgressBar {
                id: progressbar
                height: progressbarText.height
                width: bar.width
                property string message
                onValueChanged: message = value + "/" + maximumValue
                onMaximumValueChanged:  message = value + "/" + maximumValue

                GCText {
                    id: progressbarText
                    anchors.centerIn: parent
                    fontSize: mediumSize
                    font.bold: true
                    color: "black"
                    text: progressbar.message
                }
            }
        }

        Image {
            id: ok
            visible: progressbar.value === progressbar.maximumValue
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: questionText.height * 2
            fillMode: Image.PreserveAspectFit
            anchors.right: progress.left
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.nextLevel()
            }
        }

        Row {
            id: row
            spacing: 10 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: 10 * ApplicationInfo.ratio
            layoutDirection: leftCol.width === 0 ? Qt.RightToLeft : Qt.LeftToRight
            Column {
                id: leftCol
                spacing: 10 * ApplicationInfo.ratio

                Rectangle {
                    id: instruction
                    width: row.width - rightCol.width - 10 * ApplicationInfo.ratio
                    height: instructionText.height
                    color: "#CCCCCCCC"
                    radius: 10
                    border.width: 3
                    border.color: "black"

                    GCText {
                        id: instructionText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent.Center
                        color: "black"
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: (dataset.item && items.score.currentSubLevel - 1 != items.score.numberOfSubLevels  && items.score.currentSubLevel != 0) ? dataset.item.instructions[items.score.currentSubLevel - 1].text : ""
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: instruction.visible = false
                        enabled: instruction.visible
                    }
                }

                Rectangle {
                    id: question
                    width: row.width - rightCol.width - 10 * ApplicationInfo.ratio
                    height: questionText.height
                    color: '#CCCCCCCC'
                    radius: 10
                    border.width: 3
                    border.color: "black"
                    visible: items.score.currentSubLevel == 3 || (items.score.currentSubLevel == 2 && !items.hasAudioQuestions)
                    GCText {
                        id: questionText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent.Center
                        color: "black"
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: items.currentQuestion ? items.currentQuestion.text2 : ""
                    }
                }
            }

            Column {
                id: rightCol
                spacing: 10 * ApplicationInfo.ratio

                Score {
                    id: score
                    anchors {
                        bottom: undefined
                        right: undefined
                    }
                }

                BarButton {
                    id: repeatItem
                    source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
                    sourceSize.width: 60 * ApplicationInfo.ratio
                    anchors.right: parent.right
                    visible: items.score.currentSubLevel == 2 && activity.hasAudioQuestions //&& ApplicationSettings.isAudioVoicesEnabled
                    onClicked: Activity.repeat();
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
            onReloadClicked: Activity.start(items, url, numberOfLevels)
        }
        Bonus {
            id: bonus
        }
    }
}
