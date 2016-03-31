/* GCompris - share.qml
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "share.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    //TODO 1: when having many many rectangles, they should resize in order to fit the screen
               //now, if there are more than 5/6/7... they span out of the window
    //TODO 2: have some voices to tell the kids to drag the basket ("rest") and what it means
    //TODO 3: change the "instruction" text to say something helpful for children eg. "now press ok"
               //"now drag the basket to the board" etc.

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffb3"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias instruction: instruction
            property int currentSubLevel: 0
            property int nbSubLevel
            property alias listModel1: listModel1
            property bool acceptCandy: false
            property alias dataset: dataset
            property alias girlWidget: girlWidget
            property alias boyWidget: boyWidget
            property alias candyWidget: candyWidget
            property alias basketWidget: basketWidget

            property int nBoys
            property int nGirls
            property int nCandies
            property int nChildren: nBoys + nGirls

            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.min(background.width / 11 , background.height / (9 + barHeightAddon))

        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width > background.height
        property int nCrtBoys: 0
        property int nCrtGirls: 0
        property int nCrtCandies: 0
        property int rest: (items.nCandies - background.nCrtCandies == (items.nCandies-Math.floor(items.nCandies/items.nChildren) * items.nChildren)) ?
                               items.nCandies - background.nCrtCandies : 0

        onRestChanged: {
            //TODO 3 - it changes every time i drop a candy
            background.resetCandy()
            instruction.opacity = 1
            instruction.text = "now drag the basket in the center and place the remaining candies inside it"
        }

        function contains(x,y,dest,offsetX,offsetY) {
            return (x+offsetX>dest.x && x<dest.x+dest.width && y+offsetY>dest.y && y<dest.y+dest.height)
        }

        function resetCandy() {
            items.acceptCandy = false;
            candyWidget.element.rotation = 0
        }

        //center zone
        Rectangle {
            id: grid

            color: background.contains(boyWidget.element.x,boyWidget.element.y,grid,grid.offsetX,grid.offsetY) ||
                   background.contains(girlWidget.element.x,girlWidget.element.y,grid,grid.offsetX,grid.offsetY) ||
                   background.contains(basketWidget.element.x,basketWidget.element.y,grid,grid.offsetX2,grid.offsetY2) ? "pink" : "transparent"

            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                left: background.vert ? leftWidget.right : parent.left
                topMargin: 20
                leftMargin: 20
            }

            width: background.vert ?
                       background.width - leftWidget.width - 40 : background.width - 40
            height: ApplicationSettings.isBarHidden ?
                        background.height :
                        background.vert ?
                            background.height - (bar.height * 1.1) :
                            background.height - (bar.height * 1.1) - leftWidget.height

            //offset variables (used because of the positioning of the boy, girl, candy and basket in the left panel)
            property var offsetX: background.vert ? boyWidget.width : 4 * boyWidget.width
            property var offsetY: background.vert ? 4 * boyWidget.height : boyWidget.height

            property var offsetX2: background.vert ? boyWidget.width : 6 * boyWidget.width
            property var offsetY2: background.vert ? 6 * boyWidget.height : boyWidget.height

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: (instruction.opacity === 0) ?
                               instruction.show() : instruction.hide()
            }

            ListModel {
                id: listModel1
            }

            Flow {
                id: drop_areas
                spacing: 10

                width: parent.width
                height: parent.height

                function check() {
                    var ok = 0
                    var rest = items.nCandies - Math.floor(items.nCandies/items.nChildren) * items.nChildren
                    var ok2 = 0

                    if (listModel1.count >= items.nChildren) {
                        for (var i=0;i<listModel1.count;i++) {
                            if (listModel1.get(i).countS===Math.floor(items.nCandies/items.nChildren))
                                ok++
                            if (listModel1.get(i).nameS==="basket")
                                ok2 = listModel1.get(i).countS
                        }

                        //condition without rest
                        if (rest==0 && ok==items.nChildren)
                            bonus.good("flower")
                        //condition with rest
                        else if (rest==ok2 && ok==items.nChildren)
                            bonus.good("flower")
                        else
                            bonus.bad("flower")
                    }
                    else
                            bonus.bad("flower")
                }

                Repeater {
                    id: repeater_drop_areas
                    model: listModel1

                    DropChild {
                        id: rect2
                        name: nameS
                    }
                }
            }
        }

        Rectangle {
            id: instruction
            anchors.fill: instructionTxt
            opacity: 0.8
            radius: 10
            border.width: 2
            z: 10
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function show() {
                if(text)
                    opacity = 1
            }
            function hide() {
                opacity = 0
            }
        }

        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                topMargin: -10
                horizontalCenter: grid.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        //left side, with the images
        Rectangle {
            id: leftWidget
            width: background.vert ?
                       items.cellSize * 1.74 :
                       background.width
            height: background.vert ?
                        background.height :
                        items.cellSize * 1.74
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4

            //grid with ok button and images of a boy, a girl, a candy and a basket
            Grid {
                id: view
                x: 10
                y: 10

                width: background.vert ? leftWidget.width : 3 * bar.height
                height: background.vert ? background.height - 2 * bar.height : bar.height

                spacing: 10

                columns: background.vert ? 1 : 5

                Image {
                    id: ok
                    source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                    sourceSize.width: items.cellSize * 1.5
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onPressed: ok.opacity = 0.6
                        onReleased: ok.opacity = 1
                        onClicked: drop_areas.check()
                    }
                }

                Widget {
                    id: girlWidget
                    src: "resource/images/girl.svg"
                    name: "girl"
                    n: items.nGirls
                    nCrt: background.nCrtGirls
                }

                Widget {
                    id: boyWidget
                    src: "resource/images/boy.svg"
                    name: "boy"
                    n: items.nBoys
                    nCrt: background.nCrtBoys
                }

                Widget {
                    id: candyWidget
                    src: "resource/images/candy.svg"
                    name: "candy"
                    n: items.nCandies
                    nCrt: background.nCrtCandies

                    SequentialAnimation {
                        id: anim
                        running: items.acceptCandy ? true : false
                        loops: Animation.Infinite
                        NumberAnimation {
                            target: candyWidget.element
                            property: "rotation"
                            from: -10; to: 10
                            duration: 400 + Math.floor(Math.random() * 400)
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: candyWidget.element
                            property: "rotation"
                            from: 10; to: -10
                            duration: 400 + Math.floor(Math.random() * 400)
                            easing.type: Easing.InOutQuad
                        }
                    }

                }

                Widget {
                    id: basketWidget
                    src: "resource/images/basket.svg"
                    name: "basket"
                    element {
                        opacity: (background.rest!==0) ? 1 : 0
                        Behavior on opacity { PropertyAnimation { duration: 500 } }
                    }
                }

                //TODO - when draging candies and dropping them on top of rectangles, they should be
                    //automatically added to the respective rectangle (the below piece of code does not work)
                /*
                function acceptDrop(x,y) {
                    print("x: ",x)
                    for (var i=0;i<listModel1.count;i++) {
                        print("primul: ",repeater_drop_areas.itemAt(i).area.width)
                        if ((x>repeater_drop_areas.itemAt(i).area.x  && x<repeater_drop_areas.itemAt(i).area.x+repeater_drop_areas.itemAt(i).area.width) &&
                                (y>repeater_drop_areas.itemAt(i).area.y  && y<repeater_drop_areas.itemAt(i).area.y+repeater_drop_areas.itemAt(i).area.height)) {
                            print("i: ",i)
                            return i
                        }
                    }
                    return -1
                }
                */
            }
        }


        //bar buttons
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
                loose.connect(Activity.initLevel);
            }

        }

        Score {
            anchors {
                bottom: parent.bottom
                bottomMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }
    }
}
