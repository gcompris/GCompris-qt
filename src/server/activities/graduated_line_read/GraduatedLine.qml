/* GCompris - GraduatedLine.qml for graduated_line_read and graduated_line_use
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Basic

import "../../singletons"
import "../../components"
import "../../panels"

Item {
    property var jsonData: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
    property int step: (jsonData.end - jsonData.start) / (jsonData.ticks - 1)
    height: details.height
    clip: true

    Row {
        id: details
        Repeater {
            model: jsonData.ticks
            delegate: Rectangle {
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
                        if ((index === 0) || (index === jsonData.ticks - 1))
                            return jsonData.start + (index * step)
                        if (jsonData.start + (index * step) === jsonData.expected)
                            return jsonData.proposal
                        return "|"
                    }
                    color: {
                        if (jsonData.start + (index * step) === jsonData.expected) {
                            return (jsonData.proposal === jsonData.expected) ? "green" : "red"
                        }
                        return "black"
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
