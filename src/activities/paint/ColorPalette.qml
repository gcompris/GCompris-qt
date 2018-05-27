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

Item {
    id: colorPalette
    width: background.width * 0.9
    height: background.height * 0.9
    anchors.centerIn: parent
    z: 1501

    property alias colorModel: colorModel

    ListModel {
        id: colorModel
        ListElement {colorCode: "#ff0000"} ListElement {colorCode: "#00ff00"} ListElement {colorCode: "#0000ff"} ListElement {colorCode: "#8b008b"}
        ListElement {colorCode: "#ffff00"} ListElement {colorCode: "#00ffff"} ListElement {colorCode: "#000000"} ListElement {colorCode: "#ff00ff"}
        ListElement {colorCode: "#ffffff"} ListElement {colorCode: "#800000"} ListElement {colorCode: "#000080"} ListElement {colorCode: "#ff4500"}
        ListElement {colorCode: "#ff00ff"} ListElement {colorCode: "#006400"} ListElement {colorCode: "#A0A0A0"} ListElement {colorCode: "#d2691e"}
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        visible: items.colorPalette.visible
        radius: 10
        color: "grey"
    }

    Rectangle {
        id: container
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        opacity: 0.9
        radius: 10
        border.width: 2
        border.color: "white"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#fff" }
            GradientStop { position: 0.9; color: "#fff" }
            GradientStop { position: 1.0; color: "#ddd" }
        }

        // The close panel button
        GCButtonCancel {
            id: cancelButton
            onClose: colorPalette.visible = false
        }

        GridView {
            id: colorRepeater
            model: colorModel
            anchors.top: cancelButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: colorPalette.width * 0.9
            height: colorPalette.height * 0.75
            cellWidth: width / 4.2
            cellHeight: height / 4.2
            interactive: false
            delegate: Rectangle {
                id: root
                radius: 8
                width: colorRepeater.cellWidth * 0.80
                height: colorRepeater.cellHeight * 0.90
                color: modelData

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: root.scale = 1.1
                    onExited: root.scale = 1

                    // choose other color:
                    onDoubleClicked: {
                        items.activeColorIndex = index
                        colorDialog.visible = true
                    }

                    // set this color as current paint color
                    onClicked: {
                        items.activeColorIndex = index
                        items.paintColor = root.color
                        background.hideExpandedTools()
                        items.paintColor = color
                        background.reloadSelectedPen()
                        colorPalette.visible = false
                    }
                }

                Rectangle {
                    width: parent.width * 0.30
                    height: parent.height * 0.30
                    anchors.top: parent.top
                    anchors.right: parent.right
                    color: "transparent"

                    Image {
                        source: Activity.url + "color_wheel.svg"
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
}

