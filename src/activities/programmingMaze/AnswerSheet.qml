/* GCompris - programmingMaze.js
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 *
 * Authors:
 *   "Siddhesh Suthar" <siddhesh.it@gmail.com> (Qt Quick port)
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

import "programmingMaze.js" as Activity

GridView {
    id: answerSheet
    property Item background
    property ListModel currentModel
    property int buttonWidth: background.width / 10
    property int buttonHeight: background.height / 10

    width: background.width * 0.4
    height: background.height * 0.4 - 5 * ApplicationInfo.ratio
    cellWidth: background.buttonWidth
    cellHeight: background.buttonHeight

    interactive: false
    model: currentModel
    clip: true

    highlight: Rectangle {
        width: buttonWidth
        height: buttonHeight
        color: "lightsteelblue"
        border.width: 5 * ApplicationInfo.ratio
        border.color: "purple"
        opacity: 0.5
        z: 11
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

    Item {
        id: dropPosIndicator
        visible: false
        height: answerSheet.cellHeight
        width: 5 * ApplicationInfo.ratio

        Rectangle {
            visible: parent.visible
            anchors.centerIn: parent
            width: 5 * ApplicationInfo.ratio
            height: parent.height - 5 * ApplicationInfo.ratio
            color: "lightsteelblue"
        }

        states: [
            State {
                name: "shown"
                when: answerSheet.possibleDropIndex != -1
                PropertyChanges {
                    target: dropPosIndicator
                    visible: true
                    x: Math.floor(answerSheet.xCoordinateInPossibleDrop/answerSheet.cellWidth) *
                       answerSheet.cellWidth - 5 * ApplicationInfo.ratio
                    y: Math.floor(answerSheet.yCoordinateInPossibleDrop/answerSheet.cellHeight) *
                       answerSheet.cellHeight - 2 * ApplicationInfo.ratio
                }
            }
        ]
    }
    Item {
        id: dropPosRemoveIndicator
        visible: false
        width: background.buttonWidth
        height: background.buttonHeight

        Rectangle {
            visible: parent.visible
            anchors.fill: parent
            radius: 5 * ApplicationInfo.ratio
            color: "transparent"
            border.width: 5 * ApplicationInfo.ratio
            border.color: "lightsteelblue"
            opacity: 1
        }

        states: [
            State {
                name: "shown"
                when: answerSheet.possibleDropRemoveIndex != -1
                PropertyChanges {
                    target: dropPosRemoveIndicator
                    visible: true
                    x: Math.floor(answerSheet.xCoordinateInPossibleDrop/answerSheet.cellWidth) *
                       answerSheet.cellWidth - 5 * ApplicationInfo.ratio
                    y: Math.floor(answerSheet.yCoordinateInPossibleDrop/answerSheet.cellHeight) *
                       answerSheet.cellHeight - 2 * ApplicationInfo.ratio
                }
            }
        ]
    }
    Item {
        id: dndContainer
        anchors.fill: parent
    }

    MouseArea {
        id: coords
        anchors.fill: parent
        onPressed: {
            answerSheet.draggedItemIndex = answerSheet.indexAt(mouseX,mouseY)
        }
        onReleased: {
            if(answerSheet.draggedItemIndex != -1) {
                var draggedIndex = answerSheet.draggedItemIndex
                var dropIndex = answerSheet.indexAt(mouseX,mouseY)
                answerSheet.draggedItemIndex = -1
                var calculatedX =  Math.floor(answerSheet.xCoordinateInPossibleDrop/answerSheet.cellWidth) *
                        answerSheet.cellWidth
                var diff = Math.floor(mouseX - calculatedX)
                var insertEnd = answerSheet.cellWidth / 2
                if(answerSheet.indexAt(mouseX,mouseY) == -1)
                    currentModel.remove(draggedIndex)
                else {
                    if(diff <= insertEnd) {
                        if(dropIndex <= draggedIndex) {
                            //moving box from right to left
                            currentModel.move(draggedIndex, answerSheet.indexAt(mouseX,mouseY), 1)
                        }
                        else {
                            //moving box from left to right
                            currentModel.move(draggedIndex, answerSheet.indexAt(mouseX,mouseY)-1, 1)
                        }
                    }
                    else {
                        currentModel.set(dropIndex, currentModel.get(draggedIndex), 1)
                        currentModel.remove(draggedIndex)
                    }
                }
                answerSheet.possibleDropRemoveIndex = -1
                answerSheet.possibleDropIndex = -1
            }
        }
        onPositionChanged: {
            var newPos = answerSheet.indexAt(mouseX, mouseY)
            answerSheet.xCoordinateInPossibleDrop = mouseX
            answerSheet.yCoordinateInPossibleDrop = mouseY
            var calculatedX =  Math.floor(answerSheet.xCoordinateInPossibleDrop/answerSheet.cellWidth) *
                    answerSheet.cellWidth
            var diffX = Math.floor(mouseX - calculatedX)
            var insertEndX = answerSheet.cellWidth / 2
            if(diffX <= insertEndX) {
                answerSheet.possibleDropIndex = newPos
                answerSheet.possibleDropRemoveIndex = -1
            }
            else {
                answerSheet.possibleDropRemoveIndex = newPos
                answerSheet.possibleDropIndex = -1
            }
        }
    }


    delegate: Column {
        Item {
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
                width: background.buttonWidth - 5 * ApplicationInfo.ratio
                height: background.buttonHeight - 5 * ApplicationInfo.ratio
                state: "inactive"
                opacity: 1

                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                Behavior on opacity {NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }


                states: [
                    State {
                        name: "inDrag"
                        when: index == answerSheet.draggedItemIndex
                        PropertyChanges { target: circlePlaceholder; opacity: 1}
                        PropertyChanges { target: imageBorder; opacity: 1 }
                        PropertyChanges { target: item; parent: dndContainer }
                        PropertyChanges { target: item; width: background.buttonWidth * 0.80 }
                        PropertyChanges { target: item; height: background.buttonHeight * 0.80 }
                        PropertyChanges { target: item; anchors.centerIn: undefined }
                        PropertyChanges { target: item; x: coords.mouseX - item.width / 2 }
                        PropertyChanges { target: item; y: coords.mouseY - item.height / 2 }
                    },
                    State {
                        name: "greyedOut"
                        when: (answerSheet.draggedItemIndex != -1) &&(answerSheet.draggedItemIndex != index)
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
                            easing.overshoot: 1.5
                            easing.type: "OutBack"
                            from: 0.0
                            to: 1.0
                            duration: 500
                        }
                    }
                ]

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
                }

                Image {
                    id: answer
                    source: Activity.url + name + ".svg"
                    sourceSize { width: parent.width; height: parent.height  }
                    width: sourceSize.width
                    height: sourceSize.height
                    anchors.centerIn: parent
                    smooth: false

                    Rectangle {
                        id: imageBorder
                        width: background.buttonWidth + 5 * ApplicationInfo.ratio
                        height: background.buttonHeight + 5 * ApplicationInfo.ratio
                        anchors.fill: parent
                        radius: 5 * ApplicationInfo.ratio
                        color: "transparent"
                        border.width: 5 * ApplicationInfo.ratio
                        border.color: "#ffffff"
                        opacity: 0
                    }
                }
            }
        }
    }
}
