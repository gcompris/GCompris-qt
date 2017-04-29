/* GCompris - SearchItem.qml
 *
 * Copyright (C) 2015 Holger Kaelberer  <holger.k@elberer.de>
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

import QtQuick 2.6
import GCompris 1.0
//import QtGraphicalEffects 1.0
import "superbrain.js" as Activity

Item {
    id: root
    property int searchItemIndex: 0
    property alias border: color.border
    property alias radius: color.radius
    property bool highlightSymbol: false

    Image {
        id: symbol
        visible: Activity.mode === "symbol"
        fillMode: Image.PreserveAspectFit
        source: Activity.symbols[root.searchItemIndex]
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 3
        width: parent.width - 6
        height: parent.height - 6
    }
    Rectangle {
        id: symbolHighlighter
        visible: (Activity.mode === "symbol") && root.highlightSymbol
        anchors.fill: parent
        width: parent.width
        height: parent.height
        border.width: 3
        border.color: "white"
        color: "transparent"
    }

    Rectangle {
        id: color
        visible: Activity.mode === "color"
        color: Activity.colors[root.searchItemIndex]
        anchors.fill: parent
        width: parent.width
        height: parent.height
        radius: width / 2
    }
}
