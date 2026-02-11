/* GCompris - TensComplementUseDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
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
    height: details.height

    Column {
        id: details
        spacing: Style.margins
        Row {
            spacing: Style.margins
            height: Style.lineHeight

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Proposed numbers:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.proposedNumbers.toString()
                }
            }
        }

        Repeater {
            model: lineItem.jsonData.questionList
            delegate: Column {
                id: questionColumn
                required property string addition
                required property string answer
                required property bool isCorrect

                Row {
                    spacing: Style.margins
                    height: Style.lineHeight

                    Item {
                        height: Style.lineHeight
                        width: childrenRect.width

                        DefaultLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                            text: qsTr("Question:")
                        }
                    }

                    Item {
                        height: Style.lineHeight
                        width: childrenRect.width

                        DefaultLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            text: questionColumn.addition
                        }
                    }
                }

                Row {
                    spacing: Style.margins
                    height: Style.lineHeight

                    Item {
                        height: Style.lineHeight
                        width: childrenRect.width

                        DefaultLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                            text: qsTr("Answer:")
                        }
                    }

                    Item {
                        height: Style.lineHeight
                        width: childrenRect.width

                        DefaultLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            text: questionColumn.answer
                        }
                    }

                    ResultIndicator {
                        resultSuccess: questionColumn.isCorrect
                    }
                }
            }
        }
    }
}
