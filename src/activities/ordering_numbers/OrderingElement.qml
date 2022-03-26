/* GCompris - OrderingElement.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "ordering.js" as Activity

Item {

    id: orderingElement

    property int index

    property string elementKey
    // Mode : numbers | alphabets | sentences | chronology
    property string mode

    property bool orderingElementIsEntered
    property bool isMoveAllowed: (placeholderName === "target")

    property ListModel listModel: null
    property Image highestParent: null

    property string placeholderName

    width: draggable.width
    height: draggable.height

    DropArea {
        id: orderingElementDropArea

        anchors.fill: parent

        // In target placeholder, detect all drops
        // In origin placeholder, detect no drops
        keys: elementKey

        onEntered: {
            if (isMoveAllowed) {
                targetListModel.move(drag.source.index,index,1)
            }
        }
    }

    MouseArea {
        id: orderingElementMouseArea

        property bool dropActive: true
        property int onGoingAnimationCount: 0

        // For storing the initial position when dragged
        property point beginDragPosition
        property MouseArea originalParent
        property bool mouseHeld: false

        anchors.fill: parent

        drag.target: enabled ? draggable : null
        enabled: (!onGoingAnimationCount)

        onPressed: {
            orderingElementMouseArea.beginDragPosition = Qt.point(draggable.x, draggable.y)
            mouseHeld = true
            Activity.targetColorReset()
        }
        onReleased: {
            draggable.Drag.drop()
            mouseHeld = false
            draggable.parent = orderingElementMouseArea

            // The element may die on drop if removed, check if it exists
            if(draggable) {
                draggable.x = beginDragPosition.x
                draggable.y = beginDragPosition.y
            }
        }


        // To Display the text in the element
        Rectangle {
            id: draggable

            // To access when dragged
            property int index: orderingElement.index
            property string draggableText: elementValue
            property string placeholderName: orderingElement.placeholderName

            width: (mode === 'chronology') ? 100 * ApplicationInfo.ratio :
                Math.max(elementCaption.width, 65 * ApplicationInfo.ratio)

            height: (mode === 'chronology') ? width :
            65 * ApplicationInfo.ratio / ((mode === 'sentences') ? 1.5 : 1)

            color: "white"
            opacity: 1

            Drag.keys: orderingElement.elementKey
            Drag.active: orderingElementMouseArea.drag.active
            Drag.hotSpot.x: width/2
            Drag.hotSpot.y: height/2

            border.color: borderColor
            border.width: 3 * ApplicationInfo.ratio

            radius: 10

            GCText {
                id: elementCaption

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: (parent.width - width) / 2
                }
                padding: 15 * ApplicationInfo.ratio
                height: parent.height
                color: "#373737"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: ([
                    'alphabets',
                    'numbers',
                    'sentences',
                ].indexOf(mode) != -1) ? elementValue : ""
            }
            Image {
                source: (mode === 'chronology') ? elementValue : ""
                width: parent.width - 2 * parent.radius
                height: parent.height - 2 * parent.radius
                fillMode: Image.PreserveAspectFit

                anchors {
                    top: parent.top
                    left: parent.left
                    margins: 10
                }
            }

            Behavior on x {
                PropertyAnimation {
                    id: animationX
                    duration: 500
                    easing.type: Easing.InOutBack
                    onRunningChanged: {
                        if(animationX.running) {
                            orderingElementMouseArea.onGoingAnimationCount++
                        } else {
                            orderingElementMouseArea.onGoingAnimationCount--
                        }
                    }
                }
            }

            Behavior on y {
                PropertyAnimation {
                    id: animationY
                    duration: 500
                    easing.type: Easing.InOutBack
                    onRunningChanged: {
                        if(animationY.running) {
                            orderingElementMouseArea.onGoingAnimationCount++
                        } else {
                            orderingElementMouseArea.onGoingAnimationCount--
                        }
                    }
                }
            }
        }

        states: State {
            when: orderingElementMouseArea.mouseHeld
            ParentChange { target: draggable; parent: highestParent }
        }
    }
}
