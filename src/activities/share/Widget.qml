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

        GCText {
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            text: (widget.name !== "basket") ? widget.n - widget.nCrt : ""
        }

        property alias dragAreaElement: dragAreaElement

        MouseArea {
            id: dragAreaElement
            anchors.fill: parent
            enabled: (widget.name === "basket") ? (background.rest!==0) ? true : false : "undefined"
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
                // idea of implementation -> mapFromItem
                //var compas = mapFromItem(grid,girl.x,girl.y)
                //if (girl.x>compas.x && girl.x<compas.x+grid.width && girl.y>compas.y && girl.y<compas.y+grid.height) {

                var offset = (widget.name == "basket") ? 6 : 4

                var offsetX = background.vert ? widget.width : offset * widget.width
                var offsetY = background.vert ? offset * widget.height : widget.height

                switch(widget.name) {

                case "candy":
                    if (background.nCrtCandies<items.nCandies) {
                        items.acceptCandy = true

                        for (var i=0;i<listModel1.count;i++) {
                            var c = repeater_drop_areas.itemAt(i)     //DropChild type

                            var e = drop_areas.mapToItem(background, c.x, c.y)
                            var d = element.parent.mapToItem(background, element.x, element.y)    //coordinates of "boy/girl rectangle" in background coordinates

//                            print("Modif_x ", d.x)
//                            print("Modif_y ", d.y)

//                            print("DropA_x ", e.x)
//                            print("DropA_y ", e.y)

                            if (d.x>e.x && d.x<e.x+c.area.width && d.y>e.y+c.childImg.height && d.y<e.y+c.childImg.height+c.area.height) {
                                listModel1.setProperty(i,"countS",listModel1.get(i).countS+1)
                                background.nCrtCandies ++
                            }

                            if (background.nCrtCandies==items.nCandies) {
                                //items.acceptCandy = false
                                widget.canDrag = false
                                background.resetCandy()
                                candyWidget.element.opacity = 0.6
                            }
                        }
                    }
                    else {
                        //items.acceptCandy = false
                        widget.canDrag = false
                        background.resetCandy()
                        element.opacity = 0.6
                    }
                    break;

                case "basket":
                    if (background.contains(element.x,element.y,grid,offsetX,offsetY)) {
                        if (widget.canDrag) {
                            widget.canDrag = false
                            listModel1.append({countS: 0, nameS: "basket"});
                        }
                    }
                    break;

                //default is for "boy" and "girl"
                default:
                    if (background.contains(element.x,element.y,grid,offsetX,offsetY)) {
                        if (widget.nCrt<widget.n) {
                            if (widget.canDrag) {
                                widget.nCrt ++
                                listModel1.append({countS: 0, nameS: widget.name});
                                if (widget.nCrt===widget.n) {
                                    widget.canDrag = false
                                    element.opacity = 0.6
                                }
                            }
                        }
                        else
                            widget.canDrag = false
                    }
                }

                element.x = widget.lastx
                element.y = widget.lasty

            }

        }
    }
}
