/* GCompris - rahulworld.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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

import "../../core"
import "rahulworld.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Image {
            id: bg
            source: dataset.item.backgroundImage
            sourceSize.width: 2000 * ApplicationInfo.ratio
            sourceSize.height: 2000 * ApplicationInfo.ratio
            width: 2000 * background.playRatio
            height: width
            anchors.centerIn: parent
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors.centerIn: parent
            text: "Explore and Know about Enviroment"
            fontSize: largeSize
        }
        Rectangle {
            id: button
            property color buttonColor: "lightblue"
            property color onHoverColor: "gold"
            property color borderColor: "white"

            signal buttonClick()

            onButtonClick: {
                console.log(buttonLabel.text + " Hello, Enviroment")
            }

            MouseArea{
                onClicked: buttonClick()
                hoverEnabled: true
                onEntered: parent.border.color = onHoverColor
                onExited:  parent.border.color = borderColor
            }

            // Determines the color of the button by using the conditional operator
            color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor
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
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
