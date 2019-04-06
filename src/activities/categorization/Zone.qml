/* GCompris - Zone.qml
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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
            width: horizontalLayout ? middleZone.width * 0.32 : middleZone.width * 0.48
            height: horizontalLayout ? categoryBackground.height * 0.2 : categoryBackground.height * 0.15
            opacity: 1
            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: horizontalLayout ? middleZone.width * 0.32 : middleZone.width * 0.48
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

                        // If we drop on same zone, we move it at its initial place
                        if(currPosition == droppedPosition) {
                            image.x = 0
                            image.y = 0
                        }
                        else {
                            Activity.dropControl(currPosition, droppedPosition, imageSource, index)
                            image.source = ""
                        }

                        Activity.setValues()
                        lastX = point1.x
                        lastY = point1.y
                    }
                }
            }
        }
    }
}

