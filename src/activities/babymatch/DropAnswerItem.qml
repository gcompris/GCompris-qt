/* gcompris - DropAnswerItem.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0
import "babymatch.js" as Activity

Rectangle {
    id: dropCircle
    
    property string dropCircleColor: currentTileImageItem ? 'transparent' : 'pink'
    property string text
    property double posX
    property double posY
    property string imgName
    property double xCenter: x + width / 2
    property double yCenter: y + height / 2
    property Item currentTileImageItem

    width: parent.width > parent.height ? parent.height/35 : parent.width/35
    height: width
    radius: width/2
    z: 200
    
    border.width: 1
    color: Activity.displayDropCircle ? dropCircleColor : "transparent"
    border.color: dropCircle.color == "#000000" ? "transparent" : "red"
    
    x: posX * parent.width - width/2
    y: posY * parent.height - height/2
    
    // Display a shadow of image, when the image is hovered over a target area
    Image {
        id: targetImage
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        z : -1
    }

    function imageRemove() {
        if(currentTileImageItem)
            currentTileImageItem.imageRemove()
        currentTileImageItem = null
    }

    function imageAdd(tileImageItem) {
        currentTileImageItem = tileImageItem
        dropCircle.color = dropCircleColor
    }

    function show(tileImageItem) {
        if(Activity.displayDropCircle)
            dropCircle.color = "lightgreen"

        targetImage.source = tileImageItem.source
        targetImage.width = tileImageItem.fullWidth
        targetImage.height = tileImageItem.fullHeight
        if(currentTileImageItem) {
            currentTileImageItem.opacity = 0
        }
        if (tileImageItem.parentIsTile) {
            targetImage.opacity = 1
            tileImageItem.opacity = 0.5
            dropCircle.z = 100
        }
        else
            targetImage.opacity = 0.5
    }

    function hide() {
        dropCircle.color = Activity.displayDropCircle ? dropCircleColor : "transparent"
        targetImage.opacity = 0
        dropCircle.z = 200
        if(currentTileImageItem)
            currentTileImageItem.opacity = 1
    }
}
