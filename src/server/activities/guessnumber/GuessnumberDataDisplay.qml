/* GCompris - GuessnumberDataDisplay.qml
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

        DefaultLabel {
            font.pixelSize: Style.textSize
            width: lineItem.width
            height: contentHeight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            elide: Text.ElideNone
            wrapMode: Text.Wrap
            text: qsTr("Number between %1 and %2.").arg(lineItem.jsonData.minNumber).arg(lineItem.jsonData.maxNumber)
        }

        Item {
            height: Style.smallMargins
            width: 1
        }

        Row {
            spacing: Style.margins

            Item {
                id: toGuessLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Number to guess:")
                }
            }

            DefaultLabel {
                anchors.top: parent.top
                anchors.topMargin: Style.smallMargins
                font.pixelSize: Style.textSize
                width: lineItem.width - toGuessLabel.width - Style.margins
                height: contentHeight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                text: lineItem.jsonData.numberToGuess
            }
        }

        Row {
            spacing: Style.margins

            Item {
                id: stepsLabel
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Steps:")
                }
            }

            Column {
                y: Style.margins
                spacing: Style.smallMargins

                Repeater {
                    model: lineItem.jsonData.guessSteps

                    DefaultLabel {
                        required property int modelData
                        anchors.right: parent.right
                        text: modelData
                    }
                }

                Item {
                    // bottom spacer
                    height: Style.margins
                    width: 1
                }
            }
        }
    }
}
