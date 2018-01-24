/* GCompris - ProgrammingMaze.qml
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
        property alias items: items

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
            property alias mainFunctionModel: mainFunctionModel
            property alias mainFunctionCodeArea: mainFunctionCodeArea
            property alias procedureModel: procedureModel
            property alias procedureCodeArea: procedureCodeArea
            property alias player: player
            property alias constraintInstruction: constraintInstruction
            property alias tutorialImage: tutorialImage
            property bool isRunCodeEnabled: true
            property bool isTuxMouseAreaEnabled: false
            property int maxNumberOfInstructionsAllowed
            property int numberOfInstructionsAdded
        }

        //This function catches the signal emitted after completion of movement of Tux after executing each instruction.
        function currentInstructionExecutionComplete() {
            Activity.checkSuccessAndExecuteNextInstruction()
        }

        //This function catches the signal emitted after finding a dead-end in any of the executing instruction.
        function deadEnd() {
            Activity.deadEnd()
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
        Keys.onLeftPressed: {
            keyNavigation = true
            instruction.moveCurrentIndexLeft()
        }
        Keys.onDownPressed: {
            keyNavigation = true
            instruction.moveCurrentIndexDown()
        }
        Keys.onUpPressed: {
            keyNavigation = true
            instruction.moveCurrentIndexUp()
        }
        Keys.onSpacePressed: {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }
        Keys.onEnterPressed: {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }
        Keys.onReturnPressed: {
            keyNavigation = true
            instruction.currentItem.mouseAreaInstruction.clicked()
        }

        ListModel {
            id: instructionModel
        }

        ListModel {
            id: mainFunctionModel
        }

        ListModel {
            id: procedureModel
        }

        Rectangle {
            id: constraintInstruction
            anchors.left: parent.left
            anchors.bottom: runCode.top
            width: parent.width / 2.3
            height: parent.height / 8.6
            radius: 10
            z: 3
            color: "#E8E8E8" //paper white
            border.width: 3 * ApplicationInfo.ratio
            border.color: "#87A6DD"  //light blue

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function changeConstraintInstructionOpacity() {
                if(opacity)
                    constraintInstruction.hide()
                else
                    constraintInstruction.show()
            }

            function show() {
                if(instructionText.text)
                    opacity = 0.8
            }
            function hide() {
                opacity = 0
            }

            GCText {
                id: instructionText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: qsTr("Reach the fish in less than %1 instructions.").arg(items.maxNumberOfInstructionsAllowed)
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: constraintInstruction.changeConstraintInstructionOpacity()
        }

        Repeater {
            id: mazeModel
            model: Activity.mazeBlocks[0]

            anchors.left: parent.left
            anchors.top: parent.top

            Image {
                x: modelData[0] * width
                y: modelData[1] * height
                width: background.width / 10
                height: (background.height - background.height / 10) / 10
                source: Activity.reverseCountUrl + "iceblock.svg"

                Image {
                    id: fish
                    anchors.centerIn: parent
                    sourceSize.width: background.width / 12
                    source: (modelData[0] == Activity.mazeBlocks[Activity.currentLevel].fish[0] && modelData[1] == Activity.mazeBlocks[Activity.currentLevel].fish[1]) ? Activity.reverseCountUrl + "blue-fish.svg" : ""
                    z: 5
                }
            }
        }

        Image {
            id: player
            source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
            sourceSize.width: background.width / 12
            property int duration: 1000
            readonly property real playerCenterX: x + width / 2
            readonly property real playerCenterY: y + height / 2
            rotation: 0

            signal init

            onInit: {
                player.rotation = Activity.EAST
            }

            MouseArea {
                id: tuxMouseArea
                anchors.fill: parent
                enabled: items.isTuxMouseAreaEnabled
                onClicked: {
                    mainFunctionCodeArea.highlightFollowsCurrentItem = false
                    Activity.resetTux = true
                    Activity.initLevel()
                }
            }
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
                        sourceSize { width: parent.width; height: parent.height }
                        width: sourceSize.width
                        height: sourceSize.height
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Image {
                        source: "qrc:/gcompris/src/core/resource/button.svg"
                        sourceSize { height: parent.height; width: parent.width }
                        width: sourceSize.width
                        height: sourceSize.height
                    }

                    MouseArea {
                        id: mouseAreaInstruction
                        anchors.fill: parent
                        enabled: (items.isTuxMouseAreaEnabled || items.isRunCodeEnabled) && (items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed || procedureCodeArea.isEditingInstruction || mainFunctionCodeArea.isEditingInstruction)

                        signal clicked

                        onClicked: {
                            checkModelAndInsert()
                        }
                        onPressed: {
                            checkModelAndInsert()
                        }

                        function checkModelAndInsert() {
                            if(items.constraintInstruction.opacity)
                                items.constraintInstruction.hide()

                            if(background.insertIntoProcedure && name != Activity.CALL_PROCEDURE)
                                insertIntoModel(procedureModel, procedureCodeArea)
                            else if(background.insertIntoMain)
                                insertIntoModel(mainFunctionModel, mainFunctionCodeArea)
                        }

                        /**
                         * If we are adding an instruction, append it to the model if number of instructions added is less than the maximum number of instructions allowed.
                         * If editing, replace it with the selected instruction in the code area.
                         */
                        function insertIntoModel(model, area) {
                            if(!area.isEditingInstruction) {
                                if(items.numberOfInstructionsAdded >= items.maxNumberOfInstructionsAllowed)
                                    constraintInstruction.changeConstraintInstructionOpacity()
                                else {
                                    clickedAnim.start()
                                    model.append({ "name": name })
                                    items.numberOfInstructionsAdded++
                                }
                            }
                            else {
                                clickedAnim.start()
                                model.set(area.initialEditItemIndex, {"name": name}, 1)
                                area.isEditingInstruction = false
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
            id: mainFunctionCodeArea
            background: background
            currentModel: mainFunctionModel
            anchors.right: parent.right
            anchors.top: mainFunctionHeaderComponent.bottom
        }

        AnswerSheet {
            id: procedureCodeArea
            background: background
            currentModel: procedureModel
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: bar.level >= 6
            property alias procedureIterator: procedureCodeArea.currentIndex
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
                hoverEnabled: ApplicationInfo.isMobile ? false : (!items.isRunCodeEnabled ? false : true)
                enabled: items.isRunCodeEnabled
                onEntered: runCode.scale = 1.1
                onClicked: {
                    runCodeClickAnimation.start()

                    if(constraintInstruction.opacity)
                        constraintInstruction.hide()

                    Activity.runCode()
                }
                onExited: runCode.scale = 1
            }

            SequentialAnimation {
                id: runCodeClickAnimation
                NumberAnimation { target: runCode; property: "scale"; to: 0.8; duration: 100 }
                NumberAnimation { target: runCode; property: "scale"; to: 1.0; duration: 100 }
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
            id: mainFunctionHeaderComponent
            width: mainFunctionCodeArea.width
            height: 50 * ApplicationInfo.ratio
            anchors.left: mainFunctionCodeArea.left
            anchors.top: parent.top

            Rectangle {
                id: mainFunctionHeaderRect
                anchors.fill: parent
                color: "#005B9A"
                opacity: background.insertIntoMain ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
                    onClicked: {
                        background.insertIntoMain = true
                        background.insertIntoProcedure = false
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize { height: parent.height; width: parent.width }
                    width: sourceSize.width
                    height: sourceSize.height
                }

                GCText {
                    id: mainFunctionHeaderText
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
                    text: qsTr("Main function")
                }
            }
        }

        Item {
            id: procedureHeaderComponent
            width: procedureCodeArea.width
            height: 50 * ApplicationInfo.ratio
            anchors.left: procedureCodeArea.left
            anchors.bottom: procedureCodeArea.top
            visible: procedureCodeArea.visible
            Rectangle {
                id: procedureHeaderRect
                anchors.fill: parent
                color: "#005B9A"
                opacity: background.insertIntoProcedure ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
                    onClicked: {
                        background.insertIntoMain = false
                        background.insertIntoProcedure = true
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svg"
                    sourceSize { height: parent.height; width: parent.width }
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
                    text: qsTr("Procedure")
                }
            }
        }

        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            z: 5
            visible: true

            property bool shownProcedureTutorialInstructions: false

            Tutorial {
                id:tutorialSection
                tutorialDetails: bar.level <= 2 ? Activity.mainTutorialInstructions : Activity.procedureTutorialInstructions
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                    tutorialNumber = 0
                }
            }
            onVisibleChanged: {
                if(tutorialImage.visible && tutorialImage.shownProcedureTutorialInstructions)
                    tutorialSection.visible = true
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: tutorialImage.visible ? help | home : help | home | level | reload }
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
