/* GCompris - Crane.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
import "crane.js" as Activity

Image {
    property var command
    sourceSize.width: parent.width * 0.15
    sourceSize.height: parent.height * 0.55
    anchors {
        verticalCenter: parent.verticalCenter
    }
    MouseArea {
        anchors.fill: parent
        onPressed: parent.opacity = 0.6
        onReleased: parent.opacity = 1
        onClicked: {
            Activity.move(command)
        }
    }
}
