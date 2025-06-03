/* GCompris - Guess24.qml for guess24
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
    id: lineItem
    required property var jsonData
    height: details.height
    property string formattedCards: ""

    ListModel { id: stepsModel }

    Row {
        id: details
        spacing: 15
        Text {
            anchors.topMargin: 4
            anchors.rightMargin: 5
            font.bold: true
            horizontalAlignment: Text.AlignRight
            text: lineItem.jsonData.cards.join("\n")
            color: Style.selectedPalette.text
        }

        Repeater {
            model: stepsModel
            Text {
                required property string content_
                anchors.topMargin: 6
                text: content_
                color: Style.selectedPalette.text
            }
        }

        Text {
            font.bold: true
            text: (lineItem.jsonData.hints) ?  qsTr("Hints") + ": " + lineItem.jsonData.hints : ""
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
