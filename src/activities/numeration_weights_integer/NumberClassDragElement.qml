/* GCompris - NumberClassDragElement.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
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
import GCompris 1.0

import "../../core"

// TODO: make text fitting in Rectangle

Rectangle {
    id: numberClassDragElement

    width: parent.width - parent.width/5
    height: parent.height / 15

    property int lastX
    property int lastY
    property int lastZ

    property string name
    property bool dragEnabled: true

    Drag.active: numberClassDragElementMouseArea.drag.active

    opacity: dragEnabled ? 1 : 0.5

    //number of available items
    GCText {
        id: numberClassElementCaption

        anchors.fill: parent    //? here text does not fit in parent
        anchors.bottom: parent.bottom
        fontSizeMode: Text.Fit
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: name
    }

    MouseArea {
        id: numberClassDragElementMouseArea
        anchors.fill: parent

        drag.target: (numberClassDragElement.dragEnabled) ? parent : null
        drag.axis: numberClassDragElement.x < parent.width ? Drag.XAxis : Drag.XAndYAxis
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        onPressed: {
            instruction.hide()
            //set the initial position
            numberClassDragElement.lastX = numberClassDragElement.x
            numberClassDragElement.lastY = numberClassDragElement.y
        }

        onReleased: {
            parent.Drag.drop()
            //set the element to its initial coordinates
            numberClassDragElement.x = numberClassDragElement.lastX
            numberClassDragElement.y = numberClassDragElement.lastY
        }
    }
}
