/* GCompris - Car.qml
 *
 * Copyright (C) 2014 Holger Kaelberer 
 * 
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
import GCompris 1.0
import "../../core"
import "traffic.js" as Activity

Item {
    id: car

    property int xPos
    property int yPos
    property int size
    property bool goal: false
    property bool isHorizontal: false
    property alias color: carRect.color
    property real blockSize: ((parent.width-3) / 6)

    x: xPos * blockSize
    y: yPos * blockSize

    width: isHorizontal ? (size * blockSize) : blockSize
    height: isHorizontal ? blockSize : (size * blockSize)

    Rectangle {
        id: carRect
        z: 11
        anchors.fill: parent
        width: parent.width
        height: parent.height
        
        border.width: 1
        border.color: "white"
    }

    // note: the following leads to delayed dragging, therefore deactivated:
    //Behavior on x { PropertyAnimation { duration: 50 } }
    //Behavior on y { PropertyAnimation { duration: 50 } }

    MultiPointTouchArea {
        id: carTouch
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: point1 } ]
        property real startX;
        property real startY;
    
        onPressed: {
            carTouch.startX = point1.x;
            carTouch.startY = point1.y;
        }
        
        onUpdated: {
            if (!Activity.haveWon) {
                var deltaX = point1.x - startX;
                var deltaY = point1.y - startY;
                Activity.updateCarPosition(car, car.x + deltaX, car.y + deltaY);
            }
        }

        onReleased: {
            if (!Activity.haveWon)
                Activity.snapCarToGrid(car);
        }
    }
}
