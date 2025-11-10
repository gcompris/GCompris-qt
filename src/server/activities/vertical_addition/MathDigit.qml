/* GCompris - MathDigit.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com> (simplification from the one in activities)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../singletons"
import "../../components"

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
        width: mathDigit.digitWidth - Style.defaultBorderWidth
        height: mathDigit.digitHeight - Style.defaultBorderWidth
        color: "#FFFFFF"
        border.color: "#A1CBD9"
        border.width: Style.defaultBorderWidth
        radius: Style.defaultBorderWidth
    }

    DefaultLabel {
        id: digitValue
        width: digitBg.width * 0.5
        anchors.centerIn: digitBg
        fontSizeMode: Text.Fit
        color: Style.lightPalette.text
        text: (value > -1) ? value : ""
    }

    Rectangle {
        id: tensBg
        width: digitBg.width * 0.33
        height: digitBg.height * 0.5 + Style.defaultBorderWidth * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: digitBg.left
        anchors.leftMargin: Style.defaultBorderWidth
        color: "#00FFFFFF"
        border.color: (tensValue === 0) ? "#A1CBD9" : "#A1D9A1"
        border.width: Style.defaultBorderWidth
        radius: Style.defaultBorderWidth
        visible: hasTens

        DefaultLabel {
            id: tensText
            anchors.fill: parent
            anchors.margins: Style.defaultBorderWidth
            fontSizeMode: Text.Fit
            elide: Text.ElideNone
            color: Style.lightPalette.text
            text: (tensValue === 0) ? "" : tensValue
        }
    }

    Rectangle {
        id: carryBg
        width: tensBg.width
        height: tensBg.height
        anchors.bottom: digitBg.bottom
        anchors.right: digitBg.right
        anchors.margins: Style.defaultBorderWidth
        color: "#00FFFFFF"
        border.color: (carryValue === 0) ? "#A1CBD9" : "#D9A1A1"
        border.width:Style.defaultBorderWidth
        radius: Style.defaultBorderWidth
        visible: hasCarry

        DefaultLabel {
            id: incrText
            anchors.fill: parent
            anchors.margins: tensText.anchors.margins
            fontSizeMode: Text.Fit
            elide: Text.ElideNone
            color: Style.lightPalette.text
            text: (carryValue === 0) ? "" : (carryValue > 0) ? `+${carryValue}` : carryValue
        }
    }
}
