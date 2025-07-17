/* GCompris - Algebra.qml for algebra_by, algebra_div, algebra_minus, algebra_plus
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
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
    property string proposal: (jsonData.proposal !== "") ? jsonData.proposal : qsTr("timeout")

    //: %1 is an operation, %2 the result. Example: "2 x 5 = 10"
    label: qsTr("%1 = %2").arg(lineItem.jsonData.operation).arg(lineItem.jsonData.result)
    //: %1 is the answer. Example: "Answer: 10"
    info: qsTr("Answer: %1").arg(lineItem.proposal)
    infoText.font.bold: true
    infoText.color: Style.selectedPalette.highlightedText
    showResult: true
}
