/* GCompris - Zone.qml
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "categorization.js" as Activity

Flow {
    id: zoneFlow
    width: parent.width/3
    height: parent.height
    property alias repeater: repeater
    property alias model: zoneModel

    ListModel {
        id: zoneModel
    }

    Repeater {
        id: repeater
        model: zoneModel
        Item {
            id: item
            width: itemWidth
            height: itemWidth
            opacity: 1
            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: itemWidth
                width: sourceSize.width
                height: sourceSize.width
                source: name
                MultiPointTouchArea {
                    id: dragArea
                    anchors.fill: parent
                    touchPoints: [ TouchPoint { id: point1 } ]
                    property real positionX
                    property real positionY
                    property real lastX
                    property real lastY
                    property bool isRight: isRight
                    property string currPosition: "middle"
                    property string imageSource: image.source.toString()

                    onPressed: {
                        items.instructionsVisible = false
                        positionX = point1.x
                        positionY = point1.y
                        var imagePos = image.mapToItem(null,0,0)
                        if(Activity.isDragInLeftArea(leftScreen.width, imagePos.x + parent.width)) {
                            currPosition = "left"
                        }
                        else if(Activity.isDragInRightArea(middleScreen.width + leftScreen.width,imagePos.x)) {
                            currPosition = "right"
                        }
                        else
                            currPosition = "middle"
                    }

                    onUpdated: {
                        var moveX = point1.x - positionX
                        var moveY = point1.y - positionY
                        parent.x = parent.x + moveX
                        parent.y = parent.y + moveY
                        var imagePos = image.mapToItem(null,0,0)
                        leftAreaContainsDrag = Activity.isDragInLeftArea(leftScreen.width, imagePos.x + parent.width)
                        rightAreaContainsDrag = Activity.isDragInRightArea(middleScreen.width + leftScreen.width,imagePos.x)
                        lastX = 0, lastY = 0
                    }

                    onReleased: {
                        var droppedPosition = "middle";
                        if(lastX == point1.x && lastY == point1.y)
                            return;
                        else if(leftAreaContainsDrag)
                            droppedPosition = "left"
                        else if(rightAreaContainsDrag)
                            droppedPosition = "right"

                        Activity.setValues()

                        // If we drop on same zone, we move it at its initial place
                        if(currPosition == droppedPosition) {
                            image.x = 0
                            image.y = 0
                        }
                        else {
                            Activity.dropControl(currPosition, droppedPosition, imageSource, index)
                            image.source = ""
                        }

                        lastX = point1.x
                        lastY = point1.y
                    }
                }
            }
        }
    }
}

