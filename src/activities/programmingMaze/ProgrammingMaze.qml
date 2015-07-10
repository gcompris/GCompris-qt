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
import GCompris 1.0
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

import "programmingMaze.js" as Activity

import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int oldWidth: width
    onWidthChanged: {
        // Reposition planets and asteroids, same for height
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition planets and asteroids, same for height
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }



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
            property GCAudio audioEffects: activity.audioEffects
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
            instruction.moveCurrentIndexRight()
        }
        Keys.onLeftPressed:  {
            keyNavigation = true
            instruction.moveCurrentIndexLeft()
        }
        Keys.onDownPressed:  {
            keyNavigation = true
            instruction.moveCurrentIndexDown()
        }
        Keys.onUpPressed:  {
            keyNavigation = true
            instruction.moveCurrentIndexUp()
        }
        Keys.onSpacePressed:  {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }
        Keys.onEnterPressed:  {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }
        Keys.onReturnPressed:  {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }

        ListModel {
            id: instructionModel
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
            property bool tuxIsBusy: false

            signal init

            onInit: {
                player.rotation = -90
            }

            onTuxIsBusyChanged: {
                Activity.playerRunningChanged()
            }

            Behavior on x {
                SmoothedAnimation {
                    duration: player.duration
                    reversingMode: SmoothedAnimation.Immediate
                    onRunningChanged: {
                        player.tuxIsBusy = !player.tuxIsBusy
                    }
                }
            }

            Behavior on y {
                SmoothedAnimation {
                    duration: player.duration
                    reversingMode: SmoothedAnimation.Immediate
                    onRunningChanged: {
                        player.tuxIsBusy = !player.tuxIsBusy
                    }
                }
            }


            Behavior on rotation {
                RotationAnimation {
                    duration: player.duration / 2
                    direction: RotationAnimation.Shortest
                    onRunningChanged: {
                        player.tuxIsBusy = !player.tuxIsBusy
                    }
                }
            }

        }

        Image {
            id: fish
            source: Activity.reverseCountUrl + "blue-fish.svg"
            sourceSize.width: background.width / 10
            //            anchors.leftMargin: 20 * ApplicationInfo.ratio
            x: 0; y: 0; z: 5
        }

        property int buttonWidth: background.width / 10
        property int buttonHeight: background.height / 10
        property int answerButtonWidth: background.width / 10
        property int answerButtonHeight: background.height / 10

        GridView {
            id: instruction
            width: parent.width * 0.625
            height: parent.height * 0.375 - bar.height / 2
            cellWidth: background.buttonWidth
            cellHeight: background.buttonHeight

            anchors.left: parent.left
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: bar.height / 2

            interactive: false
            model: instructionModel

            header: instructionHeaderComponent

            highlight: Rectangle {
                width: buttonWidth
                height: buttonHeight
                color: "lightsteelblue"
                border.width: 3
                border.color: "black"
                visible: background.keyNavigation
                x: instruction.currentItem.x
                Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
            }
            highlightFollowsCurrentItem: false
            focus: true
            keyNavigationWraps: true

            delegate: Column {
                spacing: 10 * ApplicationInfo.ratio
                property alias mouseAreaInstruction: mouseAreaInstruction

                Item {
                    width: background.buttonWidth
                    height: background.buttonHeight

                    Rectangle {
                        id: rect
                        width: parent.width
                        height: parent.height
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#0191C8" }
                            GradientStop { position: 1.0; color: "#005B9A" }
                        }
                        opacity: 0.5

                    }

                    Image {
                        id: icon
                        source: Activity.url + name + ".svg"
                        sourceSize {width: parent.width; height: parent.height}
                        width: sourceSize.width
                        height: sourceSize.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        smooth: false
                    }


                    Image {
                        source: "qrc:/gcompris/src/core/resource/button.svg"
                        sourceSize {  height: parent.height; width: parent.width }
                        width: sourceSize.width
                        height: sourceSize.height
                        smooth: false
                    }

                    MouseArea {
                        id: mouseAreaInstruction
                        anchors.fill: parent
                        signal clicked
                        onClicked: {
                            clickedAnim.start()
                            answerModel.append({"name": name})
                        }
                        onPressed: {
                            clickedAnim.start()
                            answerModel.append({"name": name})
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
        }

        // insert data upon clicking the list items into this answerData
        // and then process it to run the code

        GridView {
            id: answerSheet

            width: parent.width * 0.350
            height: parent.height * 0.80 - bar.height
            cellWidth: background.answerButtonWidth
            cellHeight: background.answerButtonHeight
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10 * ApplicationInfo.ratio

            interactive: false
            model: answerModel
            clip: true
            header: answerHeaderComponent

            delegate: Column {

                Item {
                    width: background.answerButtonWidth
                    height: background.answerButtonHeight

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

                    Image {
                        id: answer
                        source: Activity.url + name + ".svg"
                        sourceSize { width: parent.width; height: parent.height  }
                        width: sourceSize.width
                        height: sourceSize.height
                        anchors.centerIn: parent
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        smooth: false

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
        }


        Item {
            width: background.width / 8
            height: background.height / 8
            anchors.top: answerSheet.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: answerSheet.left

            Image {
                id: runCode
                width: parent.width
                height: parent.height

                source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                fillMode: Image.PreserveAspectFit


                MouseArea {
                    id: runCodeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: runCode.scale = 1.1
                    onClicked: {
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
                width: instruction.width
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
                width: answerSheet.width
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
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
