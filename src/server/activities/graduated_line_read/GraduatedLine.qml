/* GCompris - GraduatedLine.qml for graduated_line_read and graduated_line_use
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
    required property bool resultSuccess
    property int step: (jsonData.end - jsonData.start) / (jsonData.ticks - 1)
    height: details.height
    clip: true

    Row {
        id: details
        spacing: Style.margins

        Repeater {
            id: proposalRepeater
            model: lineItem.jsonData.ticks
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
                    if((answerLabel.index === 0) || (answerLabel.index === lineItem.jsonData.ticks - 1)) {
                        text = lineItem.jsonData.start + (answerLabel.index * lineItem.step);
                    } else if (lineItem.jsonData.start + (answerLabel.index * lineItem.step) === jsonData.expected) {
                        text = lineItem.jsonData.proposal;
                        isResult = true;
                        if(jsonData.proposal != jsonData.expected) {
                            underline.visible = true;
                        }
                    } else {
                        text = "|";
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
