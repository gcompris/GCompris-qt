/* GCompris - BinaryBulb.qml for binary_bulb
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
    height: details.height

    Column {
        id: details
        Row {
            Text {
                height: contentHeight + 5
                width: 150
                verticalAlignment: Text.AlignBottom
                text: qsTr("Expected value")
                font.bold: true
                font.pixelSize: 14
                color: Style.selectedPalette.text
            }

            Text {
                height: contentHeight + 5
                width: 30
                verticalAlignment: Text.AlignBottom
                text: lineItem.jsonData.expected
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
                color: Style.selectedPalette.text
            }

            Text {
                height: contentHeight + 5
                width: 120
                verticalAlignment: Text.AlignBottom
                text: (lineItem.jsonData.expected >>> 0).toString(2)
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
                color: Style.selectedPalette.text
            }
        }

        Row {
            Text {
                height: contentHeight + 5
                width: 150
                verticalAlignment: Text.AlignBottom
                text: qsTr("Input value")
                font.bold: true
                font.pixelSize: 14
                color: Style.selectedPalette.text
            }

            Text {
                height: contentHeight + 5
                width: 30
                verticalAlignment: Text.AlignBottom
                text: lineItem.jsonData.result
                color: (lineItem.jsonData.result === lineItem.jsonData.expected) ? Style.selectedPalette.text : "red"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }

            Text {
                height: contentHeight + 5
                width: 120
                verticalAlignment: Text.AlignBottom
                text: (lineItem.jsonData.result >>> 0).toString(2)
                color: (lineItem.jsonData.result === lineItem.jsonData.expected) ? Style.selectedPalette.text : "red"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }
        }
    }

}
