/* GCompris - Gnumch.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "gnumch-equality.js" as Activity

ActivityBase {
    id: activity

    property string type
    property string operator

    focus: true
    operator: " + "

    onStart: {}
    onStop: {}

    pageComponent: Rectangle {
        id: background

        function checkAnswer() {
            if (!muncher.movable)
                return

            muncher.eating = true
            // Set the cell invisible if it's the correct answer.
            if (Activity.isAnswerCorrect(muncher.index)) {
                modelCells.get(muncher.index).show = false
                var levelDone = gridPart.isLevelDone()
                if (levelDone) {
                    nextLevel()
                }
            } else {
                modelCells.get(muncher.index).show = false
                muncher.getCaught(muncher.index)
            }
        }

        function nextLevel() {
            Activity.nextLevel()
            if (Activity._currentLevel == 7) {
                operator = " - "
                Activity._operator = operator
            }

            if (Activity._currentLevel == 0) {
                operator = " + "
            }
            topPanel.goal = Activity.getGoal()
            monsters.destroyAll()
            Activity.fillAllGrid()
            topPanel.life.opacity = 1
            spawningMonsters.stop()
            timerActivateWarn.stop()
            if (Activity._currentLevel != 7) {
                spawningMonsters.start()
                timerActivateWarn.start()
            }
        }

        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: {
            Activity.start(modelCells, topPanel.bar, bonus, type, operator)
            topPanel.life.opacity = 1
            forceActiveFocus()
            operator = " + "
            Activity._operator = operator
            Activity.fillAllGrid()
            topPanel.goal = Activity.getGoal()
            if (Activity._currentLevel % 6 == 1) {
                spawningMonsters.restart()
            } else {
                spawningMonsters.stop()
                timerActivateWarn.stop()
            }
        }
        onStop: {
            monsters.destroyAll()
            muncher.init()
            Activity.stop()
        }

        Keys.onRightPressed: muncher.moveTo(0)
        Keys.onLeftPressed: muncher.moveTo(1)
        Keys.onDownPressed: muncher.moveTo(2)
        Keys.onUpPressed: muncher.moveTo(3)

        Keys.onSpacePressed: {
            checkAnswer()
        }

        Keys.onReturnPressed: {
            warningRect.hideWarning()
        }

        // Debug utility.
//        Keys.onAsteriskPressed: {
//            nextLevel()
//        }

        onWidthChanged: {
            positionTimer.restart()
        }

        Timer {
            id: positionTimer

            interval: 100

            onTriggered: {
                muncher.updatePosition()
                var children = monsters.children
                for (var it = 0; it < children.length; it++) {
                    children[it].updatePosition()
                }
            }
        }

        Connections {
            target: warningRect.mArea
            onClicked: warningRect.hideWarning()
        }

        Rectangle {
            id: gridPart

            width: background.width
            height: background.height / 7 * 6
            border.color: "black"
            border.width: 2
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: topPanel.top
            radius: 5

            function isLevelDone() {
                for (var it = 0; it < modelCells.count; it++) {
                    if (Activity.isAnswerCorrect(it) && modelCells.get(it).show) {
                        return false
                    }
                }
                bonus.good("gnu")
                return true
            }

            MultiPointTouchArea {
                anchors.fill: parent
                touchPoints: [ TouchPoint { id: point1 } ]
                property real startX
                property real startY
                // Workaround to avoid having 2 times the onReleased event
                property bool started

                onPressed: {
                    startX = point1.x
                    startY = point1.y
                    started = true
                }

                onReleased: {
                    if(!started)
                        return false
                    var moveX = point1.x - startX
                    var moveY = point1.y - startY
                    // Find the direction with the most move
                    if(Math.abs(moveX) * ApplicationInfo.ratio > 10 &&
                            Math.abs(moveX) > Math.abs(moveY)) {
                        if(moveX > 10 * ApplicationInfo.ratio)
                            muncher.moveTo(0)
                        else if(moveX < -10 * ApplicationInfo.ratio)
                            muncher.moveTo(1)
                        else
                            background.checkAnswer()
                    } else if(Math.abs(moveY) * ApplicationInfo.ratio > 10 &&
                              Math.abs(moveX) < Math.abs(moveY)) {
                        if(moveY > 10 * ApplicationInfo.ratio)
                            muncher.moveTo(2)
                        else if(moveY < -10 * ApplicationInfo.ratio)
                            muncher.moveTo(3)
                        else
                            background.checkAnswer()
                    } else {
                        // No move, just a tap or mouse click
                        if(point1.x > muncher.x + muncher.width)
                            muncher.moveTo(0)
                        else if(point1.x < muncher.x)
                            muncher.moveTo(1)
                        else if(point1.y < muncher.y)
                            muncher.moveTo(3)
                        else if(point1.y > muncher.y + muncher.height)
                            muncher.moveTo(2)
                        else
                            background.checkAnswer()
                    }
                    started = false
                }
            }

            Muncher {
                id: muncher
                audioEffects: activity.audioEffects
            }

            Item {
                id: monsters

                function setMovable(movable) {
                    var children = monsters.children
                    for (var it = 0; it < children.length; it++) {
                        children[it].movable = movable
                    }
                }

                function destroyAll() {
                    var children = monsters.children
                    for (var it = 0; it < children.length; it++) {
                        children[it].destroy()
                    }
                }

                function isThereAMonster(position) {
                    var children = monsters.children
                    for (var it = 0; it < children.length; it++) {
                        if (children[it].index == position) {
                            children[it].eating = true
                            return true
                        }
                    }
                    return false
                }

                function checkOtherMonster(position) {
                    var children = monsters.children
                    var count = 0
                    for (var it = 0; it < children.length; it++) {
                        if (children[it].index == position
                                && !children[it].movingOn) {
                            count++
                            if (count > 1) {
                                children[it].opacity = 0
                            }
                        }
                    }
                }
            }

            // Show an hint to show that can move by swiping anywhere
            Image {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 12
                }
                source: "qrc:/gcompris/src/core/resource/arrows_move.svg"
                sourceSize.width: 140
                opacity: topPanel.bar.level == 1 && ApplicationInfo.isMobile ? 0.8 : 0
            }

            Timer {
                id: spawningMonsters

                interval: Activity.genTime()
                running: false
                repeat: true

                onTriggered: {
                    interval = Activity.genTime()
                    timerActivateWarn.start()
                    var comp = Qt.createComponent("qrc:/gcompris/src/activities/gnumch-equality/" +
                                                  Activity.genMonster(
                                                      ) + ".qml")
                    if (comp.status === Component.Ready) {
                        var direction = Math.floor(Math.random() * 4)
                        var result = Activity.genPosition(direction,
                                                          grid.cellWidth,
                                                          grid.cellHeight)
                        var reggie = comp.createObject(monsters, {
                                                           audioEffects: activity.audioEffects,
                                                           direction: direction,
                                                           player: muncher,
                                                           index: result[0],
                                                           x: result[1],
                                                           y: result[2]
                                                       })
                        reggie.opacity = 1
                    }
                }
            }

            Timer {
                id: timerActivateWarn

                interval: spawningMonsters.interval - 2000
                running: spawningMonsters.running

                onTriggered: {
                    warnMonsters.opacity = 1
                }
            }

            GridView {
                id: grid

                anchors.fill: parent
                cellHeight: (parent.height - 2) / 6
                cellWidth: (parent.width - 2) / 6
                interactive: false
                focus: false

                model: modelCells
                delegate: gridDelegate.delegate
            }

            CellDelegate {
                id: gridDelegate
            }

            ListModel {
                id: modelCells

                function regenCell(position) {
                    if (type == "equality" || type == "inequality") {
                        var terms
                        if (operator == " + ") {
                            terms = Activity.splitPlusNumber(
                                        Activity.genNumber())
                        } else {
                            terms = Activity.splitMinusNumber(
                                    Activity.genNumber())
                        }
                        modelCells.setProperty(position, "number1", terms[0])
                        modelCells.setProperty(position, "number2", terms[1])
                    } else if (type == "multiples") {
                        modelCells.setProperty(position, "number1", Activity.genMultiple())
                    } else if (type == "factors") {
                        modelCells.setProperty(position, "number1", Activity.genFactor())
                    }

                    modelCells.setProperty(position, "show", true)
                    gridPart.isLevelDone()
                }
            }
        }

        TopPanel {
            id: topPanel
            goal: Activity.getGoal() ? Activity.getGoal() : 0
        }

        WarnMonster {
            id: warnMonsters
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Warning {
            id: warningRect
        }

        Bonus {
            id: bonus
        }
    }
}
