/* GCompris - CodeArea.qml
 *
 * SPDX-FileCopyrightText: 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
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
    id: codeArea
    z: 1
    cellWidth: buttonWidth
    cellHeight: buttonHeight

    interactive: false
    model: currentModel

    highlight: Rectangle {
        width: buttonWidth
        height: buttonHeight
        color: "#00ffffff"
        border.width: GCStyle.midBorder
        border.color: "#e77935"
        z: 11
        radius: GCStyle.tinyMargins
    }
    highlightFollowsCurrentItem: true
    keyNavigationWraps: true
    focus: true

    property ListModel currentModel
    property int draggedItemIndex: -1
    property int possibleDropIndex: -1
    property int possibleDropRemoveIndex: -1
    property int xCoordinateInPossibleDrop: -1
    property int yCoordinateInPossibleDrop: -1

    required property int buttonWidth
    required property int buttonHeight

    /**
     * Stores the index of the item which is clicked to edit.
     *
     * If the index of the item on 2nd click is same as initialEditItemIndex , then the indicator will become invisible, as it means that initially wanted to edit that instruction, but now we want to deselect it.
     *
     * If the index of the item on 2nd click is different from initialEditItemIndex, the edit indicator moves to the new item as we now want to edit that one.
     */
    property int initialEditItemIndex: -1

    // Tells if any instruction is selected for editing.
    property bool isEditingInstruction: false

    signal spaceKeyPressed
    signal tabKeyPressed
    signal deleteKeyPressed

    /**
     * There can be three possibilities here:
     *
     * 1. We want to insert an instruction at the currentIndex position.
     * 2. We want to select an instruction to edit, or deselect it.
     * 3. We want to append an instruction.
     */
    onSpaceKeyPressed: {
        if(currentIndex != -1) {
            if(instructionArea.instructionToInsert && (items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed)) {
                var isInstructionInserted = appendInstruction()
                if(isInstructionInserted) {
                    currentModel.move(currentModel.count - 1, currentIndex, 1)
                }
            }
            else {
                if((initialEditItemIndex == currentIndex) || (initialEditItemIndex == -1 && currentIndex != -1)) {
                    codeArea.isEditingInstruction = !codeArea.isEditingInstruction
                }
                if(!codeArea.isEditingInstruction) {
                    codeArea.initialEditItemIndex = -1
                } else {
                    initialEditItemIndex = currentIndex
                }

                var calculatedX = (initialEditItemIndex % 4) * codeArea.cellWidth
                var calculatedY = Math.floor(initialEditItemIndex / 4) * codeArea.cellHeight
                editInstructionIndicator.x = calculatedX + GCStyle.midBorder * 0.5
                editInstructionIndicator.y = calculatedY + GCStyle.midBorder * 0.5
            }
        }
        else if((items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed) && instructionArea.instructionToInsert) {
            appendInstruction()
        }
    }

    onDeleteKeyPressed: {
        if(currentIndex != -1) {
            currentModel.remove(currentIndex)
            items.numberOfInstructionsAdded--
        }
        resetEditingValues()
    }

    function appendInstruction() {
        if(activityBackground.insertIntoMain || (instructionArea.instructionToInsert != "call-procedure" && instructionArea.instructionToInsert != "execute-loop")) {
            currentModel.append({ "name": instructionArea.instructionToInsert })
            items.numberOfInstructionsAdded++
            instructionArea.instructionToInsert = ""
            return true
        }
        return false
    }

    function resetEditingValues() {
        initialEditItemIndex = -1
        isEditingInstruction = false
    }

    Item {
        id: dropPositionIndicator
        visible: false
        height: codeArea.buttonHeight
        width: GCStyle.midBorder

        Rectangle {
            visible: parent.visible
            anchors.centerIn: parent
            width: parent.width
            height: parent.height - GCStyle.midBorder
            color: "#e77935"
        }

        states: [
            State {
                name: "shown"
                when: codeArea.possibleDropIndex != -1
                PropertyChanges {
                    dropPositionIndicator {
                        visible: true
                        x: Math.floor(codeArea.xCoordinateInPossibleDrop / codeArea.cellWidth) *
                            codeArea.cellWidth - GCStyle.midBorder * 0.5
                        y: Math.floor(codeArea.yCoordinateInPossibleDrop / codeArea.cellHeight) *
                           codeArea.cellHeight + GCStyle.midBorder * 0.5
                    }
                }
            }
        ]
    }

    Rectangle {
        id: editInstructionIndicator
        visible: codeArea.isEditingInstruction && codeArea.count != 0
        width: codeArea.buttonWidth - GCStyle.midBorder
        height: codeArea.buttonHeight - GCStyle.midBorder
        color: "red"
        border.color: "red"
        border.width: GCStyle.midBorder * 0.5
        opacity: 0.2
        radius: GCStyle.tinyMargins
    }

    MouseArea {
        id: codeAreaMouse
        anchors.fill: parent
        enabled: items.isRunCodeEnabled
        onPressed: {
            codeArea.currentIndex = -1
            codeArea.draggedItemIndex = codeArea.indexAt(mouseX,mouseY)
            if(codeArea.draggedItemIndex === -1) {
                constraintInstruction.changeConstraintInstructionOpacity()
                codeArea.isEditingInstruction = false
            }
            else if(!codeArea.isEditingInstruction)
                codeArea.initialEditItemIndex = codeArea.draggedItemIndex
        }

        onPositionChanged: {
            var newPos = codeArea.indexAt(mouseX, mouseY)
            var calculatedX = Math.floor(mouseX / codeArea.cellWidth) * codeArea.cellWidth
            var previousIndexPosition = codeArea.indexAt(calculatedX - 1, mouseY)

            // If the user want to move an item to the end, then the new position will be after the last instruction.
            if(newPos == -1 && previousIndexPosition != -1)
                newPos = previousIndexPosition + 1

            codeArea.isEditingInstruction = false
            codeArea.xCoordinateInPossibleDrop = mouseX
            codeArea.yCoordinateInPossibleDrop = mouseY
            codeArea.possibleDropIndex = newPos
        }

        onReleased: {
            if(codeArea.draggedItemIndex != -1) {
                var draggedIndex = codeArea.draggedItemIndex
                var dropIndex = codeArea.indexAt(mouseX,mouseY)
                var calculatedX = Math.floor(mouseX / codeArea.cellWidth) * codeArea.cellWidth
                var calculatedY = Math.floor(mouseY / codeArea.cellHeight) * codeArea.cellHeight
                codeArea.draggedItemIndex = -1

                if(dropIndex == -1) {
                    var previousIndexPosition = codeArea.indexAt(calculatedX - 1, mouseY)
                    if(previousIndexPosition == -1) {
                        currentModel.remove(draggedIndex)
                        items.numberOfInstructionsAdded--
                    }
                    else {
                        currentModel.append(currentModel.get(draggedIndex))
                        currentModel.remove(draggedIndex)
                    }
                    codeArea.initialEditItemIndex = -1
                }
                else if(draggedIndex != dropIndex) {
                    if(dropIndex <= draggedIndex) {
                        // Moving instruction from right to left
                        currentModel.move(draggedIndex, dropIndex, 1)
                    }
                    else {
                        // Moving instruction from left to right
                        currentModel.move(draggedIndex, dropIndex - 1, 1)
                    }
                    codeArea.initialEditItemIndex = -1
                }
                else {
                    /**
                     * If the index of the initially selected instruction (if any) is same as the currently selected instruction,
                     * deselect it for editing, else make the current instruction as the initially editable item and move the edit indicator to that position.
                     */
                    if(codeArea.initialEditItemIndex == dropIndex) {
                        codeArea.isEditingInstruction = !codeArea.isEditingInstruction
                        if(!codeArea.isEditingInstruction)
                            codeArea.initialEditItemIndex = -1
                    }
                    else
                        codeArea.initialEditItemIndex = draggedIndex

                    editInstructionIndicator.x = calculatedX + GCStyle.midBorder * 0.5
                    editInstructionIndicator.y = calculatedY + GCStyle.midBorder * 0.5
                }
                codeArea.possibleDropIndex = -1
            }
        }
    }

    delegate: Item {
        id: itemParent
        width: codeArea.buttonWidth
        height: codeArea.buttonHeight

        Item {
            id: item
            width: codeArea.buttonWidth
            height: codeArea.buttonHeight
            state: "inactive"
            opacity: 1

            Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
            Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
            Behavior on opacity {NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

            states: [
                State {
                    name: "inDrag"
                    when: index == codeArea.draggedItemIndex

                    PropertyChanges {
                        item {
                            parent: codeArea
                            width: codeArea.buttonWidth * 0.80
                            height: codeArea.buttonHeight * 0.80
                            anchors.centerIn: undefined
                            x: codeAreaMouse.mouseX - item.width * 0.5
                            y: codeAreaMouse.mouseY - item.height * 0.5
                        } 
                    }
                },
                State {
                    name: "greyedOut"
                    when: (codeArea.draggedItemIndex != -1) && (codeArea.draggedItemIndex != index)

                    PropertyChanges { item { opacity: 0.7 } }
                },
                State {
                    name: "inactive"
                    when: (codeArea.draggedItemIndex == -1) || (codeArea.draggedItemIndex == index)

                    PropertyChanges { item { opacity: 1.0 } }
                }
            ]

            transitions: [
                Transition {
                    from: "inDrag"
                    to: "*"
                    PropertyAnimation {
                        target: item
                        properties: "scale, opacity"
                        from: 0.7
                        to: 1.0
                        duration: 200
                    }
                }
            ]

            Rectangle {
                width: parent.width - GCStyle.midBorder
                height: parent.height - GCStyle.midBorder
                border.width: GCStyle.thinnestBorder
                border.color: "#2a2a2a"
                anchors.centerIn: parent
                radius: GCStyle.tinyMargins

                Image {
                    id: codeAreaIcon
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
        }
    }
}
