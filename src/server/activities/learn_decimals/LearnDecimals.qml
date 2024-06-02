/* GCompris - LearnDecimals.qml for learn_decimals, learn_quantities, learn_decimalsadditions, learn_decimals_subtraction
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
    height: details.height

    Column {
        id: details
        Text {
            width: parent.width
            height: 30
            font.pixelSize: 16
            text: jsonData.question
        }
        Row {
            height: 50
            Text {
                text: jsonData.expected
                height: parent.height
                width: 80
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            Text {
                text: "\uf061"
                height: parent.height
                width: 20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            Text {
                text: jsonData.proposal
                height: parent.height
                width: 80
                color: (jsonData.proposal === jsonData.expected) ? "green" : "red"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            Text {
                text: "\uf11c"
                height: parent.height
                width: 20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                visible: jsonData.input !== ""
            }
            Text {
                text: jsonData.input.replace("," , ".")
                height: parent.height
                width: 80
                color: (Number(jsonData.input.replace("," , ".")) === jsonData.expected) ? "green" : "red"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
        }
    }
}
