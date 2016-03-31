import QtQuick 2.1
import GCompris 1.0

import "../../core"


//drop area rectangle
Rectangle {
    id: dropChild
    width: items.cellSize * 3
    height: items.cellSize * 3 + items.cellSize * 1.5
    color: "transparent"

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

        text: listModel1.get(index).countS
    }

    Rectangle {
        id: area
        width: items.cellSize * 3
        height: items.cellSize * 3
        anchors.bottom: parent.bottom

        color: "#cfecf0"

        property var c: parent.mapToItem(background,area.x,area.y)
        property var d: candyWidget.mapToItem(background,candyWidget.element.x,candyWidget.element.y)

        opacity: d.x > c.x && d.y > c.y &&
                 d.x<c.x + area.width && d.y < c.y + area.height ? 0.5 : 1

        MouseArea {
            id: rect1MouseArea
            anchors.fill: parent

            onClicked: {
//                Debugging
//                print("c.x: ",area.c.x )
//                print("c.y: ",area.c.y )
//                print("d.x: ",area.d.x )
//                print("d.y: ",area.d.y )
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
                        //check answer
                        //drop_areas.check()
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

                    MouseArea {
                        anchors.fill: parent

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
