/* GCompris - GrammarDisplay.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
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
    height: wordsFlow.height + Style.lineHeight

    Flow {
        id: wordsFlow
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        spacing: Style.margins

        Repeater {
            model: lineItem.jsonData.sentence      // loop on words from the sentence
            delegate: Column {
                id: wordColumn
                required property string modelData
                required property int index
                property var expected: lineItem.jsonData.expected
                property var proposal: lineItem.jsonData.proposal

                Item {
                    height: Style.lineHeight
                    width: wordLabel.width
                    anchors.horizontalCenter: parent.horizontalCenter

                    DefaultLabel {
                        id: wordLabel
                        anchors.centerIn: parent
                        text: wordColumn.modelData
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: classLabel.width
                    anchors.horizontalCenter: parent.horizontalCenter

                    DefaultLabel {
                        id: classLabel
                        anchors.centerIn: parent
                        color: Style.selectedPalette.highlightedText
                        text: wordColumn.proposal[wordColumn.index]
                    }

                    // custom underline, looks better than default one.
                    Rectangle {
                        id: underline
                        height: Style.defaultBorderWidth * 2
                        width: classLabel.contentWidth
                        color: Style.selectedPalette.highlightedText
                        visible: (wordColumn.expected[wordColumn.index] !=
                            wordColumn.proposal[wordColumn.index])
                        anchors.verticalCenter: parent.bottom
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: expectedClassLabel.width
                    anchors.horizontalCenter: parent.horizontalCenter

                    DefaultLabel {
                        id: expectedClassLabel
                        anchors.centerIn: parent
                        opacity: 0.5
                        text: wordColumn.expected[wordColumn.index]
                    }
                }
            }
        }
    }
}
