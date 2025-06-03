/* GCompris - WidgetOption.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu29@gmail.com> (initial version)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Rectangle {
    id: widget
    // Set the width when using it
    height: width
    color: "transparent"
    visible: element.opacity > 0

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
        width: parent.width * 0.6
        height: parent.height
        sourceSize.width: width
        source: widget.src
        mipmap: true
    }
    //number of available items
    GCText {
        id: elementText
        anchors.left: element.right
        anchors.verticalCenter: element.verticalCenter
        height: parent.height
        width: parent.width * 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        text: availableItems
        color: GCStyle.lightText
    }
    
    property alias dragAreaElement: dragAreaElement
    
    MouseArea {
        id: dragAreaElement
        anchors.fill: parent
        drag.target: (widget.canDrag) ? element : null
        enabled: element.opacity > 0 && !items.buttonsBlocked
        onPressed: {
            instructionPanel.hide()
            if (widget.name !== "candy")
                activityBackground.resetCandy()
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
