/* GCompris - ClockGameDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
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

    function formatTime(list) {
        return ('00'+list[0]).slice(-2) + ":" + ('00'+list[1]).slice(-2) + ":" + ('00'+list[2]).slice(-2)
    }

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
            labelWidth: Math.max(expectedLabelSize.advanceWidth, answerLabelSize.advanceWidth) + 1
            label: expectedLabelSize.text
            info: formatTime(lineItem.jsonData.expected)
        }
        InformationLine {
            id: answerLine
            width: lineItem.width
            labelWidth: expectedLine.labelWidth
            label: answerLabelSize.text
            info: formatTime(lineItem.jsonData.proposal)
            infoText.color: Style.selectedPalette.highlightedText
            showResult: true
            resultSuccess: lineItem.resultSuccess
        }
    }
}
