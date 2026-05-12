/* GCompris - ReversecountDataDisplay.qml
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

    readonly property int numberOfBlocks: 16

    Column {
        id: details

        Row {
            id: dominoModeRow
            spacing: Style.margins
            visible: lineItem.jsonData.hasOwnProperty("dominoMode")

            Item {
                id: dominoModeLabel
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
                width: lineItem.width - dominoModeLabel.width - Style.margins
                height: contentHeight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                elide: Text.ElideNone
                wrapMode: Text.Wrap
                text: dominoModeRow.visible ? lineItem.jsonData.dominoMode : ""
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
                    text: qsTr("Tux position:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.currentPosition
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
                    text: qsTr("Interval:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.currentPosition > lineItem.jsonData.index ?
                        ((lineItem.numberOfBlocks - lineItem.jsonData.currentPosition) + lineItem.jsonData.index) :
                        (lineItem.jsonData.index - lineItem.jsonData.currentPosition)
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

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    // display addition of 2 numbers and its result
                    text: qsTr("(%1 + %2) = %3").arg(lineItem.jsonData.dice1).arg(lineItem.jsonData.dice2).arg(lineItem.jsonData.dice1 + lineItem.jsonData.dice2)
                }
            }
        }
    }
}
