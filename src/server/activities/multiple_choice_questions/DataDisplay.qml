/* GCompris - DataDisplay.qml for multiple_choice_questions
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.fr>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Basic

import "../../singletons"
import "../../components"
import "../../panels"

Item {
    property var jsonData: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    Column {
        id: details
        InformationLine {
            label: qsTr("Question")
            info: jsonData.question
            textColor: (jsonData.expected === jsonData.selected) ? "green" : "red"
        }
        InformationLine {
            label: qsTr("Expected")
            info: jsonData.expected.join(", ")
        }
        InformationLine {
            label: qsTr("selected")
            info: jsonData.selected.join(", ")
        }
        InformationLine {
            label: qsTr("Proposal")
            info: jsonData.proposal.join(", ")
            infoText.font.bold: true
        }
    }
}
