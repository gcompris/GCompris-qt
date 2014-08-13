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
import QtGraphicalEffects 1.0
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
    property alias source: carImage.source
    
    property real blockSize: ((parent.width-3) / 6)
    property var xBounds: undefined
    property var yBounds: undefined

    x: (Activity.mode == "COLOR" || car.isHorizontal) ? (xPos * blockSize) : ((xPos+1) * blockSize)
    y: (Activity.mode == "COLOR" || car.isHorizontal) ? (yPos * blockSize) : ((yPos) * blockSize)

    // track effective coordinates (needed for transformed image):
    property real effX: car.xPos * car.blockSize
    property real effY: car.yPos * car.blockSize
    property real effWidth: (Activity.mode == "COLOR" || car.isHorizontal) ? car.width : car.height
    property real effHeight: (Activity.mode == "COLOR" || car.isHorizontal) ? car.height : car.width

    width: (Activity.mode == "IMAGE" || isHorizontal) ? (size * blockSize) : blockSize
    height: (Activity.mode == "IMAGE" || isHorizontal) ? blockSize : (size * blockSize)

    Item {
        id: carWrapper
        
        anchors.fill: parent
        width: parent.width
        height: parent.height
        
        Rectangle {
            id: carRect
            visible: (Activity.mode == "COLOR")
            
            z: 11
            anchors.fill: parent
            width: parent.width
            height: parent.height
            
            border.width: 1
            border.color: "white"
            
            MultiPointTouchArea {
                id: rectTouch
                anchors.fill: parent
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX;
                property real startY;
            
                onPressed: {
                    rectTouch.startX = point1.x;
                    rectTouch.startY = point1.y;
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
        
        Image {
            id: carImage
            visible: (Activity.mode == "IMAGE")
            
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            
            rotation: car.isHorizontal ? 0 : 90
            transformOrigin: Item.TopLeft
            
            MultiPointTouchArea {
                id: imageTouch
                anchors.fill: parent
                touchPoints: [ TouchPoint { id: imagePoint } ]
                property real startX;
                property real startY;
            
                onPressed: {
                    imageTouch.startX = imagePoint.x;
                    imageTouch.startY = imagePoint.y;
                }
                
                onUpdated: {
                    if (!Activity.haveWon) {
                        var deltaX = imagePoint.x - startX;
                        var deltaY = imagePoint.y - startY;
                        if (!car.isHorizontal) {
                            var w = deltaX;
                            deltaX = deltaY;
                            deltaY = w;
                        }
                        Activity.updateCarPosition(car, car.effX + deltaX, car.effY + deltaY);
                    }
                }

                onReleased: {
                    if (!Activity.haveWon)
                        Activity.snapCarToGrid(car);
                }
            }
        }
    }
    
    // note: the following leads to delayed dragging, therefore deactivated:
    //Behavior on x { PropertyAnimation { duration: 50 } }
    //Behavior on y { PropertyAnimation { duration: 50 } }
}
