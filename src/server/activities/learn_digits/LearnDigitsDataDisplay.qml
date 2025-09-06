/* GCompris - LearnDigitsDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
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

InformationLine {
    id: lineItem
    required property var jsonData
    property bool isOperation: false

    label: isOperation ?
        //: %1 is an operation, %2 the result. Example: "2 x 5 = 10"
        qsTr("%1 = %2").arg(lineItem.jsonData.questionText).arg(lineItem.jsonData.question) :
        lineItem.jsonData.questionText
    //: %1 is the answer. Example: "Answer: 10"
    info: qsTr("Answer: %1").arg(lineItem.jsonData.answer)
    infoText.font.bold: true
    infoText.color: Style.selectedPalette.highlightedText
    showResult: true
}
