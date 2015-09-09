/* GCompris - programmingMaze.qml
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
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

import "programmingMaze.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int oldWidth: width
    onWidthChanged: {
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#8C8984"

        signal start
        signal stop

        property bool keyNavigation: false
        property bool insertIntoMain: true
        property bool insertIntoProcedure: false

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
            property alias answerSheet: answerSheet
            property alias procedureModel: procedureModel
            property alias procedure: procedure
            property alias player: player
            property alias fish: fish
            property alias runCodeImage: runCode.source
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

        ListModel {
            id: procedureModel
        }

        Repeater {
            id: mazeModel
            model: Activity.mazeBlocks[0]

            anchors.left: parent.left
            anchors.top: parent.top

            Image {
                x: modelData[0] * background.width / 10
                y: modelData[1] * (background.height - background.height/10) / 10
                width: background.width / 10
                height: background.height / 10
                source: Activity.reverseCountUrl + "iceblock.svg"
            }
        }

        Image {
            id: player
            source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
            sourceSize.width: background.width / 12
            x: 0; y: 0; z: 11
            property int duration: 1000
            property bool tuxIsBusy: false

            signal init

            onInit: {
                player.rotation = Activity.EAST
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
            sourceSize.width: background.width / 12
            x: 0; y: 0; z: 5
        }

        property int buttonWidth: background.width / 10
        property int buttonHeight: background.height / 10

        GridView {
            id: instruction
            width: parent.width * 0.5
            height: parent.height * 0.3 + 25 * ApplicationInfo.ratio
            cellWidth: background.buttonWidth
            cellHeight: background.buttonHeight

            anchors.left: parent.left
            anchors.bottom: runCode.top
            anchors.top: mazeModel.bottom
            anchors.topMargin: background.buttonHeight * 4
            anchors.bottomMargin: runCode.height / 2

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
                    }


                    Image {
                        source: "qrc:/gcompris/src/core/resource/button.svg"
                        sourceSize {  height: parent.height; width: parent.width }
                        width: sourceSize.width
                        height: sourceSize.height
                    }

                    MouseArea {
                        id: mouseAreaInstruction
                        anchors.fill: parent
                        signal clicked
                        onClicked: {
                            insertIntoModel()
                        }
                        onPressed: {
                            insertIntoModel()
                        }
                        function insertIntoModel() {
                            clickedAnim.start()
                            if(background.insertIntoProcedure && name != Activity.CALL_PROCEDURE) {
                                procedureModel.append({"name": name})
                            }
                            if(background.insertIntoMain) {
                                answerModel.append({"name": name})
                            }
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

        AnswerSheet {
            id: answerSheet
            background: background
            currentModel: answerModel
            anchors.right: parent.right
            anchors.top: answerHeaderComponent.bottom
        }

        AnswerSheet {
            id: procedure
            background: background
            currentModel: procedureModel
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: bar.level > 2
        }

        Image {
            id: runCode
            width: background.width / 10
            height: background.height / 10
            anchors.right: instruction.right
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio

            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            fillMode: Image.PreserveAspectFit


            MouseArea {
                id: runCodeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: runCode.scale = 1.1
                onClicked: {
                    // todo add a condition to disable it if code is running
                    // either the execution hasn't started or stopped because of deadEndPoint
                    if(Activity.codeIterator == 0 || Activity.deadEndPoint) {
                        console.log(Activity.codeIterator +" value of codeIterator")
                        Activity.runCode()
                    }
                }
                onExited: runCode.scale = 1
            }
        }



        Component {
            id: instructionHeaderComponent
            Rectangle {
                id: headerRect
                width: instruction.width
                height: 25 * ApplicationInfo.ratio
                color: "#005B9A"

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize { height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                }

                GCText {
                    id: headerText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Font.DemiBold
                    minimumPointSize: 7
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: qsTr("Choose the instructions")
                }
            }
        }

        Item {
            id: answerHeaderComponent
            width: answerSheet.width
            height: 50 * ApplicationInfo.ratio
            anchors.left: answerSheet.left
            anchors.top: parent.top

            Rectangle {
                id: answerHeaderRect
                anchors.fill: parent
                color: "#005B9A"
                opacity: background.insertIntoMain ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        background.insertIntoMain = true
                        background.insertIntoProcedure = false
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                }

                GCText {
                    id: answerHeaderText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Font.DemiBold
                    minimumPointSize: 7
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: qsTr("Your Code")
                }
            }
        }

        Item{
            id: procedureHeaderComponent
            width: procedure.width
            height: 50 * ApplicationInfo.ratio
            anchors.left: procedure.left
            anchors.bottom: procedure.top
            visible: procedure.visible
            Rectangle {
                id: procedureHeaderRect
                anchors.fill: parent
                color: "#005B9A"
                opacity: background.insertIntoProcedure ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        background.insertIntoMain = false
                        background.insertIntoProcedure = true
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize {  height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                }

                GCText {
                    id: procedureHeaderText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Font.DemiBold
                    minimumPointSize: 7
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    color: "white"
                    text: qsTr("Your procedure")
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
            onReloadClicked: Activity.reloadLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
