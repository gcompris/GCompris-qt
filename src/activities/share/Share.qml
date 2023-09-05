/* GCompris - Share.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "share.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#abcdef"
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias instruction: instruction
            property int currentSubLevel: 0
            property int nbSubLevel
            property alias listModel: listModel
            property bool acceptCandy: false
            property alias girlWidget: girlWidget
            property alias boyWidget: boyWidget
            property alias candyWidget: candyWidget
            property alias basketWidget: basketWidget
            property alias leftWidget: leftWidget
            property int totalBoys
            property int totalGirls
            property int totalCandies
            property int totalChildren: totalBoys + totalGirls
            readonly property var levels: activity.datasetLoader.data
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.round(Math.min(background.width / 12, background.height / (11 + barHeightAddon)))
            property alias repeaterDropAreas: repeaterDropAreas
            property int maxNumberOfCandiesPerWidget: 6
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width >= background.height
        property int currentBoys: 0
        property int currentGirls: 0
        property int currentCandies: 0
        property int rest
        property int placedInGirls
        property int placedInBoys
        property bool easyMode: true
        property alias wrongMove: wrongMove
        property bool finished: false

        //returns true if the x and y is in the "dest" area
        function contains(x, y, dest) {
            return (x > dest.x && x < dest.x + dest.width &&
                    y > dest.y && y < dest.y + dest.height)
        }

        //stop the candy rotation
        function resetCandy() {
            items.acceptCandy = false;
            candyWidget.element.rotation = 0
        }

        //check if the answer is correct
        function check() {
            background.resetCandy()
            background.finished = true

            var ok = 0
            var okRest = 0

            if (listModel.count >= items.totalChildren) {
                for (var i = 0 ; i < listModel.count ; i++) {
                    if (listModel.get(i).nameS === "basket")
                        okRest = listModel.get(i).countS
                    else if (listModel.get(i).countS === Math.floor(items.totalCandies/items.totalChildren))
                        ok ++
                }

                //condition without rest
                if (rest == 0 && ok == items.totalChildren) {
                    bonus.good("flower")
                    return
                }
                //condition with rest
                else if (rest == okRest && ok == items.totalChildren) {
                    bonus.good("tux")
                    return
                }
            }

            //else => bad
            bonus.bad("flower", bonus.checkAnswer)
        }

        //center zone
        Rectangle {
            id: grid
            z: 4

            //map the coordinates from widgets to grid
            property var boy: leftWidget.mapFromItem(boyWidget, boyWidget.element.x, boyWidget.element.y)
            property var girl: leftWidget.mapFromItem(girlWidget, girlWidget.element.x, girlWidget.element.y)
            property var basket: leftWidget.mapFromItem(basketWidget, basketWidget.element.x, basketWidget.element.y)

            //show that the widget can be dropped here
            color: background.contains(boy.x, boy.y, grid) ||
                   background.contains(girl.x, girl.y, grid) ||
                   background.contains(basket.x, basket.y, grid) ? "#d5e6f7" : "transparent"

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
                // first hide the wrong move if visible, then show/hide instruction
                onClicked: wrongMove.visible ? wrongMove.visible = false :
                           (instruction.opacity === 0) ?
                               instruction.show() : instruction.hide()
            }

            ListModel {
                id: listModel
            }

            Flow {
                id: dropAreas
                spacing: 10

                width: parent.width
                height: parent.height

                Repeater {
                    id: repeaterDropAreas
                    model: listModel

                    DropChild {
                        id: rect2
                        //"nameS" from listModel
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
            border.color: "#DDD"
            color: "#373737"
            
            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.hide()
                enabled: instruction.opacity !== 0
            }

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
                topMargin: 10
                horizontalCenter: grid.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: background.vert ? regularSize : smallSize
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        //left widget, with girl/boy/candy/basket widgets in a grid
        Rectangle {
            id: leftWidget
            width: background.vert ?
                       items.cellSize * 2.04 : background.width
            height: background.vert ?
                        background.height : items.cellSize * 2.04
            color: "#5a9de0"
            border.color: "#3f81c4"
            border.width: 4
            z: 4

            //grid with ok button and images of a boy, a girl, a candy, a basket and the button to display the instructions
            Grid {
                id: view
                x: 10
                y: 10

                width: background.vert ? leftWidget.width : 3 * bar.height
                height: background.vert ? background.height - 2 * bar.height : bar.height
                spacing: 10
                columns: background.vert ? 1 : 6

                //ok button
                Image {
                    id: okButton
                    source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                    sourceSize.width: items.cellSize * 1.5 - view.x / 2
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: background.finished ? false : true
                        onPressed: okButton.opacity = 0.6
                        onReleased: okButton.opacity = 1
                        onClicked: background.check()
                    }
                }

                ChildWidget {
                    id: girlWidget
                    name: "girl"
                    total: items.totalGirls
                    visible: items.totalGirls !== 0
                    current: background.currentGirls
                    placedInChild: background.placedInGirls
                }

                ChildWidget {
                    id: boyWidget
                    name: "boy"
                    visible: items.totalBoys !== 0
                    total: items.totalBoys
                    current: background.currentBoys
                    placedInChild: background.placedInBoys
                }
                
                BasketWidget {
                    id: basketWidget
                }

                CandyWidget {
                    id: candyWidget
                    total: items.totalCandies
                    current: background.currentCandies
                    element.opacity: background.easyMode ? 1 : 0
                }

                Image {
                    id: showInstruction
                    source:"qrc:/gcompris/src/core/resource/bar_hint.svg"
                    sourceSize.width: items.cellSize * 1.5 - view.x / 2
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        enabled: background.finished ? false : true
                        onPressed: showInstruction.opacity = 0.6
                        onReleased: showInstruction.opacity = 1
                        onClicked: items.instruction.opacity == 0 ? items.instruction.show() : items.instruction.hide()
                    }
                }
            }
        }

        // show message warning for placing too many candies in one area
        Rectangle {
            id: wrongMove
            z: 5
            color: "orange"
            radius: width / height * 10
            visible: false

            width: grid.width
            height: grid.height / 3
            anchors.centerIn: grid

            MouseArea {
                anchors.fill: parent
                onClicked: parent.visible = false
            }
            GCText {
                id: wrongMoveText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: parent.width - 2 // -2 for margin
                height: parent.height
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                color: "#404040"
                text: qsTr("You can't put more than %1 pieces of candy in the same rectangle").arg(items.maxNumberOfCandiesPerWidget)
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    background.easyMode = (activityData["mode"] === "true");
                }
            }
            onStartActivity: {
                background.stop();
                background.start()
            }

            onClose: home()
        }

        //bar buttons
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reloadRandom()
            onActivityConfigClicked: {
                 displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
            }
            onStop: background.finished = false
        }

        Score {
            anchors {
                left: undefined
                right: leftWidget.right
                bottom: background.vert ? bar.top : leftWidget.bottom
                margins: 3 * ApplicationInfo.ratio
            }
            width: girlWidget.width
            height: background.vert ? (girlWidget.height * 0.8) : girlWidget.height
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }
    }

}
