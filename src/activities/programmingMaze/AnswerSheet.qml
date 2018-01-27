/* GCompris - AnswerSheet.qml
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

import "programmingMaze.js" as Activity

GridView {
    id: answerSheet
    property Item background
    property ListModel currentModel
    z: 1

    width: background.width * 0.4
    height: background.height * 0.32
    cellWidth: background.buttonWidth
    cellHeight: background.buttonHeight

    interactive: false
    model: currentModel
    clip: true

    highlight: Rectangle {
        width: buttonWidth
        height: buttonHeight
        color: "lightsteelblue"
        border.width: 2 * ApplicationInfo.ratio
        border.color: "purple"
        opacity: 0.5
        z: 11
        radius: width / 18
        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    }
    highlightFollowsCurrentItem: true
    highlightMoveDuration: Activity.moveAnimDuration
    keyNavigationWraps: false
    focus: true

    property int draggedItemIndex: -1
    property int possibleDropIndex: -1
    property int possibleDropRemoveIndex: -1
    property int xCoordinateInPossibleDrop: -1
    property int yCoordinateInPossibleDrop: -1

    /**
     * Stores the index of the item which is clicked to edit.
     *
     * If the index of the item on 2nd click is same as initialEditItemIndex , then the indicator will become invisible, as it means that initially wanted to edit that instruction, but now we want to deselect it.
     *
     * If the index of the item on 2nd click is different from initialEditItemIndex, the edit indicator moves to the new item as we now want to edit that one.
     */
    property int initialEditItemIndex: -1

    //Tells if any instruction is selected for editing.
    property bool isEditingInstruction: false

    function resetEditingValues() {
    	initialEditItemIndex = -1
    	isEditingInstruction = false
    }

    Item {
        id: dropPosIndicator
        visible: false
        height: background.buttonHeight
        width: 3 * ApplicationInfo.ratio

        Rectangle {
            visible: parent.visible
            anchors.centerIn: parent
            width: parent.width
            height: parent.height - 3 * ApplicationInfo.ratio
            color: "blue"
            radius: width
        }

        states: [
            State {
                name: "shown"
                when: answerSheet.possibleDropIndex != -1
                PropertyChanges {
                    target: dropPosIndicator
                    visible: true
                    x: Math.floor(answerSheet.xCoordinateInPossibleDrop / answerSheet.cellWidth) *
                       answerSheet.cellWidth - 1.5 * ApplicationInfo.ratio
                    y: Math.floor(answerSheet.yCoordinateInPossibleDrop / answerSheet.cellHeight) *
                       answerSheet.cellHeight + 1.5 * ApplicationInfo.ratio
                }
            }
        ]
    }

    Rectangle {
        id: editInstructionIndicator
        visible: answerSheet.isEditingInstruction && answerSheet.count != 0
        width: background.buttonWidth - 3 * ApplicationInfo.ratio
        height: background.buttonHeight - 3 * ApplicationInfo.ratio
        color: "red"
        border.color: "black"
        border.width: 1.5 * ApplicationInfo.ratio
        opacity: 0.2
        radius: width / 18
    }

    Item {
        id: dndContainer
        anchors.fill: parent
    }

    MouseArea {
        id: coords
        anchors.fill: parent
        enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
        onPressed: {
            answerSheet.draggedItemIndex = answerSheet.indexAt(mouseX,mouseY)
            if(answerSheet.draggedItemIndex === -1) {
                constraintInstruction.changeConstraintInstructionOpacity()
                answerSheet.isEditingInstruction = false
            }
            else if(!answerSheet.isEditingInstruction)
                answerSheet.initialEditItemIndex = answerSheet.draggedItemIndex
        }
        onReleased: {
            if(answerSheet.draggedItemIndex != -1) {
                var draggedIndex = answerSheet.draggedItemIndex
                var dropIndex = answerSheet.indexAt(mouseX,mouseY)
                var calculatedX = Math.floor(mouseX / answerSheet.cellWidth) * answerSheet.cellWidth
                var calculatedY = Math.floor(mouseY / answerSheet.cellHeight) * answerSheet.cellHeight
                answerSheet.draggedItemIndex = -1
                if(dropIndex == -1) {
                    var previousIndexCalculatedPosition = answerSheet.indexAt(calculatedX - 1, mouseY)
                    if(previousIndexCalculatedPosition == -1) {
                        currentModel.remove(draggedIndex)
                        items.numberOfInstructionsAdded--
                    }
                    else {
                        currentModel.append(currentModel.get(draggedIndex))
                        currentModel.remove(draggedIndex)
                    }
                }
                else if(draggedIndex != dropIndex) {
                    if(dropIndex <= draggedIndex) {
                        //moving box from right to left
                        currentModel.move(draggedIndex, dropIndex, 1)
                    }
                    else {
                        //moving box from left to right
                        currentModel.move(draggedIndex, dropIndex - 1, 1)
                    }
                }
                else {
                    if(answerSheet.initialEditItemIndex == dropIndex)
                        answerSheet.isEditingInstruction = !answerSheet.isEditingInstruction
                    else
                        answerSheet.initialEditItemIndex = draggedIndex

                    editInstructionIndicator.x = calculatedX + 1.5 * ApplicationInfo.ratio
                    editInstructionIndicator.y = calculatedY + 1.5 * ApplicationInfo.ratio
                }
                answerSheet.possibleDropIndex = -1
            }
        }
        onPositionChanged: {
            var newPos = answerSheet.indexAt(mouseX, mouseY)
            var calculatedX = Math.floor(mouseX / answerSheet.cellWidth) * answerSheet.cellWidth
            var previousIndexCalculatedPosition = answerSheet.indexAt(calculatedX - 1, mouseY)

            //If the user want to move an item to the end, then the new position will be after the last instruction.
            if(newPos == -1 && previousIndexCalculatedPosition != -1)
                newPos = previousIndexCalculatedPosition + 1
            answerSheet.isEditingInstruction = false
            answerSheet.xCoordinateInPossibleDrop = mouseX
            answerSheet.yCoordinateInPossibleDrop = mouseY
            answerSheet.possibleDropIndex = newPos
        }
    }

    delegate: Item {
        id: itemParent
        width: background.buttonWidth
        height: background.buttonHeight

        Rectangle {
            id: circlePlaceholder
            width: 30 * ApplicationInfo.ratio
            height: width
            radius: width
            anchors.centerIn: parent
            color: "#cecece"
            opacity: 0
        }

        Item {
            id: item
            width: background.buttonWidth
            height: background.buttonHeight
            state: "inactive"
            opacity: 1

            Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
            Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
            Behavior on opacity {NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

            states: [
                State {
                    name: "inDrag"
                    when: index == answerSheet.draggedItemIndex
                    PropertyChanges { target: circlePlaceholder; opacity: 1 }
                    PropertyChanges { target: item; parent: dndContainer }
                    PropertyChanges { target: item; width: background.buttonWidth * 0.80 }
                    PropertyChanges { target: item; height: background.buttonHeight * 0.80 }
                    PropertyChanges { target: item; anchors.centerIn: undefined }
                    PropertyChanges { target: item; x: coords.mouseX - item.width / 2 }
                    PropertyChanges { target: item; y: coords.mouseY - item.height / 2 }
                },
                State {
                    name: "greyedOut"
                    when: (answerSheet.draggedItemIndex != -1) && (answerSheet.draggedItemIndex != index)
                    PropertyChanges { target: item; opacity: 0.7 }
                },
                State {
                    name: "inactive"
                    when: (answerSheet.draggedItemIndex == -1) || (answerSheet.draggedItemIndex == index)
                    PropertyChanges { target: item; opacity: 1.0 }
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
                width: parent.width - 3 * ApplicationInfo.ratio
                height: parent.height - 3 * ApplicationInfo.ratio
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "black"
                anchors.centerIn: parent
                radius: width / 18

                Image {
                    id: codeAreaIcon
                    source: Activity.url + name + ".svg"
                    sourceSize { width: parent.width / 1.2; height: parent.height / 1.2 }
                    anchors.centerIn: parent
                }
            }
        }
    }
}
