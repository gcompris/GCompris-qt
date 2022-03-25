/* GCompris - DropChild.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
    property alias candyCount: candyCount

    Image {
        id: childImage
        width: items.cellSize
        sourceSize.width: width
        anchors.bottom: area.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        source: "resource/images/" + name + ".svg"
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    //displays the number of candies each child has
    GCText {
        id: candyCount
        color: "#373737"
        anchors.bottom: area.top
        anchors.right: parent.right
        anchors.rightMargin: 20

        //"listModel.get(index) ? ... " because of an error received at startup of each level
        text: (listModel.get(index)) ? listModel.get(index).countS : ""
    }

    Rectangle {
        id: area
        width: items.cellSize * 3
        height: items.cellSize * 3
        anchors.bottom: parent.bottom
        radius: width * 0.07

        color: "#f2f2f2"

        property var childCoordinate: repeaterDropAreas.mapToItem(background, dropChild.x, dropChild.y)
        property var candyCoord: candyWidget.mapToItem(background, candyWidget.element.x, candyWidget.element.y)

        opacity: candyCoord.x > childCoordinate.x &&
                 candyCoord.y > childCoordinate.y + childImage.height &&
                 candyCoord.x < childCoordinate.x + childCoordinate.width &&
                 candyCoord.y < childCoordinate.y + childCoordinate.height ? 0.5 : 1

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (items.acceptCandy) {
                    // Easy mode
                    if (background.easyMode) {
                        if (background.currentCandies < items.candyWidget.total) {
                            if (listModel.get(index).countS + 1 <= items.maxNumberOfCandiesPerWidget) {
                                //add candies in the first rectangle
                                repeaterDropAreas.itemAt(index).candyCount.text = listModel.get(index).countS + 1
                                listModel.setProperty(index, "countS", listModel.get(index).countS + 1)
                                //the current number of candies increases
                                background.currentCandies ++
                                //on the last one, the candy image from top goes away (destroy)
                                if (background.currentCandies === items.candyWidget.total) {
                                    background.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }
                            }
                            else {
                                background.wrongMove.visible = true
                            }
                        }
                        else {
                            background.resetCandy()
                            candyWidget.element.opacity = 0.6
                        }
                    }
                    // Hard mode
                    else {
                        if (background.currentCandies < items.candyWidget.total) {
                            if (listModel.get(index).countS + 1 <= items.maxNumberOfCandiesPerWidget) {
                                //add candies in the first rectangle
                                repeaterDropAreas.itemAt(index).candyCount.text = listModel.get(index).countS + 1
                                listModel.setProperty(index, "countS", listModel.get(index).countS + 1)
                                //the current number of candies increases
                                background.currentCandies ++
                                if (background.currentCandies === items.candyWidget.total) {
                                    background.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }
                            }
                            else {
                                background.wrongMove.visible = true
                            }
                        }
                    }
                }
            }
        }

        Flow {
            id: candyDropArea
            spacing: 5
            width: parent.width
            height: parent.height

            Repeater {
                id: repeaterCandyDropArea
                model: countS

                Image {
                    id: candyArea
                    sourceSize.width: items.cellSize * 0.6
                    sourceSize.height: items.cellSize * 1.2
                    source: "resource/images/candy.svg"
                    fillMode: Image.PreserveAspectFit

                    property int lastX
                    property int lastY

                    MouseArea {
                        anchors.fill: parent

                        //enables dragging the candy after placed
                        drag.target: parent

                        onPressed: {
                            instruction.hide()
                            //set the initial position
                            candyArea.lastX = candyArea.x
                            candyArea.lastY = candyArea.y
                            //move this rectangle/grid on top of everything
                            dropChild.z++
                        }

                        function childContainsCandy(currentChild, candy) {
                            //coordinates of "boy/girl rectangle" in background coordinates
                            var child = dropAreas.mapToItem(items.background, currentChild.x, currentChild.y)
                            return (candy.x > child.x &&
                                candy.x < child.x + currentChild.area.width &&
                                candy.y > child.y + currentChild.childImage.height &&
                                candy.y < child.y + currentChild.childImage.height + currentChild.area.height)
                        }

                        onReleased: {
                            //move this rectangle/grid to its previous state
                            dropChild.z--

                            var candyCoordinate = candyArea.parent.mapToItem(background, candyArea.x, candyArea.y)

                            //check where the candy is being dropped
                            for (var i = 0 ; i < listModel.count ; i++) {
                                var currentChild = repeaterDropAreas.itemAt(i)

                                if (currentChild !== dropChild) {
                                    //check if the user wants to put a candy to another rectangle
                                    if (childContainsCandy(currentChild, candyCoordinate)) {
                                        // don't drop more than the maximum of allowed candies per widget
                                        if(listModel.get(currentChild.indexS).countS >= items.maxNumberOfCandiesPerWidget) {
                                            background.wrongMove.visible = true
                                            break;
                                        }

                                        //add the candy to the i-th rectangle
                                        repeaterDropAreas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                                        listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                                        //remove the candy from current rectangle
                                        repeaterDropAreas.itemAt(rect2.indexS).candyCount.text = listModel.get(rect2.indexS).countS - 1
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
                        onClicked: {
                            repeaterDropAreas.itemAt(rect2.indexS).candyCount.text = listModel.get(rect2.indexS).countS - 1
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
