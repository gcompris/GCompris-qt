/* GCompris - backgroundColorPalette.qml
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
import "drawing.js" as Activity
import "../../core"
import GCompris 1.0

Rectangle {
    id: colorPalette
    width: background.width * 0.85
    height: background.height * 0.70
    radius: 10
    anchors.centerIn: parent
    color: foldablePanels.panelColor

    MouseArea {
        anchors.fill: parent
    }

    // The close panel button
    GCButtonCancel {
        id: cancelButton
        width: background.width > background.height ? 60 * ApplicationInfo.ratio : 45 * ApplicationInfo.ratio
        height: width
        visible: items.backgroundColorPalette.visible
        onClose: items.backgroundColorPalette.visible = false
    }

    GridView {
        id: colorRepeater
        model: foldablePanels.colorModel
        anchors.top: cancelButton.bottom
        anchors.horizontalCenter: colorPalette.horizontalCenter
        width: parent.width * 0.95
        visible: colorPalette.visible
        height: parent.height * 0.90
        cellWidth: (parent.width * 0.95) / 4
        cellHeight: (parent.height * 0.90) / 4
        interactive: false
        delegate: Rectangle {
            id: root
            radius: 10
            width: colorRepeater.cellWidth * 0.80
            height: colorRepeater.cellHeight * 0.80
            color: modelData
            border.color: "grey"
            border.width: 3
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.scale = 1.1
                onExited: parent.scale = 1
                onClicked: {
                    items.backgroundColor = root.color
                    items.backgroundColorPalette.visible = false
                    Activity.selectTool("Erase all")
                }
            }
        }
    }
}
