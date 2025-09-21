/* GCompris - Share.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu29@gmail.com> (initial version)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"
import "share.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: GCStyle.lightBlueBg
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias instructionPanel: instructionPanel
            property alias instruction: instructionPanel.textItem
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
            readonly property var levels: activity.datasets
            property alias repeaterDropAreas: repeaterDropAreas
            property int maxNumberOfCandiesPerWidget: 6
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool verticalBar: activityBackground.width >= activityBackground.height
        property int barItemSize: 1
         // 8 items for max 6 children + basket + empty area for score
        property int gridItemSize: Core.fitItems(grid.width + GCStyle.baseMargins, grid.height + GCStyle.baseMargins, 8) - GCStyle.baseMargins
        property int currentBoys: 0
        property int currentGirls: 0
        property int currentCandies: 0
        property int rest
        property int placedInGirls
        property int placedInBoys
        property bool easyMode: true
        property alias wrongMove: wrongMove

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
            activityBackground.resetCandy()
            items.buttonsBlocked = true

            var ok = 0
            var okRest = 0

            if (listModel.count >= items.totalChildren) {
                for (var i = 0 ; i < listModel.count ; i++) {
                    if (listModel.get(i).nameS === "basket")
                        okRest = listModel.get(i).countS
                    else if (listModel.get(i).countS === Math.floor(items.totalCandies/items.totalChildren))
                        ok ++
                }

                //condition without or with rest
                if ((rest == 0 && ok == items.totalChildren) || (rest == okRest && ok == items.totalChildren))  {
                    score.currentSubLevel++
                    score.playWinAnimation()
                    goodAnswerSound.play()
                    return
                }
            }

            //else => bad
            errorRectangle.startAnimation()
            badAnswerSound.play()
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        states: [
            State {
                when: activityBackground.verticalBar
                PropertyChanges {
                    leftWidget {
                        width: activityBackground.barItemSize + 2 * GCStyle.baseMargins
                        height: activityBackground.height
                    }
                    barGrid {
                        columns: 1
                    }
                    activityBackground {
                        barItemSize: Math.min(GCStyle.bigButtonHeight, (activityBackground.height - bar.height * 1.2 - GCStyle.baseMargins) / 6 - GCStyle.baseMargins)
                    }
                    grid {
                        x: leftWidget.width + GCStyle.baseMargins
                        y: GCStyle.baseMargins
                        width: activityBackground.width - leftWidget.width - GCStyle.baseMargins * 2
                        height: activityBackground.height - bar.height * 1.2 - GCStyle.baseMargins * 2
                    }
                }
            },
            State {
                when: !activityBackground.verticalBar
                PropertyChanges {
                    leftWidget {
                        width: activityBackground.width
                        height: activityBackground.barItemSize + 2 * GCStyle.baseMargins
                    }
                    barGrid {
                        columns: 6
                    }
                    activityBackground {
                        barItemSize: Math.min(GCStyle.bigButtonHeight, (activityBackground.width - GCStyle.baseMargins) / 6 - GCStyle.baseMargins)
                    }
                    grid {
                        x: GCStyle.baseMargins
                        y: leftWidget.height + GCStyle.baseMargins
                        width: activityBackground.width - GCStyle.baseMargins * 2
                        height: activityBackground.height - bar.height * 1.2 - leftWidget.height - GCStyle.baseMargins * 2
                    }
                }
            }
        ]

        //center zone
        Rectangle {
            id: grid
            z: 4

            //map the coordinates from widgets to grid
            property var boy: leftWidget.mapFromItem(boyWidget, boyWidget.element.x, boyWidget.element.y)
            property var girl: leftWidget.mapFromItem(girlWidget, girlWidget.element.x, girlWidget.element.y)
            property var basket: leftWidget.mapFromItem(basketWidget, basketWidget.element.x, basketWidget.element.y)

            //show that the widget can be dropped here
            color: activityBackground.contains(boy.x, boy.y, grid) ||
                   activityBackground.contains(girl.x, girl.y, grid) ||
                   activityBackground.contains(basket.x, basket.y, grid) ? "#d5e6f7" : "transparent"

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                enabled: !items.buttonsBlocked
                // first hide the wrong move if visible, then show/hide instruction
                onClicked: wrongMove.visible ? wrongMove.visible = false :
                           (instructionPanel.opacity === 0) ?
                               instructionPanel.show() : instructionPanel.hide()
            }

            ListModel {
                id: listModel
            }

            Flow {
                id: dropAreas
                spacing: GCStyle.baseMargins
                width: parent.width
                height: parent.height

                Repeater {
                    id: repeaterDropAreas
                    model: listModel

                    DropChild {
                        id: rect2
                        //"nameS" from listModel
                        width: activityBackground.gridItemSize
                        height: activityBackground.gridItemSize
                        name: nameS
                    }
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            z: 20
            anchors.fill: grid
            imageSize: GCStyle.bigButtonHeight
            function releaseControls() { items.buttonsBlocked = false; }
        }

        //instruction for playing the game
        GCTextPanel {
            id: instructionPanel
            z: 5
            panelWidth: Math.min(grid.width - 2 * GCStyle.baseMargins, 600 * ApplicationInfo.ratio)
            panelHeight: grid.height * 0.4
            hideIfEmpty: true
            anchors.horizontalCenter: grid.horizontalCenter
            anchors.top: grid.top
            anchors.topMargin: GCStyle.baseMargins

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function show() {
                if(textItem.text)
                    opacity = 1
            }
            function hide() {
                opacity = 0
            }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instructionPanel.hide()
                enabled: instructionPanel.opacity !== 0 && !items.buttonsBlocked
            }
        }

        //left widget, with girl/boy/candy/basket widgets in a grid
        Rectangle {
            id: leftWidget
            color: "#5a9de0"
            border.color: "#3f81c4"
            border.width: GCStyle.thinBorder
            z: 4

            //grid with ok button and images of a boy, a girl, a candy, a basket and the button to display the instructions
            Grid {
                id: barGrid
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                spacing: GCStyle.baseMargins

                //ok button
                Image {
                    id: okButton
                    source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                    sourceSize.width: activityBackground.barItemSize
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: !items.buttonsBlocked
                        onPressed: okButton.opacity = 0.6
                        onReleased: okButton.opacity = 1
                        onClicked: activityBackground.check()
                    }
                }

                ChildWidget {
                    id: girlWidget
                    name: "girl"
                    width: activityBackground.barItemSize
                    total: items.totalGirls
                    visible: items.totalGirls !== 0
                    current: activityBackground.currentGirls
                    placedInChild: activityBackground.placedInGirls
                }

                ChildWidget {
                    id: boyWidget
                    name: "boy"
                    width: activityBackground.barItemSize
                    visible: items.totalBoys !== 0
                    total: items.totalBoys
                    current: activityBackground.currentBoys
                    placedInChild: activityBackground.placedInBoys
                }
                
                BasketWidget {
                    id: basketWidget
                    width: activityBackground.barItemSize
                }

                CandyWidget {
                    id: candyWidget
                    width: activityBackground.barItemSize
                    total: items.totalCandies
                    current: activityBackground.currentCandies
                    element.opacity: activityBackground.easyMode ? 1 : 0
                }

                Image {
                    id: showInstruction
                    source:"qrc:/gcompris/src/core/resource/bar_hint.svg"
                    sourceSize.width: activityBackground.barItemSize
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        enabled: !items.buttonsBlocked
                        onPressed: showInstruction.opacity = 0.6
                        onReleased: showInstruction.opacity = 1
                        onClicked: instructionPanel.opacity == 0 ? instructionPanel.show() : instructionPanel.hide()
                    }
                }
            }
        }

        // show message warning for placing too many candies in one area
        GCTextPanel {
            id: wrongMove
            z: 5
            panelWidth: grid.width - 2 * GCStyle.baseMargins
            panelHeight: grid.height / 3
            anchors.centerIn: grid
            color: "orange"
            textItem.color: "#404040"
            textItem.text: qsTr("You can't put more than %1 pieces of candy in the same rectangle").arg(items.maxNumberOfCandiesPerWidget)
            visible: false

            MouseArea {
                anchors.fill: parent
                onClicked: parent.visible = false && !items.buttonsBlocked
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    activityBackground.easyMode = (activityData["mode"] === "true");
                }
            }
            onStartActivity: {
                activityBackground.stop();
                activityBackground.start()
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
                win.connect(Activity.nextLevel)
            }
        }

        Score {
            id: score
            anchors {
                left: undefined
                right: parent.right
                bottom: bar.top
                rightMargin: GCStyle.baseMargins
                bottomMargin: bar.height * 0.2
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: 0
            onStop: Activity.nextSubLevel()
        }
    }

}
