/* GCompris - Component.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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

import "../digital_electricity.js" as Activity

Image {
    id: electricalComponent
    property double posX
    property double posY
    property double imgWidth
    property double imgHeight
    property string imgSrc
    property string information
    property string toolTipTxt
    property var truthTable: []
    property int index
    property int noOfInputs
    property int noOfOutputs
    property int rotationAngle: 0
    property int initialAngle: 0
    property int startingAngle: 0
    property double terminalSize
    property bool destructible

    property alias rotateComponent: rotateComponent

    x: posX * parent.width
    y: posY * parent.height
    width: imgWidth * parent.width
    height: imgHeight * parent.height
    fillMode: Image.PreserveAspectFit

    source: Activity.url + imgSrc
    z: 2
    mipmap: true
    antialiasing: true

    onPaintedWidthChanged: {
        updateDragConstraints()
        Activity.updateWires(index)
    }

    PropertyAnimation {
        id: rotateComponent
        target: electricalComponent
        property: "rotation"
        from: initialAngle; to: initialAngle + rotationAngle
        duration: 1
        onStarted:{ Activity.animationInProgress = true }
        onStopped: {
            initialAngle = initialAngle + rotationAngle
            Activity.updateWires(index)
            if(initialAngle == startingAngle + rotationAngle * 45) {
                if(initialAngle == 360 || initialAngle == -360)
                    initialAngle = 0
                startingAngle = initialAngle
                Activity.animationInProgress = false
                updateDragConstraints()
            }
            else
                rotateComponent.start()
        }
        easing.type: Easing.InOutQuad
    }

    function updateDragConstraints() {
        if(initialAngle == 0 || initialAngle == 180 || initialAngle == 360 || initialAngle == -360
           || initialAngle == -180) {
            mouseArea.drag.minimumX = (electricalComponent.paintedWidth - electricalComponent.width)/2
            mouseArea.drag.minimumY = (electricalComponent.paintedHeight - electricalComponent.height)/2

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedWidth)/2
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedHeight)/2
        }
        else {
            mouseArea.drag.minimumX = (electricalComponent.paintedHeight - electricalComponent.width)/2
            mouseArea.drag.minimumY = (electricalComponent.paintedWidth - electricalComponent.height)/2

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedHeight)/2
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedWidth)/2
        }
    }

    MouseArea {
        id: mouseArea
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.centerIn: parent
        drag.target: electricalComponent
        onPressed: {
            Activity.updateToolTip(toolTipTxt)
            Activity.componentSelected(index)
        }
        onClicked: {
            if(Activity.toolDelete || Activity.toolDeleteSticky) {
                if (destructible) {
                    Activity.removeComponent(index)
                } else {
                    Activity.deselect()
                }
            }
            else {
                if(imgSrc == "switchOff.svg") {
                    imgSrc = "switchOn.svg"
                    Activity.updateComponent(index)
                }
                else if(imgSrc == "switchOn.svg") {
                    imgSrc = "switchOff.svg"
                    Activity.updateComponent(index)
                }
            }
        }
        onReleased: {
            parent.posX = parent.x / parent.parent.width
            parent.posY = parent.y / parent.parent.height
            Activity.updateToolTip("")
        }

        onPositionChanged: {
            updateDragConstraints()
            Activity.updateWires(index)
        }
    }
}
