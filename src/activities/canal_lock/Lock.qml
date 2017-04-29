/* GCompris - Lock.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

Rectangle {
    id: lock
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.paintedWidth * 0.05
    height: maxHeight
    border.width: 0
    state: "close"

    property int minHeight
    property int maxHeight
    property int duration

    Behavior on height { NumberAnimation { duration: lock.duration } }

    states: [
        State {
            name: "open"
            PropertyChanges { target: lock; height: lock.minHeight}
        },
        State {
            name: "close"
            PropertyChanges { target: lock; height: lock.maxHeight}
        }
    ]
}
