/* GCompris - GraduatedLine.qml for graduated_line_read and graduated_line_use
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: gradLine
    required property var jsonData
    property int step: (jsonData.end - jsonData.start) / (jsonData.ticks - 1)
    height: details.height
    clip: true

    Row {
        id: details
        Repeater {
            model: gradLine.jsonData.ticks
            delegate: Rectangle {
                id: box
                required property int index
                color:  "transparent"
                width:  t_metrics.tightBoundingRect.width + 20
                height: t_metrics.tightBoundingRect.height + 20

                Text {
                    id: theText
                    anchors.fill: parent
                    anchors.topMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    height: 30
                    text: {
                        if ((box.index === 0) || (box.index === gradLine.jsonData.ticks - 1))
                            return gradLine.jsonData.start + (box.index * step)
                        if (jsonData.start + (box.index * step) === jsonData.expected)
                            return jsonData.proposal
                        return "|"
                    }
                    color: {
                        if (gradLine.jsonData.start + (box.index * step) === jsonData.expected) {
                            return (jsonData.proposal === jsonData.expected) ? "green" : "red"
                        }
                        return Style.selectedPalette.text
                    }
                    font.pixelSize: 16
                }

                TextMetrics {
                    id:     t_metrics
                    font:   theText.font
                    text:   theText.text
                }
            }
        }
    }
}
