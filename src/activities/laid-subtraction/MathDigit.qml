/* GCompris - MathDigit.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "subtraction.js" as Activity

Rectangle {
    id: mathDigit
    property int value: -1
    property int expected: -1
    property bool hasTens: false
    property bool hasCarry: false
    property bool droppable: false
    property int digitHeight: Activity.digitHeight
    property int tensValue: 0
    property int carryValue: 0
    property int computedValue: ((value === -1) ? 0 : value) + (10 * tensValue) + carryValue

    width: digitHeight * Activity.ratioWH
    height: digitHeight
    color: "moccasin"
    border.color: "burlywood"
    border.width: (droppable && mouseArea.containsMouse) ? 3 : 0
    radius: 5

    GCText {
        id: digitValue
        width: parent.width / 2
        height: digitHeight
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        fontSize: mediumSize
        text: (value > -1) ? value : ""
    }

    Rectangle {
        id: tens
        width: parent.width / 4
        height: digitHeight / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 4
        color: (tensValue === 0) ? "beige" : "mediumspringgreen"
        border.color: "burlywood"
        border.width: tensMouseArea.containsMouse ? 2 : 0
        radius: 3
        visible: !droppable && hasTens && (items.operation !== 0) && items.withCarry

        GCText {
            id: tensText
            anchors.fill: parent
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: tinySize
            text: (tensValue === 0) ? "" : tensValue
        }

        MouseArea {
            id: tensMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                items.miniPad.current = mathDigit
                items.miniPad.isCarry = false
                items.miniPad.color = "mediumspringgreen"
                items.miniPad.repeater.model = [ 3, 2, 1, 0 ]
                items.miniPad.x = mapToItem(background, 0, 0).x - items.miniPad.width + tens.width
                items.miniPad.y = mapToItem(background, 0, 0).y
                        - items.miniPad.height
                        + tens.height
                        + (tensValue * items.miniPad.cellHeight)
                items.miniPad.visible = true
            }
        }
    }

    Rectangle {
        id: carry
        width: parent.width / 4
        height: digitHeight / 2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        color: (carryValue === 0) ? "beige" : "salmon"
        border.color: "burlywood"
        border.width: carryMouseArea.containsMouse ? 2 : 0
        radius: 3
        opacity: !droppable && hasCarry ? 1.0 : 0.0
        visible: !droppable && hasCarry && items.withCarry

        GCText {
            id: incrText
            anchors.fill: parent
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: tinySize
            text: (carryValue === 0) ? "" : (carryValue > 0) ? `+${carryValue}` : carryValue
        }

        MouseArea {
            id: carryMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                var up = ((items.operation === 1) && hasTens) ? 0 : 1
                items.miniPad.current = mathDigit
                items.miniPad.isCarry = true
                items.miniPad.color = "salmon"
                items.miniPad.repeater.model = up ? [ "+3", "+2", "+1", "" ] : [ "", "-1", "-2", "-3" ]
                items.miniPad.x = mapToItem(background, 0, 0).x - items.miniPad.width + tens.width
                items.miniPad.y = mapToItem(background, 0, 0).y
                        - (items.miniPad.height * up)
                        + (carry.height * up)
                        + (carryValue * items.miniPad.cellHeight)
                items.miniPad.open()
            }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        visible: items.debug
        text: expected + " : " + value
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: enabled
        enabled: droppable
        onClicked: {
            items.numPad.currentDigit = parent
            items.numPad.x = mapToItem(background, 0, 0).x - Activity.digitHeight
            items.numPad.y = mapToItem(background, 0, 0).y - Activity.digitHeight
            items.numPad.open()
        }
    }
}
