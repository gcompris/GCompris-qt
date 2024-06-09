/* GCompris - DataDisplay.qml for adjacent_numbers
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
            }

            Repeater {
                model: jsonData.tiles
                delegate: Text {
                    text: modelData
                    width: 35
                    height: contentHeight + 5
                }
            }
        }

        Row {
            Text {
                width: 100
                height: contentHeight + 5
                text: qsTr("Answer")
                font.bold: true
            }

            Repeater {
                id: proposalRepeater
                delegate: Text {
                    text: {
                        var result = regex.exec(modelData.match(regex))
                        if (result)
                            return result[1]
                        else
                            return modelData
                    }
                    color: {
                        var result = regex.exec(modelData.match(regex))
                        if (result) {
                            return (Number(result[1]) === correctAnswer[index]) ? "green" : "red"
                        } else {
                            return "black"
                        }

                    }
                    font.bold: true
                    width: 30
                    height: contentHeight + 5
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
