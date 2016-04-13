/* GCompris - Widget.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick version)
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

import QtQuick 2.5
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
    property int lastx
    property int lasty
    property string src
    property int nCrt: 0
    property int n: 0
    property string name
    property bool canDrag: true
    property alias element: element

    Image {
        id: element
        sourceSize.width: items.cellSize * 1.5
        sourceSize.height: items.cellSize * 1.5
        source: widget.src

        //number of available items
        GCText {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text: (widget.name !== "basket") ? widget.n - widget.nCrt : ""
        }

        property alias dragAreaElement: dragAreaElement

        MouseArea {
            id: dragAreaElement
            anchors.fill: parent
            enabled: (widget.name === "basket") ?
                         (background.rest !== 0) ? true : false : "undefined"
            drag.target: (widget.canDrag) ? parent : null
            onPressed: {
                instruction.hide()
                if (widget.name !== "candy")
                    background.resetCandy()
                //set the initial position
                widget.lastx = element.x
                widget.lasty = element.y
            }

            onReleased:  {
                var newCoord = widget.mapToItem(background, element.x, element.y)
                var basketActive = false

                switch(widget.name) {
                case "candy":
                    if (background.nCrtCandies < items.nCandies) {
                        items.acceptCandy = true

                        for (var i = 0; i < listModel1.count; i++) {
                            var dropCh = repeater_drop_areas.itemAt(i)     //DropChild type

                            var dropChCurent = drop_areas.mapToItem(background, dropCh.x, dropCh.y)
                            var elem = element.parent.mapToItem(background, element.x, element.y)    //coordinates of "boy/girl rectangle" in background coordinates

                            if (elem.x > dropChCurent.x && elem.x < dropChCurent.x + dropCh.area.width &&
                                    elem.y > dropChCurent.y + dropCh.childImg.height &&
                                    elem.y < dropChCurent.y + dropCh.childImg.height + dropCh.area.height) {
                                listModel1.setProperty(i, "countS", listModel1.get(i).countS+1)
                                background.nCrtCandies ++
                            }

                            if (background.nCrtCandies == items.nCandies) {
                                widget.canDrag = false
                                background.resetCandy()
                                candyWidget.element.opacity = 0.6
                            }

                            //find if the basket is already present on the board
                            if (dropCh.name === "basket" && background.rest != 0) {
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
                    break;

                case "basket":
                    if (background.contains(newCoord.x, newCoord.y, grid)) {
                        if (widget.canDrag) {
                            widget.canDrag = false
                            widget.element.opacity = 0
                            listModel1.append({countS: 0, nameS: "basket"});
                        }
                    }
                    break;

                    //default is for "boy" and "girl"
                default:
                    if (background.contains(newCoord.x, newCoord.y, grid)) {
                        if (widget.nCrt < widget.n) {
                            if (widget.canDrag) {
                                widget.nCrt ++
                                listModel1.append({countS: 0, nameS: widget.name});
                                if (widget.nCrt === widget.n) {
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
                element.x = widget.lastx
                element.y = widget.lasty
            }
        }
    }
}
