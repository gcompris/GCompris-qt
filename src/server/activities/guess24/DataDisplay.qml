/* GCompris - DataDisplay.qml for guess24
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

    ListModel { id: stepsModel }

    Row {
        id: details
        spacing: 15
        Text {
            anchors.topMargin: 4
            anchors.rightMargin: 5
            font.bold: true
            horizontalAlignment: Text.AlignRight
            text: jsonData.cards.join("\n")
        }

        Repeater {
            model: stepsModel
            Text {
                anchors.topMargin: 6
                text: content_
            }
        }

        Text {
            font.bold: true
            text: (jsonData.hints) ?  qsTr("Hints") + ": " + jsonData.hints : ""
            color: "red"
        }
    }

    Component.onCompleted: {
        var steps = jsonData.steps
        var content = []
        var lastWasBack = false
        for (var i = 0; i < steps.length; i++) {
            if (steps[i] === "back") {
                if (!lastWasBack)
                    stepsModel.append( { content_: content.join("\n") })
                content.pop()
                lastWasBack = true
            } else {
                content.push(steps[i])
                lastWasBack = false
            }
        }
        stepsModel.append( { content_: content.join("\n") })
    }
}
