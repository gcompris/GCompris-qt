/* GCompris - Algebra.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtGraphicalEffects 1.0

import "../../core"

Item {

    width: text.width
    height: text.height

    property alias text: text.text

    GCText {
        id: text
        fontSize: hugeSize
        font.bold: true
        style: Text.Outline
        styleColor: "white"
        color: "black"
    }

    DropShadow {
        anchors.fill: text
        cached: true
        horizontalOffset: 1
        verticalOffset: 1
        radius: 3.0
        samples: 16
        color: "#422a2a2a"
        source: text
    }
}
