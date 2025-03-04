/* GCompris - MathDigit.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: mathDigit
    property int value: -1
    property int expected: -1
    property bool hasTens: false
    property bool hasCarry: false
    property bool droppable: false
    property int tensValue: 0
    property int carryValue: 0
    property int computedValue: ((value === -1) ? 0 : value) + (10 * tensValue) + carryValue

    width: items.digitWidth
    height: items.digitHeight

    function mapPadToItem(pad_, item_){
        var tempX = item_.mapToItem(activityBackground, 0, 0).x + item_.width * 0.5 - pad_.width * 0.5
        var tempY = item_.mapToItem(activityBackground, 0, 0).y + item_.height * 0.5 - pad_.height * 0.5
        pad_.x = Core.clamp(tempX, items.baseMargins, pad_.maxX)
        pad_.y = Core.clamp(tempY, items.baseMargins, pad_.maxY)
    }

    Rectangle {
        id: digitBg
        anchors.centerIn: parent
        width: items.digitBgWidth
        height: items.digitBgHeight
        color: (droppable && mouseArea.containsMouse) ? "#80A1CBD9" : "#00FFFFFF"
        border.color: "#A1CBD9"
        border.width: 2 * ApplicationInfo.ratio
        radius: items.baseRadius
    }

    GCText {
        id: digitValue
        width: digitBg.width * 0.5
        height: digitBg.height
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSize: mediumSize
        fontSizeMode: Text.Fit
        text: (value > -1) ? value : ""
    }

    Item {
        id: tens
        width: digitBg.width * 0.5
        height: digitBg.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: digitBg.left
        visible: !droppable && hasTens && (items.operation !== VerticalSubtraction.OperationType.Addition) && items.withCarry

        Rectangle {
            id: tensBg
            width: digitBg.width * 0.3
            height: digitBg.height * 0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: digitBg.width * 0.05
            color: tensMouseArea.containsMouse ? "#80A1CBD9" : "#00FFFFFF"
            border.color: (tensValue === 0) ? "#A1CBD9" : "#A1D9A1"
            border.width: ApplicationInfo.ratio
            radius: items.baseRadius
        }

        GCText {
            id: tensText
            anchors.fill: tensBg
            anchors.centerIn: tensBg
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            text: (tensValue === 0) ? "" : tensValue
        }

        MouseArea {
            id: tensMouseArea
            anchors.fill: parent
            enabled: !items.inputLocked
            hoverEnabled: true
            onClicked: {
                items.miniPad.current = mathDigit
                items.miniPad.isCarry = false
                items.miniPad.color = "#A1D9A1"
                items.miniPad.repeater.model = [ 3, 2, 1, 0 ]
                mapPadToItem(items.miniPad, tensBg)
                items.miniPad.visible = true
            }
        }
    }

    Item {
        id: carry
        width: tens.width
        height: tens.height
        anchors.bottom: digitBg.bottom
        anchors.right: digitBg.right
        opacity: (!droppable && hasCarry) ? 1.0 : 0.0
        visible: !droppable && hasCarry && items.withCarry

        Rectangle {
            id: carryBg
            width: tensBg.width
            height: tensBg.height
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: tensBg.anchors.leftMargin
            color: carryMouseArea.containsMouse ? "#80A1CBD9" : "#00FFFFFF"
            border.color: (carryValue === 0) ? "#A1CBD9" : "#D9A1A1"
            border.width: ApplicationInfo.ratio
            radius: items.baseRadius
        }

        GCText {
            id: incrText
            anchors.fill: carryBg
            anchors.centerIn: carryBg
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            text: (carryValue === 0) ? "" : (carryValue > 0) ? `+${carryValue}` : carryValue
        }

        MouseArea {
            id: carryMouseArea
            anchors.fill: parent
            enabled: !items.inputLocked
            hoverEnabled: true
            onClicked: {
                var up = ((items.operation === VerticalSubtraction.OperationType.Subtraction) && hasTens) ? 0 : 1
                items.miniPad.current = mathDigit
                items.miniPad.isCarry = true
                items.miniPad.color = "#D9A1A1"
                items.miniPad.repeater.model = up ? [ "+3", "+2", "+1", "" ] : [ "", "-1", "-2", "-3" ]
                mapPadToItem(items.miniPad, carryBg)
                items.miniPad.open()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: enabled
        enabled: mathNumber.enabled && droppable && !items.inputLocked
        onClicked: {
            items.numPad.currentDigit = parent
            mapPadToItem(items.numPad, digitBg)
            items.numPad.open()
        }
    }
}
