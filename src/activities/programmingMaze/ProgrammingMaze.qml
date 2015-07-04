/* GCompris - programmingMaze.qml
 *
 * Copyright (C) 2014 Siddhesh Suthar <siddhesh.it@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import QtQuick 2.2
import "../../core"
import GCompris 1.0
import "programmingMaze.js" as Activity

import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#8C8984"
        property bool keyNavigation: false

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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias mazeModel: mazeModel
            property alias instructionModel: instructionModel
            property alias answerModel: answerModel
            property alias player: player
            property alias fish: fish
        }

        onStart: {
            Activity.start(items)
            keyNavigation = false
        }
        onStop: { Activity.stop() }


        Keys.onRightPressed: {
            keyNavigation = true
            instruction.incrementCurrentIndex()
        }
        Keys.onLeftPressed:  {
            keyNavigation = true
            instruction.decrementCurrentIndex()
        }
        Keys.onDownPressed:  {
            keyNavigation = true
            instruction.incrementCurrentIndex()
        }
        Keys.onUpPressed:  {
            keyNavigation = true
            instruction.decrementCurrentIndex()
        }
        Keys.onSpacePressed:  {
            keyNavigation = true
            instruction.currentItem.children[3].clicked()
        }
        Keys.onEnterPressed:  {
            keyNavigation = true
            instruction.currentItem.children[3].clicked()
        }
        Keys.onReturnPressed:  {
            keyNavigation = true
            instruction.currentItem.children[3].clicked()
        }

        ListModel {
            id: instructionModel
            ListElement {
                name: "Move Forward"
            }
            ListElement {
                name: "Turn Left"
            }
            ListElement {
                name: "Turn Right"
            }
        }

        ListModel {
            id: answerModel
        }

        Repeater {
            id: mazeModel
            model: Activity.mazeBlocks[0]

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: instruction.top

            Image {
                x: modelData[0] * background.width / 8
                y: modelData[1] * (background.height - background.height/8) / 8
                width: background.width / 8
                height: background.height / 8
                source: Activity.reverseCountUrl + "iceblock.svg"
            }
        }

        Image {
            id: player
            source: "qrc:/gcompris/src/activities/maze/resource/" + "tux_top_south.svg"
            sourceSize.width: background.width / 10
            x: 0; y: 0; z: 11
            property int duration: 1000

            signal init

            onInit: {
               player.rotation = -90
//               Activity.runCode()
            }

            Behavior on x {
                SmoothedAnimation {
//                    reversingMode: SmoothedAnimation.Immediate
//                    onRunningChanged: Activity.playerRunningChanged()
                    duration: player.duration
                }
            }
            Behavior on y {
                SmoothedAnimation {
//                    reversingMode: SmoothedAnimation.Immediate
//                    onRunningChanged: Activity.playerRunningChanged()
                    duration: player.duration
                }
            }
            Behavior on rotation {
                RotationAnimation {
                    duration: player.duration / 2
                    direction: RotationAnimation.Shortest
                }
            }

        }

        Image {
            id: fish
            source: Activity.reverseCountUrl + "blue-fish.svg"
            sourceSize.width: background.width / 10
//            anchors.leftMargin: 20 * ApplicationInfo.ratio

            width: background.width / 10
            height: (background.height - background.height/10) / 10
            x: 0; y: 0; z: 5
        }

        ListView {
            id: instruction
            width: parent.width * 0.625
            height: parent.height * 0.375 - bar.height / 2

            anchors.left: parent.left
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: bar.height / 2

            orientation: Qt.Vertical
            verticalLayoutDirection: ListView.TopToBottom
            spacing: 5 * ApplicationInfo.ratio
            interactive: false
            model: instructionModel

            header: instructionHeaderComponent

            highlight: Rectangle {
                width: instruction.width
                height: instruction.buttonHeight
                color: "lightsteelblue"
                border.width: 3
                border.color: "black"
                visible: background.keyNavigation
                y: instruction.currentItem.y
                Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
            }
            highlightFollowsCurrentItem: false
            focus: true
            keyNavigationWraps: true

            property int buttonHeight: instruction.height / instructionModel.count - instruction.spacing

            delegate: Item {
                width: instruction.width - instruction.spacing
                height: instruction.buttonHeight

                Rectangle {
                    id: rect
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#0191C8" }
                        GradientStop { position: 1.0; color: "#005B9A" }
                    }
                    opacity: 0.5

                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                    smooth: false
                }

                GCText {
                    id: instructionText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: instruction.width
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: regularSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: name
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    signal clicked
                    onClicked: {
                        clickedAnim.start()
                        answerModel.append({"name": instructionText.text, "selected": false})
                    }
                    onPressed: {
                        clickedAnim.start()
                        answerModel.append({"name": instructionText.text, "selected": false})
                    }
                }

                SequentialAnimation {
                    id: clickedAnim
                    PropertyAnimation {
                        target: rect
                        property: "opacity"
                        to: "1"
                        duration: 300
                    }

                    PropertyAnimation {
                        target: rect
                        property: "opacity"
                        to: "0.5"
                        duration: 300
                    }
                }
            }
        }

        // insert data upon clicking the list items into this answerData
        // and then process it to run the code

        ListView {
            id: answerSheet

            width: parent.width * 0.350
            height: parent.height * 0.80 - bar.height
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10 * ApplicationInfo.ratio

            orientation: Qt.Vertical
            verticalLayoutDirection: ListView.TopToBottom
            spacing: 5 * ApplicationInfo.ratio
            interactive: false
            model: answerModel

            header: answerHeaderComponent
            footer: answerFooterComponent

            delegate: Item {
                width: answerSheet.width - answerSheet.spacing
                height: answerSheet.height / answerModel.count - answerSheet.spacing

                Rectangle {
                    id: answerRect
                    anchors.fill: parent
                    color: "#005B9A"
                    opacity: 1
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                    smooth: false
                }

                GCText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: regularSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: name
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/bar_exit.svg"
                    sourceSize {  height: parent.height ; width: parent.width }
                    width: sourceSize.width / 8
                    height: sourceSize.height / 3
                    smooth: false

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10 * ApplicationInfo.ratio

                    MouseArea {
                        id: answerRemove
                        anchors.fill: parent
                        onPressed: {
                            answerModel.remove(model.index)
                        }
                    }

                }

            }
        }

        Component {
            id: answerFooterComponent
            Image {
                id: runCode
                source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                width: background.width / 8
                height: background.height / 8
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id: runCodeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: runCode.scale = 1.1
                    onClicked: {
                        console.log(answerModel)
                        Activity.runCode()
                    }
                    onExited: runCode.scale = 1
                }
            }
        }



        Component {
            id: instructionHeaderComponent
            Rectangle {
                id: headerRect
                width: ListView.view.width
                height: 40 * ApplicationInfo.ratio
                color: "#005B9A"
                opacity: 1

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                    smooth: false
                }

                GCText {
                    id: headerText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    fontSizeMode: Font.DemiBold
                    minimumPointSize: 7
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: qsTr("Choose the instructions")
                }
            }
        }

        Component {
            id: answerHeaderComponent
            Rectangle {
                id: answerHeaderRect
                width: ListView.view.width
                height: 40 * ApplicationInfo.ratio
                color: "#005B9A"
                opacity: 1

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                    smooth: false
                }

                GCText {
                    id: answerHeaderText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    fontSizeMode: Font.DemiBold
                    minimumPointSize: 7
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: qsTr("Your Code")
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
