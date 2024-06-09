/* GCompris - Algebra.qml for algebra_by, algebra_div, algebra_minus, algebra_plus
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
    property string proposal: (jsonData.proposal !== "") ? jsonData.proposal : qsTr("timeout")

    Row {
        Text {
            text: jsonData.operation
            height: 30
            width: 100
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }
        Text {
            text: "="
            height: 30
            width: 20
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }
        Text {
            text: jsonData.result
            height: 30
            width: 50
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }
        Text {
            text: proposal
            height: 30
            width: 80
            color: (Number(proposal) === Number(jsonData.result)) ? "green" : "red"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }
    }
}
