/* GCompris - DataDisplay.qml for binary_bulb
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
import QtQuick.Controls.Basic

import "../../singletons"
import "../../components"
import "../../panels"

Item {
    property var jsonData: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
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
            }

            Text {
                height: contentHeight + 5
                width: 30
                verticalAlignment: Text.AlignBottom
                text: jsonData.expected
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }

            Text {
                height: contentHeight + 5
                width: 120
                verticalAlignment: Text.AlignBottom
                text: (jsonData.expected >>> 0).toString(2)
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
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
            }

            Text {
                height: contentHeight + 5
                width: 30
                verticalAlignment: Text.AlignBottom
                text: jsonData.result
                color: (jsonData.result === jsonData.expected) ? "black" : "red"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }

            Text {
                height: contentHeight + 5
                width: 120
                verticalAlignment: Text.AlignBottom
                text: (jsonData.result >>> 0).toString(2)
                color: (jsonData.result === jsonData.expected) ? "black" : "red"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }
        }
    }

}
