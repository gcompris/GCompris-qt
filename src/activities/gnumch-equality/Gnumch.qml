import QtQuick 2.2
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

    GCAudio {
        id: moveSound
        source: "qrc:/gcompris/src/activities/gnumch-equality/resource/smudge.wav"
    }

    GCAudio {
        id: eatSound
        source: "qrc:/gcompris/src/activities/gnumch-equality/resource/eat.wav"
    }

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
                muncher.init()
            }
        }

        function nextLevel() {
            Activity.nextLevel()
            if (Activity._currentLevel == 7) {
                operator = " - "
            }

            if (Activity._currentLevel == 0) {
                operator = " + "
            }
            topPanel.goal = Activity.getGoal()
            monsters.destroyAll()
            Activity.fillAllGrid()
            life.opacity = 1
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
            Activity.start(modelCells, bar, bonus, type, operator)
            life.opacity = 1
            forceActiveFocus()
            operator = " + "
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
            Activity.stop()
        }

        onWidthChanged: muncher.updatePosition()

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
        Keys.onAsteriskPressed: {
            nextLevel()
        }

        Connections {
            target: warningRect.mArea
            onClicked: warningRect.hideWarning()
        }

        Rectangle {
            id: gridPart

            width: background.width - 180 * ApplicationInfo.ratio
            height: background.height / 7 * 6
            border.color: "black"
            border.width: 2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            radius: 5

            function isLevelDone() {
                for (var it = 0; it < modelCells.count; it++) {
                    if (Activity.isAnswerCorrect(it) && modelCells.get(it).show) {
                        console.log("the cell " + it + " is not clean")
                        return false
                    }
                }
                bonus.good("tux")
                return true
            }

            Muncher {
                id: muncher
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

            Timer {
                id: spawningMonsters

                interval: Activity.genTime()
                running: false
                repeat: true

                onTriggered: {
                    interval = Activity.genTime()
                    timerActivateWarn.start()
                    var comp = Qt.createComponent("qrc:/gcompris/src/activities/gnumch-equality/" + Activity.genMonster(
                                                      ) + ".qml")
                    if (comp.status === Component.Ready) {
                        var direction = Math.floor(Math.random() * 4)
                        var result = Activity.genPosition(direction,
                                                          grid.cellWidth,
                                                          grid.cellHeight)
                        var reggie = comp.createObject(monsters, {
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
            goal: Activity.getGoal()
        }

        Rectangle {
            id: muncherLife

            width: 120 * ApplicationInfo.ratio
            height: life.height
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10

            border.width: 2
            radius: 5

            Creature {
                id: life

                monsterType: "muncher"
                width: parent.width
                height: parent.width
                frames: 1
                frameW: 80
                widthRatio: 1.35
            }
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

        Bar {
            id: bar

            content: BarEnumContent {
                value: help | home
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
        }
    }
}
