/* GCompris - EnumerateDataDisplay.qml
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
    height: details.height + Style.margins

    Column {
        id: details
        y: Style.smallMargins
        spacing: Style.margins

        Repeater {
            model: Object.keys(jsonData.answerToFind)

            Row {
                id: answerRow
                required property string modelData
                spacing: Style.margins

                Image {
                    sourceSize.width: Style.lineHeight
                    sourceSize.height: Style.lineHeight
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/gcompris/src/server/resource/" + answerRow.modelData + ".svg"

                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width

                    DefaultLabel {
                        id: expectedText
                        anchors.verticalCenter: parent.verticalCenter
                        text: jsonData.answerToFind[answerRow.modelData]
                    }
                }

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
                        id: answerText
                        anchors.verticalCenter: parent.verticalCenter
                        text: jsonData.userAnswers[answerRow.modelData] != undefined ?
                            jsonData.userAnswers[answerRow.modelData] : "?"
                    }
                }

                ResultIndicator {
                    resultSuccess: expectedText.text === answerText.text
                }
            }
        }
    }
}
