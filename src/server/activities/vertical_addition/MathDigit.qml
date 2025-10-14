/* GCompris - MathDigit.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com> (simplification from the one in activities)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../../core/"

Item {
    id: mathDigit
    property int value: -1
    property int expected: -1
    property bool hasTens: tensValue != 0
    property bool hasCarry: carryValue != 0
    property int tensValue: 0
    property int carryValue: 0
    property int computedValues: ((value === -1) ? 0 : value) + (10 * tensValue) + carryValue

    required property int digitWidth
    required property int digitHeight

    width: digitWidth
    height: digitHeight

    Rectangle {
        id: digitBg
        anchors.centerIn: parent
        width: mathDigit.digitWidth - 2
        height: mathDigit.digitHeight - 2
        color: "#FFFFFF"
        border.color: "#A1CBD9"
        border.width: GCStyle.thinBorder
        radius: GCStyle.tinyMargins
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
        visible: hasTens

        Rectangle {
            id: tensBg
            width: digitBg.width * 0.3
            height: digitBg.height * 0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: digitBg.width * 0.05
            color: "#00FFFFFF"
            border.color: (tensValue === 0) ? "#A1CBD9" : "#A1D9A1"
            border.width: ApplicationInfo.ratio
            radius: GCStyle.tinyMargins
        }

        GCText {
            id: tensText
            anchors.fill: tensBg
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            text: (tensValue === 0) ? "" : tensValue
        }
    }

    Item {
        id: carry
        width: tens.width
        height: tens.height
        anchors.bottom: digitBg.bottom
        anchors.right: digitBg.right
        opacity: hasCarry ? 1.0 : 0.0
        visible: hasCarry

        Rectangle {
            id: carryBg
            width: tensBg.width
            height: tensBg.height
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: tensBg.anchors.leftMargin
            color: "#00FFFFFF"
            border.color: (carryValue === 0) ? "#A1CBD9" : "#D9A1A1"
            border.width: ApplicationInfo.ratio
            radius: GCStyle.tinyMargins
        }

        GCText {
            id: incrText
            anchors.fill: carryBg
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: regularSize
            fontSizeMode: Text.Fit
            text: (carryValue === 0) ? "" : (carryValue > 0) ? `+${carryValue}` : carryValue
        }
    }
}
