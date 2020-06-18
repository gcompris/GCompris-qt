/* GCompris - PaintCursor.qml
 *
 * Copyright (C) 2018 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "simplepaint.js" as Activity
import GCompris 1.0


Item {
    id: cursor
    property double ix
    property double iy
    property int nbx
    property int nby
    property int initialX
    // Warning testing parent here, just to avoid an error at deletion time
    property double r: parent ? Math.min((parent.width - initialX) / nbx / 2, (parent.height - bar.height) / nby / 2) : 0
    property double offsetX: parent ? (initialX + parent.width % (width * nbx)) / 2 : 0
    property double offsetY: parent ? 10 : 0
    x: width * ix + offsetX
    y: height * iy + offsetY
    width: r * 2
    height: r * 2

    Image {
        scale: 0.9
        width: parent.height
        height: parent.height
        sourceSize.width: height
        sourceSize.height: height
        source: Activity.url + "cursor.svg"
        visible: true
        anchors.centerIn: parent
    }


}
