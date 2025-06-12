/* GCompris - ClockGame.qml for clockgame
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
    id: lineItem
    required property var jsonData
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    function formatTime(list) {
        return ('00'+list[0]).slice(-2) + ":" + ('00'+list[1]).slice(-2) + ":" + ('00'+list[2]).slice(-2)
    }

    Column {
        id: details
        InformationLine {
            labelWidth: lineItem.labelWidth
            label: qsTr("Expected")
            info: formatTime(lineItem.jsonData.expected)
        }
        InformationLine {
            labelWidth: lineItem.labelWidth
            label: qsTr("Proposal")
            info: formatTime(lineItem.jsonData.proposal)
            textColor: (result_success) ? "green" : "red"
        }
    }
}
