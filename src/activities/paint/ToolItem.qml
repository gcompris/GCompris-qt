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
    id: button
    width: 60; height: 60
    source: Activity.url + name + ".svg"
    opacity: items.toolSelected == name ? 1 : 0.6

    property string name
    signal click

    MouseArea {
        anchors.fill: parent
        onClicked: {
            items.toolSelected = name
            items.lastToolSelected = name
            background.hideExpandedTools()

            // make the hover over the canvas false
            area.hoverEnabled = false

            // change the selectBrush tool
            timer.index = 0
            timer.start()

            click()
        }
    }
}
