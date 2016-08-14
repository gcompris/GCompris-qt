/* GCompris - ToolItem.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
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

import QtQuick 2.1
import "paint.js" as Activity

Image {
    id: toolItem
    sourceSize.width: 70; sourceSize.height: 70
    width: 70; height: 70
    source: Activity.url + name + ".svg"
    opacity: items.toolSelected == name ? 1 : 0.4

    property string name
    signal click

    MouseArea {
        anchors.fill: parent
        onClicked: {
            items.toolSelected = name
            items.lastToolSelected = name
            background.hideExpandedTools()

            showSelected.x = toolItem.x + row2.spacing
            showSelected.y = toolItem.y + row2.spacing * 0.5

            // make the hover over the canvas false
            area.hoverEnabled = false

            // change the selectBrush tool
            timer.index = 0
            timer.start()

            background.reloadSelectedPen()

            click()
        }
    }
}
