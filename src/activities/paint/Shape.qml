/* GCompris - Shape.qml
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

Item {
    id: shape
    property string shape
    property string color: "black"

    Rectangle {
        id: rectangle
        color: shape.color
        width: parent.width
        height: parent.height
        enabled: parent.shape == "rectangle"
        opacity: parent.shape == "rectangle" ? 1 : 0
    }

    Rectangle {
        id: circle
        radius: width / 2
        color: shape.color
        width: parent.width
        height: parent.width
        enabled: parent.shape == "circle"
        opacity: parent.shape == "circle" ? 1 : 0
    }

    // creates a triangle, but works only with qt quick 2.7
/*    Path {
        startX: 0; startY: 0
        PathSvg { path: "L 150 50 L 100 150 z" }
    }
*/

}