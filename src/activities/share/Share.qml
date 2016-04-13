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

    //TODO 0: some ReferenceErrors while dragging the candies back from rectangles to widget panel
      //DropChild.qml line 139/161/...
    //TODO 1: when having many many rectangles, they should resize in order to fit the screen
      //now, if there are more than 5/6/7... they span out of the window
    //TODO 2: have some voices to tell the kids to drag the basket ("rest") and what it means

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
            property alias leftWidget: leftWidget
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
        property int rest: (items.nCandies - items.background.nCrtCandies ==
                            (items.nCandies - Math.floor(items.nCandies / items.nChildren) * items.nChildren)) ?
                               items.nCandies - items.background.nCrtCandies : 0


        onRestChanged: {
            //show message for rest if the rest is available and not already displayed on the board
            if (rest > 0 && basketShown() === false) {
                background.resetCandy()
                instruction.opacity = 1
                instruction.text = "now drag the basket in the center and place the remaining candies inside it"
            }
        }

        //returns true if the x and y is in the "dest" area
        function contains(x,y,dest) {
            return (x > dest.x && x < dest.x + dest.width &&
                    y > dest.y && y < dest.y + dest.height)
        }

        //stop the candy rotation
        function resetCandy() {
            items.acceptCandy = false;
            candyWidget.element.rotation = 0
        }

        //searches in the board for the basket; if it exists, returns true
        function basketShown() {
            for (var i=0; i<listModel1.count; i++) {
                if (repeater_drop_areas.itemAt(i).name === "basket" && background.rest != 0) {
                    return true
                }
            }
            return false
        }

        //check if the answer is correct
        function check() {
            var ok = 0
            var okRest = 0
            var rest = items.nCandies - Math.floor(items.nCandies/items.nChildren) * items.nChildren

            if (listModel1.count >= items.nChildren) {
                for (var i=0; i<listModel1.count; i++)
                    if (listModel1.get(i).nameS === "basket")
                        okRest = listModel1.get(i).countS
                    else if (listModel1.get(i).countS === Math.floor(items.nCandies/items.nChildren))
                        ok++

                //condition without rest
                if (rest == 0 && ok == items.nChildren) {
                    bonus.good("flower")
                    return
                }

                //condition with rest
                else if (rest == okRest && ok == items.nChildren) {
                    bonus.good("tux")
                    return
                }
            }

            //else => bad
            bonus.bad("flower")
        }

        //center zone
        Rectangle {
            id: grid

            //map the coordinates from widgets to grid
            property var boy: leftWidget.mapFromItem(boyWidget, boyWidget.element.x, boyWidget.element.y)
            property var girl: leftWidget.mapFromItem(girlWidget, girlWidget.element.x, girlWidget.element.y)
            property var basket: leftWidget.mapFromItem(basketWidget, basketWidget.element.x, basketWidget.element.y)

            //show that the widget can be dropped here
            color: background.contains(boy.x, boy.y, grid) ||
                   background.contains(girl.x, girl.y, grid) ||
                   background.contains(basket.x, basket.y, grid) ? "pink" : "transparent"

            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                left: background.vert ? leftWidget.right : parent.left
                topMargin: 20
                leftMargin: 20
            }

            width: background.vert ?
                       background.width - leftWidget.width - 40 : background.width - 40
            height: ApplicationSettings.isBarHidden ?
                        background.height : background.vert ?
                            background.height - (bar.height * 1.1) :
                            background.height - (bar.height * 1.1) - leftWidget.height

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

                Repeater {
                    id: repeater_drop_areas
                    model: listModel1

                    DropChild {
                        id: rect2
                        //"nameS" from listModel1
                        name: nameS
                    }
                }
            }
        }

        //instruction rectangle
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

        //instruction for playing the game
        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                topMargin: -10
                horizontalCenter: grid.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: background.vert ? regularSize : smallSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        //left widget, with girl/boy/candy/basket widgets in a grid
        Rectangle {
            id: leftWidget
            width: background.vert ?
                       items.cellSize * 1.74 : background.width
            height: background.vert ?
                        background.height : items.cellSize * 1.74
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

                //ok button
                Image {
                    id: okButton
                    source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                    sourceSize.width: items.cellSize * 1.5
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onPressed: okButton.opacity = 0.6
                        onReleased: okButton.opacity = 1
                        onClicked: background.check()
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

                    //swing animation for candies
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
                        opacity: 0
                        Behavior on opacity { PropertyAnimation { duration: 500 } }
                    }
                }
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
