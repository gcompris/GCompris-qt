/* GCompris - hanoi_real.qml
 *
 * Copyright (C) 2014 Amit Tomar <a.tomar@outlook.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Amit Tomar <a.tomar@outlook.com> (Qt Quick port)
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
import QtGraphicalEffects 1.0

Colorize {
    anchors.fill: source
    hue: 0.4
    saturation: 1
    lightness: .5
    cached: true
    opacity: 0

    property bool highlight: false
    onHighlightChanged: highlight ? opacity = 0.75 : opacity = 0

    Behavior on opacity { PropertyAnimation { duration: 150 } }
}
