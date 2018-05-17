/* GCompris - ColorPalette.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "paint.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: colorPalette
    width: parent.width
    height: parent.height
    radius: 20
    border.width: 5
    border.color: "black"

    // The close panel button
    GCButtonCancel {
        id: cancelButton
        onClose: parent.visible = false
    }

    GridView {
        id: colorRepeater
        model: items.colors
        //anchors.centerIn: parent
        anchors.top: cancelButton.bottom
        anchors.horizontalCenter: colorPalette.horizontalCenter
        width: parent.width * 0.95
        visible: colorPalette.visible
        height: background.height - bar.height - 20
        cellWidth: (parent.width * 0.95) / 5
        cellHeight: (parent.height * 0.90) / 3.6
        delegate: Rectangle {
            id: root
            radius: 5
            width: colorRepeater.cellWidth
            height: colorRepeater.cellHeight
            color: modelData
            //property real dim: (background.width - 16) / Activity.colors.length
            property bool active: items.paintColor === color
            border.color: active? "#595959" : "#f2f2f2"
            border.width: 3
            MouseArea {
                anchors.fill: parent

                // choose other color:
                onDoubleClicked: {
                    items.activeColorIndex = index
                    colorDialog.visible = true
                }

                // set this color as current paint color
                onClicked: {
                    items.activeColorIndex = index
                    root.active = (items.activeColorIndex === index) ? true : false
                    items.paintColor = root.color

                    //                    for (var i = 0; i < colorRepeater.; i++)
                    //                        if (i != index)
                    //                            colorRepeater.itemAt(i).active = false

                    background.hideExpandedTools()

                    // choose other color
                    if (color == "#c2c2d6") {
                        colorDialog.visible = true
                    } else {
                        items.paintColor = color
                    }

                    background.reloadSelectedPen()
                    colorPalette.visible = false
                }
            }
            Rectangle {
                width: parent.width * 0.20
                height: parent.height * 0.20
                anchors.top: parent.top
                anchors.right: parent.right
                //color: "transparent"
                Image {
                    source: Activity.url + "color_picker.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        items.activeColorIndex = index
                        colorDialog.visible = true
                        console.log("Clicked on color picker!")
                    }
                }
            }
        }
    }

}

