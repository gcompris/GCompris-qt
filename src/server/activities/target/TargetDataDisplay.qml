/* GCompris - TargetDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *  Timothée Giet <animtim@gmail.com>
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

        Row {
            spacing: Style.margins

            Item {
                id: targetValuesLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Target values:")
                }
            }

            DefaultLabel {
                anchors.top: parent.top
                anchors.topMargin: Style.smallMargins
                font.pixelSize: Style.textSize
                width: lineItem.width - targetValuesLabel.width - Style.margins
                height: contentHeight
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                elide: Text.ElideNone
                wrapMode: Text.Wrap
                text: lineItem.jsonData.targetValues.join(", ")
            }
        }

        Row {
            spacing: Style.margins

            Item {
                id: additionLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Addition:")
                }
            }

            DefaultLabel {
                anchors.top: parent.top
                anchors.topMargin: Style.smallMargins
                font.pixelSize: Style.textSize
                width: lineItem.width - additionLabel.width - Style.margins
                height: contentHeight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                elide: Text.ElideNone
                wrapMode: Text.Wrap
                text: lineItem.jsonData.addition
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

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.answer
                }
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.answer != lineItem.jsonData.expectedAnswer

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Expected answer:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: lineItem.jsonData.expectedAnswer
                }
            }
        }
    }
}
