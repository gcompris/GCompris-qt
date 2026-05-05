/* GCompris - GlettersDataDisplay.qml
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
    property bool isDominoMode: false
    height: details.height

    Column {
        id: details

        Row {
            spacing: Style.margins
            visible: lineItem.isDominoMode

            Item {
                id: targetValuesLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Domino mode:")
                }
            }

            DefaultLabel {
                anchors.top: parent.top
                anchors.topMargin: Style.smallMargins
                font.pixelSize: Style.textSize
                width: lineItem.width - targetValuesLabel.width - Style.margins
                height: contentHeight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                elide: Text.ElideNone
                wrapMode: Text.Wrap
                text: lineItem.isDominoMode ? lineItem.jsonData.dominoMode : ""
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.droppedItems.length > 0

            Item {
                id: additionLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Visible items:")
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
                text: lineItem.jsonData.droppedItems.join(", ")
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.typedText != ""

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Typed answer:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.typedText
                }
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.missedText != ""

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Missed item:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.missedText
                }
            }
        }
    }
}
