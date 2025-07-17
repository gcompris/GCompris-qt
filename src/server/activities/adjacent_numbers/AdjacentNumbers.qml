/* GCompris - AdjacentNumbers.qml for adjacent_numbers
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
    required property bool resultSuccess
    property var correctAnswer: []
    property var regex: /\((.*)\)/
    height: details.height

    Column {
        id: details
        Row {
            spacing: Style.margins

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Tiles:")
                }
            }

            Repeater {
                model: lineItem.jsonData.tiles
                delegate: DefaultLabel {
                    required property string modelData
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData
                }
            }
        }

        Row {
            spacing: Style.margins

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Answer:")
                }
            }

            Repeater {
                id: proposalRepeater
                delegate: DefaultLabel {
                    id: answerLabel
                    required property int index
                    required property string modelData
                    property bool isResult: false
                    anchors.verticalCenter: parent.verticalCenter

                    font.bold: isResult
                    color: isResult ? Style.selectedPalette.highlightedText : Style.selectedPalette.text

                    // results are bold and highlighted color, and wrong answers underlined
                    Component.onCompleted: {
                        var result = lineItem.regex.exec(modelData.match(lineItem.regex))
                        if(result) {
                            text = result[1];
                            isResult = true;
                            if(Number(result[1]) != lineItem.correctAnswer[index]) {
                                underline.visible = true;
                            }
                        } else {
                            text = modelData;
                        }
                    }

                    // custom underline, looks better than default one.
                    Rectangle {
                        id: underline
                        height: Style.defaultBorderWidth
                        width: answerLabel.contentWidth
                        color: Style.selectedPalette.highlightedText
                        visible: false
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -Style.smallMargins
                    }
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.resultSuccess
            }
        }
    }

    Component.onCompleted: {
        // Build correctAnswer scanning proposal values
        var result
        for(var i = 0; i < jsonData.proposal.length; i++) {
            result = regex.exec(jsonData.proposal[i].match(regex));
            if(!result) {  // It means no parenthesis
                var n = Number(jsonData.proposal[i])
                for(var j = 0; j < jsonData.proposal.length; j++) {
                    correctAnswer.push(n + j - i);
                }
                break;
            }
        }
        proposalRepeater.model = jsonData.proposal;
    }
}
