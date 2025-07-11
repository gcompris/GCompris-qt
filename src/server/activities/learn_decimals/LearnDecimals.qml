/* GCompris - LearnDecimals.qml for learn_decimals, learn_quantities, learn_decimals_additions, learn_decimals_subtraction
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
    height: details.height

    Column {
        id: details
        width: parent.width

        Item {
            height: Style.lineHeight
            width: parent.width

            DefaultLabel {
                horizontalAlignment: Text.AlginLeft
                width: parent.width
                text: lineItem.jsonData.question
            }
        }


        Row {
            height: Style.lineHeight
            spacing: Style.bigMargins

            DefaultLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: lineItem.jsonData.expected
            }

            // Arrow character
            DefaultLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: "\uf061"
            }

            DefaultLabel {
                id: answerLabel
                anchors.verticalCenter: parent.verticalCenter
                text: lineItem.jsonData.proposal
                font.bold: isWrongAnswer
                font.italic: isWrongAnswer
                color: isWrongAnswer ? Style.selectedPalette.highlightedText : Style.selectedPalette.text

                property bool isWrongAnswer: (lineItem.jsonData.proposal != lineItem.jsonData.expected)

                // custom underline, looks better than default one.
                Rectangle {
                    id: underline
                    height: Style.defaultBorderWidth
                    width: answerLabel.contentWidth
                    color: Style.selectedPalette.highlightedText
                    visible: answerLabel.isWrongAnswer
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -Style.smallMargins
                }
            }

            // Keyboard character
            DefaultLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: "\uf11c"
                visible: lineItem.jsonData.input !== ""
            }

            DefaultLabel {
                id: typedAnswerLabel
                anchors.verticalCenter: parent.verticalCenter
                text: replacedText
                font.bold: isWrongAnswer
                font.italic: isWrongAnswer
                color: isWrongAnswer ? Style.selectedPalette.highlightedText : Style.selectedPalette.text

                property string replacedText: lineItem.jsonData.input.replace("," , ".")
                property bool isWrongAnswer: (Number(replacedText) != lineItem.jsonData.expected)

                // custom underline, looks better than default one.
                Rectangle {
                    id: underline2
                    height: Style.defaultBorderWidth
                    width: typedAnswerLabel.contentWidth
                    color: Style.selectedPalette.highlightedText
                    visible: typedAnswerLabel.isWrongAnswer
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -Style.smallMargins
                }
            }

            ResultIndicator {
                anchors.verticalCenter: parent.verticalCenter
                resultSuccess: lineItem.resultSuccess
            }
        }
    }
}
