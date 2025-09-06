/* GCompris - MultipleChoicesDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.fr>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.fr>
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
        id: questionLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Question:")
    }
    TextMetrics {
        id: answerLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Answer:")
    }
    TextMetrics {
        id: expectedLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Expected:")
    }
    TextMetrics {
        id: proposedLabelSize
        font.pixelSize: Style.textSize
        font.bold: true
        text: qsTr("Proposed:")
    }

    Column {
        id: details
        width: parent.width
        height: childrenRect.height

        InformationLine {
            id: questionLabel
            width: parent.width
            labelWidth: Math.max(questionLabelSize.advanceWidth, answerLabelSize.advanceWidth,
                                 expectedLabelSize.advanceWidth, proposedLabelSize.advanceWidth) + 1
            label: questionLabelSize.text
            info: lineItem.jsonData.question
        }
        InformationLine {
            width: parent.width
            labelWidth: questionLabel.labelWidth
            label: answerLabelSize.text
            info: lineItem.jsonData.selected.join(", ")
            infoText.font.bold: true
            showResult: true
            resultSuccess: lineItem.resultSuccess
        }
        InformationLine {
            width: parent.width
            labelWidth: questionLabel.labelWidth
            label: expectedLabelSize.text
            info: lineItem.jsonData.expected.join(", ")

        }
        InformationLine {
            width: parent.width
            labelWidth: questionLabel.labelWidth
            label: proposedLabelSize.text
            info: lineItem.jsonData.proposal.join(", ")
        }
    }
}
