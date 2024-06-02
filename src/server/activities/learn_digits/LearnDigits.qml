/* GCompris - LearnDigits.qml for learn_digits, learn_additions, learn_subtractions
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.15

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
            info: jsonData.questionText
        }
        InformationLine {
            label: qsTr("Proposal")
            info: jsonData.answer
            textColor: (jsonData.question === jsonData.answer) ? "green" : "red"
            infoText.font.bold: true
        }
    }
}
