/* GCompris - Guess24DataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: lineItem
    required property var jsonData
    height: details.height + Style.bigMargins
    property string formattedCards: ""

    ListModel { id: stepsModel }

    Flow {
        id: details
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        spacing: Style.margins

        Item {
            id: cardsItem
            height: cardsLabel.height + Style.bigMargins
            width: childrenRect.width

            DefaultLabel {
                id: cardsLabel
                height: implicitHeight
                font.pixelSize: Style.textSize
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: lineItem.jsonData.cards.join("\n")
                color: Style.selectedPalette.text
            }
        }

        Repeater {
            id: stepsRepeater
            model: stepsModel
            Rectangle {
                id: stepsItem
                height: stepsColumn.height + Style.bigMargins
                width: stepsColumn.width + Style.bigMargins
                border.width: Style.defaultBorderWidth
                border.color: Style.selectedPalette.accent
                color: "transparent"
                required property string content_
                required property int index

                Column {
                    id: stepsColumn
                    anchors.centerIn: parent
                    DefaultLabel {
                        id: stepsLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: implicitHeight
                        font.pixelSize: Style.textSize
                        text: stepsItem.content_
                    }

                    DefaultLabel {
                        id: hintsLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: stepsItem.index === stepsRepeater.count - 1 &&
                            lineItem.jsonData.hints
                        font.bold: true
                        font.italic: true
                        //: %1 is number of hints displayed. Example: "Hints: 1"
                        text: qsTr("Hints: %1").arg(lineItem.jsonData.hints)
                    }
                }
            }
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
