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
import core 1.0

import "../../core"
import "ordering.js" as Activity

Item {
    id: orderingElement

    // defined by default in OrderingPlaceholder
    required property string mode
    required property int index
    required property Item highestParent
    required property string placeholderName
    // set for each element in the model
    required property color borderColor
    required property string elementValue

    property bool orderingElementIsEntered

    width: draggable.width
    height: draggable.height

    DropArea {
        id: orderingElementDropArea
        anchors.fill: parent
        // In target placeholder, detect all drops
        // In origin placeholder, detect no drops
        enabled: orderingElement.placeholderName === "target"
        keys: ["target"]

        onEntered: (drag) => {
            Activity.moveFromTargetList(drag.source.index, index, 1)
        }
    }

    MouseArea {
        id: orderingElementMouseArea

        property bool dropActive: true
        property int onGoingAnimationCount: 0
        // For storing the initial position when dragged
        property point beginDragPosition
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
            property string mode: orderingElement.mode
            property string elementValue: orderingElement.elementValue

            width: (mode === 'chronology') ? 100 * ApplicationInfo.ratio :
                Math.max(elementCaption.width, 65 * ApplicationInfo.ratio)

            height: (mode === 'chronology') ? width :
                ((mode === 'sentences') ? 42 * ApplicationInfo.ratio : width)

            color: GCStyle.whiteBg
            opacity: 1

            Drag.keys: [orderingElement.placeholderName]
            Drag.active: orderingElementMouseArea.drag.active
            Drag.hotSpot.x: width * 0.5
            Drag.hotSpot.y: height * 0.5

            border.color: orderingElement.borderColor
            border.width: GCStyle.midBorder
            radius: GCStyle.halfMargins

            GCText {
                id: elementCaption
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                color: GCStyle.darkText
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: (mode === 'chronology') ? "" : orderingElement.elementValue
            }
            Image {
                source: (mode === 'chronology') ? orderingElement.elementValue : ""
                width: parent.width - 2 * parent.radius
                height: parent.height - 2 * parent.radius
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
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
