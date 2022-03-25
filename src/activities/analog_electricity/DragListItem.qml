/* gcompris - DragListItem.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "analog_electricity.js" as Activity

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
            sourceSize.width: widthInColumn
            sourceSize.height: heightInColumn
            width: widthInColumn
            height: heightInColumn
            fillMode: Image.PreserveAspectFit
            mipmap: true
            antialiasing: true
            source: Activity.url + imgName
        }

        Image {
            id: tileImage
            anchors.centerIn: parent
            sourceSize.width: fullWidth * 0.5
            sourceSize.height: fullHeight * 0.5
            width: widthInColumn
            height: heightInColumn
            fillMode: Image.PreserveAspectFit
            source: Activity.url + imgName
            mipmap: true
            antialiasing: true
            opacity: 0

            property double fullWidth: imgWidth * playArea.sizeMultiplier
            property double fullHeight: imgHeight * playArea.sizeMultiplier
            property QtObject tileImageParent

            function toSmall() {
                item.z = 1;
                opacity = 0;
                width = widthInColumn;
                height = heightInColumn;
            }

            function toFull() {
                item.z = 100;
                width = fullWidth * Activity.currentZoom;
                height = fullHeight * Activity.currentZoom;
                opacity = 1;
            }

            MultiPointTouchArea {
                id: mouseArea
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX
                property real startY
                property bool pressedOnce

                anchors.fill: parent

                onPressed: {
                    tileImage.anchors.centerIn = undefined;
                    tileImage.toFull();
                    startX = point1.x;
                    startY = point1.y;
                    toolTip.show(toolTipText);
                    pressedOnce = true;
                    item.selected = true;
                    Activity.disableToolDelete();
                }

                onUpdated: {
                    var moveX = point1.x - startX;
                    var moveY = point1.y - startY;
                    parent.x = parent.x + moveX;
                    parent.y = parent.y + moveY;
                }

                onReleased: {
                    if (pressedOnce) {
                        pressedOnce = false;
                        item.selected = false;
                        var coord = playArea.mapFromItem(tileImage.parent, parent.x, parent.y);
                        if(coord.x > 0 && coord.y > 0 && ((playArea.width/Activity.currentZoom) - coord.x > tileImage.fullWidth))
                            Activity.createComponent(coord.x, coord.y, index);
                        tileImage.anchors.centerIn = tile;
                        tileImage.toSmall();
                        toolTip.show("");
                    }
                }
            }
        }
    }
}
