/* GCompris - WidgetOption.qml
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
import QtQuick.Window 2.2
import GCompris 1.0

import "../../core"

Rectangle {
    id: widget

    width: items.cellSize * 1.5
    height: items.cellSize * 1.5
    color: "transparent"

    //initial position of the element
    //(these vars are assigned to element after release of click mouse)
    property int lastX
    property int lastY
    property string src
    property int current: 0
    property int total: 0
    property string name
    property bool canDrag: true
    property alias element: element

    Image {
        id: element
        sourceSize.width: items.cellSize * 1.5
        sourceSize.height: items.cellSize * 1.5
        source: widget.src

        property alias elementText: elementText

        //number of available items
        GCText {
            id: elementText
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text: (background.showCount && widget.name !== "basket" && background.easyMode) ?
                      widget.total - widget.current : ""
        }

        property alias dragAreaElement: dragAreaElement

        MouseArea {
            id: dragAreaElement
            anchors.fill: parent
            drag.target: (widget.canDrag) ? parent : null
            onPressed: {
                instruction.hide()
                if (widget.name !== "candy")
                    background.resetCandy()
                //set the initial position
                widget.lastX = element.x
                widget.lastY = element.y
            }

            onReleased:  {
                var newCoordinate = widget.mapToItem(background, element.x, element.y)
                var basketActive = false

                switch(widget.name) {
                case "candy":
                    // Easy mode
                    if (background.easyMode) {
                        if (background.currentCandies < items.totalCandies) {
                            items.acceptCandy = true

                            for (var i = 0; i < listModel.count; i++) {
                                var currentChild = repeater_drop_areas.itemAt(i)
                                var childCoordinate = drop_areas.mapToItem(background, currentChild.x, currentChild.y)
                                //coordinates of "boy/girl rectangle" in background coordinates
                                if ((listModel.get(i).countS + 1) > 8) {
                                    continue
                                }

                                var currentElement = element.parent.mapToItem(background, element.x, element.y)

                                if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                                        currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                                        currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {
                                    repeater_drop_areas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                                    listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                                    background.currentCandies ++
                                }

                                if (background.currentCandies == items.totalCandies) {
                                    widget.canDrag = false
                                    background.resetCandy()
                                    candyWidget.element.opacity = 0.6
                                }

                                //find if the basket is already present on the board
                                if (currentChild.name === "basket" && background.rest != 0) {
                                    basketActive = true
                                }
                            }

                            //if there is rest and the basket is not yet present on the board, show the basket
                            if (background.rest != 0 && basketActive === false)
                                items.basketWidget.element.opacity = 1
                        }
                        else {
                            widget.canDrag = false
                            background.resetCandy()
                            element.opacity = 0.6
                        }

                    // Hard mode
                    } else {
                        if (background.currentCandies < widget.total) {
                            items.acceptCandy = true

                            for (i = 0; i < listModel.count; i++) {
                                currentChild = repeater_drop_areas.itemAt(i)
                                childCoordinate = drop_areas.mapToItem(background, currentChild.x, currentChild.y)
                                //coordinates of "boy/girl rectangle" in background coordinates
                                currentElement = element.parent.mapToItem(background, element.x, element.y)

                                if (currentElement.x > childCoordinate.x && currentElement.x < childCoordinate.x + currentChild.area.width &&
                                        currentElement.y > childCoordinate.y + currentChild.childImage.height &&
                                        currentElement.y < childCoordinate.y + currentChild.childImage.height + currentChild.area.height) {

                                    if ((listModel.get(i).countS + 1) > 8) {
                                        background.wrongMove.fadeInOut.start()
                                        continue
                                    }

                                    repeater_drop_areas.itemAt(i).candyCount.text = listModel.get(i).countS + 1
                                    listModel.setProperty(i, "countS", listModel.get(i).countS + 1)
                                    background.currentCandies ++
                                }
                            }
                            // if all the "dropAreas" are full with 8 candies, then stop the "swing" effect of the candy in leftWidget
                            if (background.currentCandies + 1 == widget.total)
                                background.resetCandy()
                        }
                    }
                    break;

                case "basket":
                    if (background.contains(newCoordinate.x, newCoordinate.y, grid)) {
                        if (widget.canDrag) {
                            widget.canDrag = false
                            widget.element.opacity = 0
                            listModel.append({countS: 0, nameS: "basket"});
                        }
                    }
                    break;

                //default is for "boy" and "girl"
                default:
                    if (background.contains(newCoordinate.x, newCoordinate.y, grid)) {
                        if (widget.current < widget.total) {
                            if (widget.canDrag) {
                                widget.current ++
                                listModel.append({countS: 0, nameS: widget.name});

                                // set the candies already "present"
                                if (widget.name == "boy") {
                                    repeater_drop_areas.itemAt(listModel.count-1).candyCount.text = background.placedInBoys
                                    listModel.setProperty(listModel.count-1, "countS", background.placedInBoys)
                                }
                                if (widget.name == "girl") {
                                    repeater_drop_areas.itemAt(listModel.count-1).candyCount.text = background.placedInGirls
                                    listModel.setProperty(listModel.count-1, "countS", background.placedInGirls)
                                }

                                if (widget.current === widget.total) {
                                    widget.canDrag = false
                                    element.opacity = 0.6
                                }
                            }
                        }
                        else
                            widget.canDrag = false
                    }
                }
                //set the widget to its initial coordinates
                element.x = widget.lastX
                element.y = widget.lastY
            }
        }
    }
}
