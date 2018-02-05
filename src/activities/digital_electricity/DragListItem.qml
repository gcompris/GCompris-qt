/* gcompris - DragListItem.qml
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "digital_electricity.js" as Activity

Item {
    id: item

    width: tile.width
    height: tile.height

    property string source: componentSrc
    property string imageName: imgName
    property string toolTipTxt: toolTipText
    property double imageWidth: imgWidth
    property double imageHeight: imgHeight
    property double heightInColumn
    property double widthInColumn
    property double tileWidth
    property double tileHeight
    property bool selected: false

    signal pressed

    Rectangle {
        id: tile
        width: tileWidth
        height: tileHeight
        color: (parent.selected && tileImage.parent == tile) ? "#33FF294D" : "transparent"
        border.color: (parent.selected && tileImage.parent == tile) ? "white" : "transparent"
        border.width: 3
        radius: 2

        property double xCenter: tile.x + tile.width / 2
        property double yCenter: tile.y + tile.height / 2
        property bool selected: false

        Image {
            anchors.centerIn: parent
            width: widthInColumn
            height: heightInColumn
            fillMode: Image.PreserveAspectFit
            source: Activity.url + imgName
        }

        Image {
            id: tileImage
            anchors.centerIn: parent
            width: smallWidth
            height: smallHeight
            fillMode: Image.PreserveAspectFit
            source: Activity.url + imgName
            mipmap: true
            antialiasing: true

            property double smallWidth: widthInColumn
            property double smallHeight: heightInColumn
            property double fullWidth: imgWidth * playArea.width
            property double fullHeight: imgHeight * playArea.height
            property QtObject tileImageParent
            property bool small: true

            function toSmall() {
                width = smallWidth
                height = smallHeight
                small = true
            }

            function toFull() {
                width = fullWidth * Activity.currentZoom
                height = fullHeight * Activity.currentZoom
                small = false
            }

            MultiPointTouchArea {
                id: mouseArea
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX
                property real startY
                property bool pressedOnce

                anchors.fill: parent

                onPressed: {
                    tileImage.anchors.centerIn = undefined
                    startX = point1.x
                    startY = point1.y
                    tileImage.toFull()
                    toolTip.show(toolTipText)
                    pressedOnce = true
                    item.selected = true
                }

                onUpdated: {
                    var moveX = point1.x - startX
                    var moveY = point1.y - startY
                    parent.x = parent.x + moveX
                    parent.y = parent.y + moveY
                }

                onReleased: {
                    if (pressedOnce) {
                        pressedOnce = false
                        item.selected = false
                        var coord = playArea.mapFromItem(tileImage.parent, parent.x, parent.y)
                        if(coord.x > 0 && ((playArea.width/Activity.currentZoom) - coord.x > tileImage.fullWidth))
                            Activity.createComponent(coord.x, coord.y, index)
                        tileImage.anchors.centerIn = tile
                        tileImage.toSmall()
                        toolTip.show("")
                    }
                }
            }
        }
    }
}
