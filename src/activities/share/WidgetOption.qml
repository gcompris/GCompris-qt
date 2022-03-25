/* GCompris - WidgetOption.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
