/* GCompris - Car.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 * 
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
    
    property real blockSize: parent.width / 6
    property var xBounds: undefined
    property var yBounds: undefined

    property string mode
    property bool isMoving: false

    Component.onCompleted: {
        mode = parent.mode
        connection.target = parent
    }
    // Connect the jamGrid.mode to car.mode to automatically change the wrapped object
    Connections {
        id: connection
        onModeChanged: {
            car.mode = parent.mode;
        }
    }

    x: (mode == "COLOR" || car.isHorizontal) ? (xPos * blockSize) : ((xPos+1) * blockSize)
    y: (mode == "COLOR" || car.isHorizontal) ? (yPos * blockSize) : ((yPos) * blockSize)

    // track effective coordinates (needed for transformed image):
    property real effX: car.xPos * car.blockSize
    property real effY: car.yPos * car.blockSize
    property real effWidth: (mode == "COLOR" || car.isHorizontal) ? car.width : car.height
    property real effHeight: (mode == "COLOR" || car.isHorizontal) ? car.height : car.width
    property GCSfx audioEffects

    width: (mode == "IMAGE" || isHorizontal) ? (size * blockSize) : blockSize
    height: (mode == "IMAGE" || isHorizontal) ? blockSize : (size * blockSize)

    Item {
        id: carWrapper
        
        anchors.fill: parent
        width: parent.width
        height: parent.height
        
        Rectangle {
            id: carRect
            visible: (mode == "COLOR")
            
            z: 11
            anchors.fill: parent
            width: parent.width
            height: parent.height
            
            border.width: 2
            border.color: "white"
            
            MultiPointTouchArea {
                id: rectTouch
                anchors.fill: parent
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX;
                property real startY;
            
                onPressed: {
                    if (!Activity.isMoving) {
                        Activity.isMoving = true;
                        car.isMoving = true;
                        car.audioEffects.play(Activity.baseUrl + "car.wav")
                        rectTouch.startX = point1.x;
                        rectTouch.startY = point1.y;
                    }
                }
                
                onUpdated: {
                    if (car.isMoving && !Activity.haveWon) {
                        var deltaX = point1.x - startX;
                        var deltaY = point1.y - startY;
                        Activity.updateCarPosition(car, car.x + deltaX, car.y + deltaY);
                    }
                }

                onReleased: {
                    if (car.isMoving) {
                        car.isMoving = false;
                        Activity.isMoving = false;
                        if (!Activity.haveWon)
                            Activity.snapCarToGrid(car);
                    }
                }
            }
        }
        
        Image {
            id: carImage
            visible: (mode == "IMAGE")
            
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
                    if (!Activity.isMoving) {
                        Activity.isMoving = true;
                        car.isMoving = true;
                        car.audioEffects.play(Activity.baseUrl + "car.wav")
                        imageTouch.startX = imagePoint.x;
                        imageTouch.startY = imagePoint.y;
                    }
                }
                
                onUpdated: {
                    if (car.isMoving && !Activity.haveWon) {
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
                    if (car.isMoving) {
                        Activity.isMoving = false;
                        car.isMoving = false;
                        if (!Activity.haveWon)
                            Activity.snapCarToGrid(car);
                    }
                }
            }
        }
    }
    
    // note: the following leads to delayed dragging, therefore deactivated:
    //Behavior on x { PropertyAnimation { duration: 50 } }
    //Behavior on y { PropertyAnimation { duration: 50 } }
}
