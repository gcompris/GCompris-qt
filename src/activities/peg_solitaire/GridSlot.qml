/* GCompris - GridSlot.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "peg_solitaire.js" as Activity

Rectangle {
    id: gridSlot
    required property int index
    required property list<int> modelData
    required property bool initPieceRemoved
    required property bool inputBlocked
    property bool canMove: false
    property bool hasPeg: true
    property bool canReceive: false // only true while selected peg to move can go in this slot
    property bool isSelected: false
    property bool isDropTarget: false
    property alias moveAnim: moveAnim

    property GridSlot targetSlot: null
    property point targetPoint: targetSlot ? mapFromItem(targetSlot, 0, 0) : Qt.point(0,0)

    property real initialPegPosition: (width - tilePeg.width) * 0.5

    function resetSlot() {
        canMove = false;
        hasPeg = true;
        canReceive = false;
    }

    SequentialAnimation {
        id: moveAnim
        ScriptAction { script: gridSlot.z = 1000 }
        ParallelAnimation {
            NumberAnimation {
                target: pegContainer
                property: "x"
                to: gridSlot.targetPoint.x
                duration: 200
            }
            NumberAnimation {
                target: pegContainer
                property: "y"
                to: gridSlot.targetPoint.y
                duration: 200
            }
        }
        ScriptAction {
            script: Activity.doPendingMove()
        }
        ScriptAction { script: pegContainer.x = 0 }
        ScriptAction { script: pegContainer.y = 0 }
        ScriptAction { script: gridSlot.z = 0 }
    }

    color: "#5b310f"
    x: modelData[0] * width
    y: modelData[1] * width

    Rectangle {
        id: hole
        anchors.centerIn: parent
        width: parent.width * 0.1
        height: width
        radius: width
        color: "#321b01"
    }

    Rectangle {
        id: canReceiveIndicator
        anchors.centerIn: parent
        width: gridSlot.isDropTarget ? parent.width * 0.9 : parent.width * 0.3
        height: width
        radius: width
        color: "#800CA4F4"
        border.color: "#40ffffff"
        border.width: gridSlot.isDropTarget ? gridSlot.width * 0.05 : 0
        visible: gridSlot.canReceive

        Behavior on width {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
                duration: 100
            }
        }
    }

    Rectangle {
        id: selectorIndicator
        color: "transparent"
        border.color: "#40ffffff"
        border.width: gridSlot.width * 0.05
        width: gridSlot.width * 0.9
        height: width
        radius: width
        anchors.centerIn: parent
        visible: gridSlot.isSelected
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        enabled: gridSlot.canReceive

        onEntered: {
            Activity.setDropTarget(gridSlot);
        }

        onExited: {
            Activity.resetDropTarget();
        }
    }

    Item {
        id: pegContainer
        width: parent.width
        height: parent.height

        Drag.active: moveClick.drag.active
        Drag.hotSpot.x: width * 0.5
        Drag.hotSpot.y: height * 0.5

        Peg {
            id: tilePeg
            sourceSize.width: gridSlot.width * 0.6
            sourceSize.height: width
            anchors.centerIn: parent
            visible: gridSlot.hasPeg
        }

        MouseArea {
            id: moveClick
            enabled: !gridSlot.inputBlocked
            anchors.fill: parent

            drag.target: gridSlot.canMove ? parent : null

            onPressed: {
                if(!gridSlot.isSelected) {
                    // Never call Activity.slotPressed() on already selected peg/slot,
                    // since that is useless anyway and may cause edge case bugs.
                    Activity.slotPressed(gridSlot);
                }
                if(gridSlot.initPieceRemoved) {
                    // handle drag
                    gridSlot.z = 100;
                }
            }

            onReleased: {
                if(gridSlot.isSelected) {
                   Activity.checkDropTarget();
                }
                gridSlot.z = 0;
                pegContainer.x = 0;
                pegContainer.y = 0;
            }
        }
    }
}
