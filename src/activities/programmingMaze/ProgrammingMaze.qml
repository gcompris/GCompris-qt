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

    property bool keyboardNavigationVisible: false

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/programmingMaze/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        signal start
        signal stop

        property bool insertIntoMain: true
        property bool insertIntoProcedure: false
        property alias items: items
        property int buttonWidth: background.width / 10
        property int buttonHeight: background.height / 15.3

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
            property alias instruction: instruction
            property alias player: player
            property alias constraintInstruction: constraintInstruction
            property alias tutorialImage: tutorialImage
            property alias fish: fish
            property bool isRunCodeEnabled: true
            property bool isTuxMouseAreaEnabled: false
            property bool currentLevelContainsProcedure
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
        }
        onStop: { Activity.stop() }

        Keys.onRightPressed: {
            activity.keyboardNavigationVisible = true
            instruction.moveCurrentIndexRight()
        }
        Keys.onLeftPressed: {
            activity.keyboardNavigationVisible = true
            instruction.moveCurrentIndexLeft()
        }
        Keys.onDownPressed: {
            activity.keyboardNavigationVisible = true
            instruction.moveCurrentIndexDown()
        }
        Keys.onUpPressed: {
            activity.keyboardNavigationVisible = true
            instruction.moveCurrentIndexUp()
        }
        Keys.onSpacePressed: {
            if(instruction.currentIndex != -1)
                instruction.currentItem.mouseAreaInstruction.clicked()
        }
        Keys.onEnterPressed: runCodeOrResetTux()
        Keys.onReturnPressed: runCodeOrResetTux()
        Keys.onTabPressed:  {
            activity.keyboardNavigationVisible = true
            changeFocus("main")
        }

        function changeFocus(currentCodeArea) {
            if(currentCodeArea === "main") {
                mainFunctionCodeArea.forceActiveFocus()
                background.insertIntoMain = true
                background.insertIntoProcedure = false
                instruction.currentIndex = -1
                activeCodeAreaIndicator.changeActiveCodeAreaIndicator(mainFunctionCodeArea)
            }
            else if(currentCodeArea === "procedure") {
                procedureCodeArea.forceActiveFocus()
                background.insertIntoMain = false
                background.insertIntoProcedure = true
                mainFunctionCodeArea.currentIndex = -1
                activeCodeAreaIndicator.changeActiveCodeAreaIndicator(procedureCodeArea)
            }
            else if(currentCodeArea === "instruction") {
                activity.forceActiveFocus()
                background.insertIntoMain = true
                background.insertIntoProcedure = false
                Activity.resetCodeAreasIndices()
                instruction.currentIndex = 0
                activeCodeAreaIndicator.changeActiveCodeAreaIndicator(instruction)
            }
        }

        function runCodeOrResetTux() {
            if(!Activity.deadEndPoint)
                runCodeMouseArea.executeCode()
            else
                Activity.initLevel()
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
            height: parent.height / 8.9
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

                readonly property string resetTuxInstructionText: qsTr("Click on Tux or press Enter key to reset it or RELOAD button to reload the level.")
                readonly property string constraintInstructionText: qsTr("Reach the fish in less than %1 instructions.").arg(items.maxNumberOfInstructionsAllowed)

                text: items.isTuxMouseAreaEnabled ? resetTuxInstructionText : constraintInstructionText
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
                x: modelData.x * width
                y: modelData.y * height
                width: background.width / 10
                height: (background.height - background.height / 10) / 10
                source: Activity.reverseCountUrl + "iceblock.svg"
            }
        }

        Image {
            id: fish
            sourceSize.width: background.width / 12
            source: Activity.reverseCountUrl + "blue-fish.svg"
        }

        Image {
            id: player
            source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
            sourceSize.width: background.width / 12
            z: 1
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
                    Activity.initLevel()
                }
            }
        }

        Rectangle {
            id: activeCodeAreaIndicator
            opacity: 0.5

            function changeActiveCodeAreaIndicator(activeArea) {
                anchors.top = activeArea.top
                anchors.fill = activeArea
            }
        }

        GridView {
            id: instruction
            width: parent.width * 0.5
            height: parent.height * 0.17
            cellWidth: background.buttonWidth
            cellHeight: background.buttonHeight

            anchors.left: parent.left
            anchors.top: mazeModel.bottom
            anchors.topMargin: background.height * 0.4

            interactive: false
            model: instructionModel

            header: instructionHeaderComponent

            property string instructionToInsert

            highlight: Rectangle {
                width: buttonWidth - 3 * ApplicationInfo.ratio
                height: buttonHeight * 1.18 - 3 * ApplicationInfo.ratio
                color: "lightsteelblue"
                border.width: 3.5 * ApplicationInfo.ratio
                border.color: "purple"
                y: 1.5 * ApplicationInfo.ratio
                z: 2
                radius: width / 18
                opacity: 0.6
                visible: activity.keyboardNavigationVisible
            }
            highlightFollowsCurrentItem: true
            keyNavigationWraps: true

            delegate: Item {
                width: background.buttonWidth
                height: background.buttonHeight * 1.18

                property alias mouseAreaInstruction: mouseAreaInstruction

                Rectangle {
                    id: rect
                    width: parent.width - 3 * ApplicationInfo.ratio
                    height: parent.height - 3 * ApplicationInfo.ratio
                    border.width: 1.2 * ApplicationInfo.ratio
                    border.color: "black"
                    anchors.centerIn: parent
                    radius: width / 18

                    Image {
                        id: icon
                        source: Activity.url + name + ".svg"
                        sourceSize { width: parent.width / 1.2; height: parent.height / 1.2 }
                        anchors.centerIn: parent
                    }
                }

                MouseArea {
                    id: mouseAreaInstruction
                    anchors.fill: parent
                    enabled: (items.isTuxMouseAreaEnabled || items.isRunCodeEnabled) && (items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed || procedureCodeArea.isEditingInstruction || mainFunctionCodeArea.isEditingInstruction)

                    signal clicked

                    onClicked: {
                        if(!mainFunctionCodeArea.isEditingInstruction && !procedureCodeArea.isEditingInstruction) {
                            instruction.instructionToInsert = name
                            playClickedAnimation()
                        }
                        else {
                            if(mainFunctionCodeArea.isEditingInstruction)
                                replaceInstruction(mainFunctionModel, mainFunctionCodeArea)
                            if(procedureCodeArea.isEditingInstruction && name != "call-procedure")
                                replaceInstruction(procedureModel, procedureCodeArea)
                        }
                    }
                    onPressed: {
                        checkModelAndInsert()
                    }

                    function appendInstruction(model, area) {
                        if(items.numberOfInstructionsAdded >= items.maxNumberOfInstructionsAllowed)
                            constraintInstruction.changeConstraintInstructionOpacity()
                        else {
                            playClickedAnimation()
                            model.append({ "name": name })
                            items.numberOfInstructionsAdded++
                        }
                    }

                    function replaceInstruction(model, area) {
                        playClickedAnimation()
                        model.set(area.initialEditItemIndex, {"name": name}, 1)
                        area.resetEditingValues()
                    }

                    function checkModelAndInsert() {
                        if(items.constraintInstruction.opacity)
                            items.constraintInstruction.hide()

                        if(background.insertIntoProcedure && (name != Activity.CALL_PROCEDURE))
                            insertIntoModel(procedureModel, procedureCodeArea)
                        else if(background.insertIntoMain)
                            insertIntoModel(mainFunctionModel, mainFunctionCodeArea)
                    }

                    /**
                     * If we are adding an instruction, append it to the model if number of instructions added is less than the maximum number of instructions allowed.
                     * If editing, replace it with the selected instruction in the code area.
                     */
                    function insertIntoModel(model, area) {
                        if(!area.isEditingInstruction)
                            appendInstruction(model, area)
                        else
                            replaceInstruction(model, area)
                    }

                    /**
                     * If two successive clicks on the same icon are made very fast, stop the ongoing animation and set the scale back to 1.
                     * Then start the animation for next click.
                     * This gives proper feedback of multiple clicks.
                     */
                    function playClickedAnimation() {
                        clickedAnim.stop()
                        icon.scale = 1
                        clickedAnim.start()
                    }
                }

                SequentialAnimation {
                    id: clickedAnim
                    PropertyAnimation {
                        target: rect
                        property: "scale"
                        to: 0.8
                        duration: 150
                    }

                    PropertyAnimation {
                        target: rect
                        property: "scale"
                        to: 1
                        duration: 150
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

            Keys.onTabPressed: {
                if(!items.currentLevelContainsProcedure)
                    background.changeFocus("instruction")
                else
                    background.changeFocus("procedure")
            }
        }

        AnswerSheet {
            id: procedureCodeArea
            background: background
            currentModel: procedureModel
            anchors.right: parent.right
            anchors.top: procedureHeaderComponent.bottom
            visible: items.currentLevelContainsProcedure
            property alias procedureIterator: procedureCodeArea.currentIndex

            Keys.onTabPressed: background.changeFocus("instruction")
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

                signal executeCode

                onEntered: runCode.scale = 1.1
                onExecuteCode: startCodeExecution()
                onClicked: startCodeExecution()
                onExited: runCode.scale = 1

                function startCodeExecution() {
                    runCodeClickAnimation.start()
                    Activity.resetCodeAreasIndices()

                    if(constraintInstruction.opacity)
                        constraintInstruction.hide()

                    Activity.runCode()
                }
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
                id: instructionHeaderRectangle
                width: instruction.width
                height: background.height / 11
                border.width: 2 * ApplicationInfo.ratio
                border.color: "black"
                color: "transparent"

                Image {
                    id: instructionHeaderImage
                    width: parent.width - 2 * parent.border.width
                    height: parent.height - 2 * parent.border.width
                    source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
                    x: parent.border.width
                    y: x

                    GCText {
                        id: instructionHeaderText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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
        }

        Rectangle {
            id: mainFunctionHeaderComponent
            width: mainFunctionCodeArea.width
            height: parent.height / 10
            anchors.left: mainFunctionCodeArea.left
            anchors.top: parent.top
            border.width: 2 * ApplicationInfo.ratio
            border.color: "black"
            color: "transparent"

            Image {
                id: mainFunctionHeaderImage
                width: parent.width - 2 * parent.border.width
                height: parent.height - 2 * parent.border.width
                x: parent.border.width
                y: x
                source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
                opacity: background.insertIntoMain ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
                    onClicked: {
                        background.insertIntoMain = true
                        background.insertIntoProcedure = false
                    }
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

        Rectangle {
            id: procedureHeaderComponent
            width: procedureCodeArea.width
            height: parent.height / 10
            anchors.left: procedureCodeArea.left
            anchors.top: mainFunctionCodeArea.bottom
            visible: procedureCodeArea.visible
            border.width: 2 * ApplicationInfo.ratio
            border.color: "black"
            color: "transparent"

            Image {
                id: procedureHeaderImage
                width: parent.width - 2 * parent.border.width
                height: parent.height - 2 * parent.border.width
                source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW02.svg"
                x: parent.border.width
                y: x
                opacity: background.insertIntoProcedure ? 1 : 0.5

                MouseArea {
                    anchors.fill: parent
                    enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
                    onClicked: {
                        background.insertIntoMain = false
                        background.insertIntoProcedure = true
                    }
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
