/* GCompris - MultipleChoices.qml for multiple_choice_questions
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.fr>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick

import "../../components"

Item {
    id: lineView
    required property var jsonData
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    Column {
        id: details
        InformationLine {
            labelWidth: lineView.labelWidth
            label: qsTr("Question")
            info: lineView.jsonData.question
            textColor: (lineView.jsonData.expected === lineView.jsonData.selected) ? "green" : "red"
        }
        InformationLine {
            labelWidth: lineView.labelWidth
            label: qsTr("Expected")
            info: lineView.jsonData.expected.join(", ")
        }
        InformationLine {
            labelWidth: lineView.labelWidth
            label: qsTr("selected")
            info: lineView.jsonData.selected.join(", ")
        }
        InformationLine {
            labelWidth: lineView.labelWidth
            label: qsTr("Proposal")
            info: lineView.jsonData.proposal.join(", ")
            infoText.font.bold: true
        }
    }
}
