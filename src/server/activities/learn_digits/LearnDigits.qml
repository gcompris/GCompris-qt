/* GCompris - LearnDigits.qml for learn_digits, learn_additions, learn_subtractions
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

Item {
    id: lineView
    required property var jsonData
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    Column {
        id: details
        InformationLine {
            label: qsTr("Question")
            info: lineView.jsonData.question
        }
        InformationLine {
            label: qsTr("Proposal")
            info: lineView.jsonData.answer
            textColor: (lineView.jsonData.question === lineView.jsonData.answer) ? "green" : "red"
            infoText.font.bold: true
        }
    }
}
