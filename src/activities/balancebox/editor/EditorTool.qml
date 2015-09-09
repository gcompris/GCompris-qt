/* GCompris - EditorTool.qml
 *
 * Copyright (C) 2015 Holger Kaelberer
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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

import QtQuick 2.0
import GCompris 1.0

Item {
    id: root

    property bool highlighted: false
    property bool selected: false
    property int type

    Rectangle {
        id: bounding
        anchors.fill: parent
        color: "silver"
        border.width: 2
        border.color: root.selected ? "red" : root.highlighted ? "yellow": "lightgray"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        hoverEnabled: ApplicationInfo.isMobile ? false : true
        onEntered: root.highlighted = true
        onExited: root.highlighted = false
        onClicked: root.selected = true
    }
}
