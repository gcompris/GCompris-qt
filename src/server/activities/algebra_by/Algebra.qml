/* GCompris - Algebra.qml for algebra_by, algebra_div, algebra_minus, algebra_plus
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick 2.15

Item {
    id: lineItem
    required property var jsonData
    property string proposal: (jsonData.proposal !== "") ? jsonData.proposal : qsTr("timeout")

    Row {
        Text {
            text: lineItem.jsonData.operation
            height: 30
            width: 100
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            color: Style.selectedPalette.text
        }
        Text {
            text: "="
            height: 30
            width: 20
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            color: Style.selectedPalette.text
        }
        Text {
            text: lineItem.jsonData.result
            height: 30
            width: 50
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            color: Style.selectedPalette.text
        }
        Text {
            text: lineItem.proposal
            height: 30
            width: 80
            color: (Number(lineItem.proposal) === Number(lineItem.jsonData.result)) ? "green" : "red"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            color: Style.selectedPalette.text
        }
    }
}
