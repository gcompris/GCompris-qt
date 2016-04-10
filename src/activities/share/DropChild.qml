import QtQuick 2.1
import GCompris 1.0

import "../../core"


//drop area rectangle
Rectangle {
    id: dropChild
    width: items.cellSize * 3
    height: items.cellSize * 3 + items.cellSize * 1.5
    color: "transparent"
    z: 5

    property string name
    property alias childImg: childImg
    property alias area: area
    property int indexS: index

    Image {
        id: childImg
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

        //"listModel1.get(index) ? ... " because of an error received at startup of each level
        text: listModel1.get(index) ? listModel1.get(index).countS : ""
    }

    Rectangle {
        id: area
        width: items.cellSize * 3
        height: items.cellSize * 3
        anchors.bottom: parent.bottom

        color: "#cfecf0"

        property var c: repeater_drop_areas.mapToItem(background, dropChild.x, dropChild.y)
        property var d: candyWidget.mapToItem(background, candyWidget.element.x, candyWidget.element.y)

        opacity: d.x > c.x &&
                 d.y > c.y + childImg.height &&
                 d.x < c.x + dropChild.width &&
                 d.y < c.y + dropChild.height ? 0.5 : 1

        MouseArea {
            id: rect1MouseArea
            anchors.fill: parent

            onClicked: {
                if (items.acceptCandy)
                    if (background.nCrtCandies<items.nCandies) {
                        //add candies in the first rectangle
                        listModel1.setProperty(index,"countS",listModel1.get(index).countS+1)
                        //the curent number of candies increases
                        background.nCrtCandies ++
                        //on the last one, the candy image from top goes away (destroy)
                        if (background.nCrtCandies==items.nCandies) {
                            //items.acceptCandy = false
                            background.resetCandy()
                            candyWidget.element.opacity = 0.6
                        }
                        //show the basket if there is a rest
                        if (background.rest!=0 && background.basketShown()===false)
                            items.basketWidget.element.opacity = 1
                    }
                    else {
                        //items.acceptCandy = false
                        background.resetCandy()
                        candyWidget.element.opacity = 0.6
                    }
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
                    id: candy2
                    sourceSize.width: items.cellSize * 0.7
                    sourceSize.height: items.cellSize * 1.5
                    source: "resource/images/candy.svg"

                    property int lastx
                    property int lasty

                    MouseArea {
                        anchors.fill: parent

                        //enables dragging the candie after placed
                        drag.target: parent

                        onPressed: {
                            instruction.hide()
                            //set the initial position
                            candy2.lastx = candy2.x
                            candy2.lasty = candy2.y
                            dropChild.z++
                        }

                        onReleased:  {
                            dropChild.z--
                            for (var i=0;i<listModel1.count;i++) {
                                var c = repeater_drop_areas.itemAt(i)     //DropChild type
                                var e = drop_areas.mapToItem(background, c.x, c.y)
                                var d = candy2.parent.mapToItem(background, candy2.x, candy2.y)    //coordinates of "boy/girl rectangle" in background coordinates
                                var wid = items.leftWidget

                                if (c!==dropChild) {
                                    //check if the user wants to put a candy to another rectangle
                                    if (d.x>e.x && d.x<e.x+c.area.width && d.y>e.y+c.childImg.height && d.y<e.y+c.childImg.height+c.area.height) {
                                        //add the candy to the "i"th recthangle
                                        listModel1.setProperty(i,"countS",listModel1.get(i).countS+1)
                                        //remove the candy from current rectangle
                                        listModel1.setProperty(rect2.indexS,"countS",listModel1.get(rect2.indexS).countS-1);
                                    }
                                }

                                //check if the user wants to put back the candy to the leftWidget
                                if (d.x>0 && d.x<wid.width && d.y>0 && d.y<wid.height) {
                                    //restore the candy to the leftWidget
                                    background.nCrtCandies--
                                    candyWidget.element.opacity = 1
                                    items.candyWidget.canDrag = true
                                    //remove the candy from current rectangle
                                    listModel1.setProperty(rect2.indexS,"countS",listModel1.get(rect2.indexS).countS-1);
                                }
                            }

                            //restore the candy to its initial position
                            candy2.x = candy2.lastx
                            candy2.y = candy2.lasty
                        }

                        //when clicked, it will restore the candy
                        onClicked:  {
                            background.nCrtCandies--
                            candyWidget.element.opacity = 1
                            items.candyWidget.canDrag = true
                            listModel1.setProperty(rect2.indexS,"countS",listModel1.get(rect2.indexS).countS-1);
                        }
                    }
                }
            }
        }
    }
}
