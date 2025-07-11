/* GCompris - BinaryBulb.qml for binary_bulb
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: lineItem
    required property var jsonData
    required property bool resultSuccess
    height: details.height

    // Used to get longest text for aligned label columns.
    TextMetrics {
        id: expectedLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Expected:")
    }
    TextMetrics {
        id: answerLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Answer:")
    }

    Column {
        id: details

        InformationLine {
            id: expectedLine
            width: lineItem.width
            label: expectedLabelSize.text
            labelWidth: Math.max(expectedLabelSize.advanceWidth, answerLabelSize.advanceWidth) + 1
            //: %1 is the numerical value, %2 is the binary value. Example: "5 (101)"
            info: qsTr("%1 (%2)").arg(lineItem.jsonData.expected).arg((lineItem.jsonData.expected >>> 0).toString(2))
        }

        InformationLine {
            id: answerLine
            width: lineItem.width
            label: answerLabelSize.text
            labelWidth: expectedLine.labelWidth
            //: %1 is the numerical value, %2 is the binary value. Example: "5 (101)"
            info: qsTr("%1 (%2)").arg(lineItem.jsonData.result).arg((lineItem.jsonData.result >>> 0).toString(2))
            infoText.color: Style.selectedPalette.highlightedText
            showResult: true
            resultSuccess: lineItem.resultSuccess
        }
    }
}
