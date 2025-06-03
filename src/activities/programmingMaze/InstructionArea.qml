/* GCompris - InstructionArea.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0
import "../../core"

import "programmingMaze.js" as Activity

GridView {
    id: instructionArea
    cellWidth: buttonWidth
    cellHeight: buttonHeight

    property string instructionText: qsTr("Choose the instructions")
    required property int buttonWidth
    required property int buttonHeight

    interactive: false
    model: instructionModel

    header: HeaderArea {
        width: instructionArea.width
        height: activityBackground.height / 11
        headerOpacity: 1
        headerText: instructionText
    }

    property string instructionToInsert

    signal spaceKeyPressed
    signal tabKeyPressed

    onSpaceKeyPressed: {
        if(instructionArea.currentIndex != -1)
            instructionArea.currentItem.selectCurrentInstruction()
    }

    onTabKeyPressed:  {
        instructionArea.currentIndex = -1
        activityBackground.areaWithKeyboardInput = mainFunctionCodeArea
    }

    highlight: Rectangle {
        width: instructionArea.buttonWidth
        height: instructionArea.buttonHeight
        color: "#00ffffff"
        border.width: GCStyle.midBorder
        border.color: "#e77935"
        z: 2
        radius: GCStyle.tinyMargins
    }
    highlightFollowsCurrentItem: true
    keyNavigationWraps: true

    delegate: Item {
        id: instructionItem
        width: instructionArea.buttonWidth
        height: instructionArea.buttonHeight

        Rectangle {
            id: imageHolder
            width: parent.width - GCStyle.midBorder
            height: parent.height - GCStyle.midBorder
            border.width: GCStyle.thinnestBorder
            border.color: "#2a2a2a"
            anchors.centerIn: parent
            radius: GCStyle.tinyMargins
            color: instructionArea.instructionToInsert == name ? "#f3bc9a" : "#ffffff"

            Image {
                id: icon
                source: Activity.url + name + ".svg"
                width: Math.round(Math.min(parent.width, parent.height) * 0.8)
                height: width
                sourceSize.width: width
                sourceSize.height: width
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: items.isRunCodeEnabled && ((items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed) || procedureCodeArea.isEditingInstruction || mainFunctionCodeArea.isEditingInstruction)

            onPressed: instructionItem.checkModelAndInsert()
        }

        function selectCurrentInstruction() {
            if(!mainFunctionCodeArea.isEditingInstruction && !procedureCodeArea.isEditingInstruction) {
                instructionArea.instructionToInsert = name
                playClickedAnimation()
            }
            else {
                if(mainFunctionCodeArea.isEditingInstruction)
                    insertIntoModel(mainFunctionModel, mainFunctionCodeArea)
                if(procedureCodeArea.isEditingInstruction && (name !== Activity.CALL_PROCEDURE) && (name !== Activity.EXECUTE_LOOPS))
                    insertIntoModel(procedureModel, procedureCodeArea)
            }
        }

        function checkModelAndInsert() {
            if(!activityBackground.insertIntoMain && (name !== Activity.CALL_PROCEDURE) && (name !== Activity.EXECUTE_LOOPS))
                insertIntoModel(procedureModel, procedureCodeArea)
            else if(activityBackground.insertIntoMain)
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
                    playClickedAnimation()
                    model.append({ "name": name })
                    items.numberOfInstructionsAdded++
                }
            }
            else {
                playClickedAnimation()
                model.set(area.initialEditItemIndex, {"name": name})
                area.resetEditingValues()
            }
        }

        /**
         * If two successive clicks on the same icon are made very fast, stop the ongoing animation and set the scale back to 1.
         * Then start the animation for next click.
         * This gives proper feedback of multiple clicks.
         */
        function playClickedAnimation() {
            clickedAnimation.stop()
            icon.scale = 1
            clickedAnimation.start()
        }

        SequentialAnimation {
            id: clickedAnimation
            PropertyAnimation {
                target: imageHolder
                property: "scale"
                to: 0.8
                duration: 150
            }

            PropertyAnimation {
                target: imageHolder
                property: "scale"
                to: 1
                duration: 150
            }
        }
    }
}
