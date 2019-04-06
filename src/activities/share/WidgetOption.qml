/* GCompris - WidgetOption.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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

Rectangle {
    id: widget

    width: element.opacity > 0 ? items.cellSize * 1.5 : 0
    height: width
    color: "transparent"

    //initial position of the element
    //(these vars are assigned to element after release of click mouse)
    property int lastX
    property int lastY
    property string src
    property int current: 0
    property int total: 0
    property string name
    property bool canDrag: true
    property alias element: element

    property string availableItems

    // callback defined in each widget called when we release the element in background
    property var releaseElement: null

    Image {
        id: element
        fillMode: Image.PreserveAspectFit
        width: items.cellSize
        sourceSize.width: width
        source: widget.src
        mipmap: true
    }
    //number of available items
    GCText {
        id: elementText
        anchors.left: element.right
        anchors.bottom: element.bottom
        text: availableItems
        color: "#f2f2f2"
    }
    
    property alias dragAreaElement: dragAreaElement
    
    MouseArea {
        id: dragAreaElement
        anchors.fill: parent
        drag.target: (widget.canDrag) ? element : null
        enabled: element.opacity > 0
        onPressed: {
            instruction.hide()
            if (widget.name !== "candy")
                background.resetCandy()
                //set the initial position
                widget.lastX = element.x
                widget.lastY = element.y
        }
        
        onReleased: {
            widget.releaseElement()
            //set the widget to its initial coordinates
            element.x = widget.lastX
            element.y = widget.lastY
        }
    }
}
