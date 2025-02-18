/* GCompris - DraggableTile.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import core 1.0
import "../../core"

/**
 * Could use guesscount/DragTile?
 */
MouseArea {    
    id: draggableMouseArea
    width: 1
    height: width

    property bool dropActive: true
    property int onGoingAnimationCount: 0

    // For storing the initial position when dragged
    property point beginDragPosition
    property MouseArea originalParent
    property bool mouseHeld: false

    // anchors.fill: parent

    drag.target: dragableElement
    enabled: (!onGoingAnimationCount) && items.buttonsEnabled

    onPressed: {
        z = 100
        draggableMouseArea.beginDragPosition = Qt.point(dragableElement.x, dragableElement.y)
        mouseHeld = true
        // Activity.targetColorReset()
    }
    onReleased: {
        z = 0
        dragableElement.Drag.drop()
        mouseHeld = false
        dragableElement.parent = draggableMouseArea

        // The element may die on drop if removed, check if it exists
        if(dragableElement) {
            dragableElement.x = beginDragPosition.x
            dragableElement.y = beginDragPosition.y
        }
    }

    Rectangle {
        id: dragableElement
        width: parent.width
        height: parent.height
        color: "#FFFFFF"
        opacity: 1
        radius: GCStyle.baseMargins

        Drag.keys: ""
        Drag.active: draggableMouseArea.drag.active
        Drag.hotSpot.x: width/2
        Drag.hotSpot.y: height/2

        property string valueText: dragableValueText.text

        GCText {
            id: dragableValueText
            text: value
            anchors.centerIn: parent
            height: parent.height * 0.6
            width: parent.width * 0.6
            fontSizeMode: Text.Fit
            fontSize: largeSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
