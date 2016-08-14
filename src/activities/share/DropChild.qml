/* GCompris - DropChild.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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

Rectangle {
    id: dropChild
    width: items.cellSize * 3
    height: items.cellSize * 4.5
    color: "transparent"
    radius: 0.2
    z: 5

    property string name
    property alias childImage: childImage
    property alias area: area
    property int indexS: index

    Image {
        id: childImage
        sourceSize.width: items.cellSize * 1.5 * 0.7
        sourceSize.height: items.cellSize * 1.5 - 5
        anchors.bottom: area.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        source: "resource/images/" + name + ".svg"
    }

    //displays the number of candies each child has
    GCText {
        id: candyCount
        anchors.bottom: area.top
        anchors.right: parent.right
        anchors.rightMargin: 20

        //"listModel.get(index) ? ... " because of an error received at startup of each level
        text: (listModel.get(index) && background.showCount) ? listModel.get(index).countS : ""

    }

    Rectangle {
        id: area
        width: items.cellSize * 3
        height: items.cellSize * 3
        anchors.bottom: parent.bottom
        radius: width * 0.07

        color: "#cfecf0"

        property var childCoordinate: repeater_drop_areas.mapToItem(background, dropChild.x, dropChild.y)
        property var candyCoord: candyWidget.mapToItem(background, candyWidget.element.x, candyWidget.element.y)

        opacity: candyCoord.x > childCoordinate.x &&
                 candyCoord.y > childCoordinate.y + childImage.height &&
                 candyCoord.x < childCoordinate.x + childCoordinate.width &&
                 candyCoord.y < childCoordinate.y + childCoordinate.height ? 0.5 : 1

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (items.acceptCandy)
                    ////////////////////// START of EASY mode
                    if (background.easyMode) {
                        if (background.currentCandies < items.totalCandies) {
                            if (listModel.get(index).countS + 1 <= 8) {
                                //add candies in the first rectangle
                                listModel.setProperty(index,"countS",listModel.get(index).countS+1)
                                //the current number of candies increases
                                background.currentCandies ++
                                //on the last one, the candy image from top goes away (destroy)
                                if (background.currentCandies === items.totalCandies) {
                                    background.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }
                                //show the basket if there is a rest
                                if (background.rest!=0 && background.basketShown() === false)
                                    items.basketWidget.element.opacity = 1
                            } else print("onclidked else: ", listModel.get(index).countS+1 + " -------------> NO MORE")
                        }
                        else {
                            background.resetCandy()
                            candyWidget.element.opacity = 0.6
                        }

                    ////////////////////// END of EASY mode
                    } else {
                        if (background.currentCandies < items.candyWidget.total) {
                            if (listModel.get(index).countS + 1 <= 8) {
                                //add candies in the first rectangle
                                listModel.setProperty(index,"countS",listModel.get(index).countS+1)
                                //the current number of candies increases
                                background.currentCandies ++

                                //show the basket if there is a rest
                                if (background.rest!=0 && background.basketShown() === false)
                                    items.basketWidget.element.opacity = 1

                                if (background.currentCandies + 1 === items.candyWidget.total) {
                                    background.resetCandy()
                                }
                            } else {
                                background.wrongMove.fadeInOut.start()
                                print("onclidked else: ", listModel.get(index).countS+1 + " -------------> NO MORE")
                            }
                        }
                    }
                    /////////////////// END of HARD mode
            }
        }


        Flow {
            id: candy_drop_area
            spacing: 5
            width: parent.width
            height: parent.height

            Repeater {
                id: repeater_candy_drop_area
                model: countS

                Image {
                    id: candyArea
                    sourceSize.width: items.cellSize * 0.7
                    sourceSize.height: items.cellSize * 1.5
                    source: "resource/images/candy.svg"

                    property int lastX
                    property int lastY

                    MouseArea {
                        anchors.fill: parent

                        //enables dragging the candie after placed
                        drag.target: parent

                        onPressed: {
                            instruction.hide()
                            //set the initial position
                            candyArea.lastX = candyArea.x
                            candyArea.lastY = candyArea.y
                            //move this rectangle/grid on top of everything
                            dropChild.z++
                            grid.z++

                            print("new dropChild.z " + dropChild.z + "   grid.z " +  grid.z)
                        }

                        onReleased:  {
                            //move this rectangle/grid to its previous state
                            dropChild.z--
                            grid.z--

                            print("orig dropChild.z " + dropChild.z + "   grid.z " +  grid.z)

                            //check where the candy is being dropped
                            for (var i=0; i<listModel.count; i++) {
                                var currentChild = repeater_drop_areas.itemAt(i)
                                //coordinates of "boy/girl rectangle" in background coordinates
                                var childCoordinate = drop_areas.mapToItem(items.background, currentChild.x, currentChild.y)

                                var candyCoordinate = candyArea.parent.mapToItem(background, candyArea.x, candyArea.y)
                                var wid = items.leftWidget

                                if (currentChild !== dropChild) {
                                    //check if the user wants to put a candy to another rectangle
                                    if (candyCoordinate.x > childCoordinate.x &&
                                            candyCoordinate.x < childCoordinate.x + currentChild.area.width &&
                                            candyCoordinate.y > childCoordinate.y + currentChild.childImage.height &&
                                            candyCoordinate.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {
                                        //add the candy to the "i"th recthangle
                                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                                        //remove the candy from current rectangle
                                        listModel.setProperty(rect2.indexS, "countS", listModel.get(rect2.indexS).countS - 1);
                                        break;
                                    }
                                }
                                else {
                                    //check if the user wants to put back the candy to the leftWidget
                                    if (candyCoordinate.x > 0 && candyCoordinate.x < wid.width &&
                                            candyCoordinate.y > 0 && candyCoordinate.y < wid.height) {
                                        //restore the candy to the leftWidget
                                        background.currentCandies--
                                        candyWidget.element.opacity = 1
                                        items.candyWidget.canDrag = true
                                        //remove the candy from current rectangle
                                        listModel.setProperty(rect2.indexS, "countS", listModel.get(rect2.indexS).countS - 1);
                                        break;
                                    }
                                }
                            }

                            //restore the candy to its initial position
                            candyArea.x = candyArea.lastX
                            candyArea.y = candyArea.lastY
                        }

                        //when clicked, it will restore the candy
                        onClicked:  {
                            background.currentCandies--
                            candyWidget.element.opacity = 1
                            items.candyWidget.canDrag = true
                            listModel.setProperty(rect2.indexS, "countS", listModel.get(rect2.indexS).countS - 1);
                        }
                    }
                }
            }
        }
    }
}
