/* GCompris - KeyboardTrainingDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
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
            labelWidth: Math.max(expectedLabelSize.advanceWidth, answerLabelSize.advanceWidth) + 1
            label: expectedLabelSize.text
            info: lineItem.jsonData.question
        }
        InformationLine {
            id: answerLine
            width: lineItem.width
            labelWidth: expectedLine.labelWidth
            label: answerLabelSize.text
            info: lineItem.jsonData.answer
            infoText.color: Style.selectedPalette.highlightedText
            showResult: true
            resultSuccess: lineItem.resultSuccess
        }
    }
}
