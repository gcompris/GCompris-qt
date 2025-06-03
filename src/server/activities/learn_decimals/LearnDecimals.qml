/* GCompris - LearnDecimals.qml for learn_decimals, learn_quantities, learn_decimalsadditions, learn_decimals_subtraction
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

Item {
    id: lineView
    required property var jsonData
    height: details.height

    Column {
        id: details
        Text {
            width: parent.width
            height: 30
            font.pixelSize: 16
            text: lineView.jsonData.question
            color: Style.selectedPalette.text
        }
        Row {
            height: 50
            Text {
                text: lineView.jsonData.expected
                height: parent.height
                width: 80
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: Style.selectedPalette.text
            }
            Text {
                text: "\uf061"
                height: parent.height
                width: 20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: Style.selectedPalette.text
            }
            Text {
                text: lineView.jsonData.proposal
                height: parent.height
                width: 80
                color: (lineView.jsonData.proposal === lineView.jsonData.expected) ? "green" : "red"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            Text {
                text: "\uf11c"
                height: parent.height
                width: 20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                visible: lineView.jsonData.input !== ""
            }
            Text {
                text: lineView.jsonData.input.replace("," , ".")
                height: parent.height
                width: 80
                color: (Number(lineView.jsonData.input.replace("," , ".")) === lineView.jsonData.expected) ? "green" : "red"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
        }
    }
}
