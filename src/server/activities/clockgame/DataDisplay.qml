/* GCompris - DataDisplay.qml for clockgame
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
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    function formatTime(list) {
        return ('00'+list[0]).slice(-2) + ":" + ('00'+list[1]).slice(-2) + ":" + ('00'+list[2]).slice(-2)
    }

    Column {
        id: details
        InformationLine {
            label: qsTr("Expected")
            info: formatTime(jsonData.expected)
        }
        InformationLine {
            label: qsTr("Proposal")
            info: formatTime(jsonData.proposal)
            textColor: (result_success) ? "green" : "red"
        }
    }
}
