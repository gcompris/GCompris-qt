/* GCompris - AdjacentNumbers.qml for adjacent_numbers
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
    property var correctAnswer: []
    property var regex: /\((.*)\)/
    height: details.height

    Column {
        id: details
        spacing: 3
        Row {
            Text {
                width: 100
                height: contentHeight + 5
                text: qsTr("Tiles")
                font.bold: true
                color: Style.selectedPalette.text
            }

            Repeater {
                model: lineItem.jsonData.tiles
                delegate: Text {
                    required property string modelData
                    text: modelData
                    width: 35
                    height: contentHeight + 5
                    color: Style.selectedPalette.text
                }
            }
        }

        Row {
            Text {
                width: 100
                height: contentHeight + 5
                text: qsTr("Answer")
                font.bold: true
                color: Style.selectedPalette.text
            }

            Repeater {
                id: proposalRepeater
                delegate: Text {
                    required property string modelData
                    required property int index
                    text: {
                        var result = lineItem.regex.exec(modelData.match(lineItem.regex))
                        if (result)
                            return result[1]
                        else
                            return modelData
                    }
                    color: {
                        var result = lineItem.regex.exec(modelData.match(lineItem.regex))
                        if (result) {
                            return (Number(result[1]) === lineItem.correctAnswer[index]) ? "green" : "red"
                        } else {
                            return "black"
                        }

                    }
                    font.bold: true
                    width: 30
                    height: contentHeight + 5
                    color: Style.selectedPalette.text
                }
            }
        }
    }

    Component.onCompleted: {
        // Build correctAnswer scanning proposal values
        var result
        for (var i = 0; i < jsonData.proposal.length; i++) {
            result = regex.exec(jsonData.proposal[i].match(regex))
            if (!result) {  // It means no parenthesis
                var n = Number(jsonData.proposal[i])
                for (var j = 0; j < jsonData.proposal.length; j++)
                    correctAnswer.push(n + j - i)
                break
            }
        }
        proposalRepeater.model = jsonData.proposal
    }
}
