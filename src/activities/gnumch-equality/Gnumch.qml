/* GCompris - Gnumch.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

import "../../core"
import "gnumch-equality.js" as Activity

ActivityBase {
    id: activity

    property string type: ""
    property bool useMultipleDataset: false

    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property var levels: activity.datasets
            property alias modelCells: modelCells
            property alias bonus: bonus
            property int currentLevel: activity.currentLevel
            property alias eatSound: eatSound
            property alias smudgeSound: smudgeSound
            property int goal: 1
            property bool life: true
            property bool withMonsters: false
            property alias muncher: muncher
            property alias gridPart: gridPart
            property alias warning: warning
            property alias monsters: monsters
            property alias spawningMonsters: spawningMonsters
            property alias timerActivateWarn: timerActivateWarn
        }

        onStart: {
            Activity.start(items, activity.type, activity.useMultipleDataset);
        }
        onStop: {
            Activity.stop()
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onRightPressed: muncher.moveTo(muncher.moveRight)
        Keys.onLeftPressed: muncher.moveTo(muncher.moveLeft)
        Keys.onDownPressed: muncher.moveTo(muncher.moveDown)
        Keys.onUpPressed: muncher.moveTo(muncher.moveUp)

        Keys.onSpacePressed: {
            Activity.checkAnswer()
        }

        Keys.onReturnPressed: {
            Activity.hideWarning()
        }

        GCSoundEffect {
            id: eatSound
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/eat.wav"
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: gridPart
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2

            function isLevelDone(): bool {
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
                        if(moveX > GCStyle.baseMargins)
                            muncher.moveTo(muncher.moveRight)
                        else if(moveX < -GCStyle.baseMargins)
                            muncher.moveTo(muncher.moveLeft)
                        else
                            Activity.checkAnswer()
                    } else if(Math.abs(moveY) * ApplicationInfo.ratio > 10 &&
                              Math.abs(moveX) < Math.abs(moveY)) {
                        if(moveY > GCStyle.baseMargins)
                            muncher.moveTo(muncher.moveDown)
                        else if(moveY < -GCStyle.baseMargins)
                            muncher.moveTo(muncher.moveUp)
                        else
                            Activity.checkAnswer()
                    } else {
                        // No move, just a tap or mouse click
                        if(point1.x > muncher.x + muncher.width)
                            muncher.moveTo(muncher.moveRight)
                        else if(point1.x < muncher.x)
                            muncher.moveTo(muncher.moveLeft)
                        else if(point1.y < muncher.y)
                            muncher.moveTo(muncher.moveUp)
                        else if(point1.y > muncher.y + muncher.height)
                            muncher.moveTo(muncher.moveDown)
                        else
                            Activity.checkAnswer()
                    }
                    started = false
                }
            }

            GridView {
                id: gridBackground
                anchors.top: parent.top
                anchors.right: parent.right
                width: cellWidth * 6
                height: cellHeight * 6
                cellHeight: parent.height / 7 // add one line for the bottom panel
                cellWidth: parent.width / 6
                interactive: false
                focus: false
                model: modelCells
                delegate: Rectangle {
                    width: gridBackground.cellWidth
                    height: gridBackground.cellHeight
                    border.color: GCStyle.darkBorder
                    border.width: GCStyle.thinnestBorder
                    radius: GCStyle.tinyMargins
                    color: "#80ffffff"
                }
            }

            Muncher {
                id: muncher
                life: items.life
                width: gridBackground.cellWidth
                height: gridBackground.cellHeight
                smudgeSound: items.smudgeSound
            }

            Item {
                id: monsters
            }

            Timer {
                id: spawningMonsters
                interval: Activity.genTime()
                running: false
                repeat: true
                onTriggered: {
                    interval = Activity.genTime()
                    timerActivateWarn.restart()
                    var comp = Qt.createComponent("qrc:/gcompris/src/activities/gnumch-equality/" +
                                Activity.genMonster() + ".qml")
                    if (comp.status === Component.Ready) {
                        var direction = Math.floor(Math.random() * 4)
                        var result = Activity.genPosition(direction)
                        var monster = comp.createObject(monsters, {
                                                           direction: direction,
                                                           index: result,
                                                           width: gridBackground.cellWidth,
                                                           height: gridBackground.cellHeight,
                                                           muncher: muncher,
                                                           opacity: 1
                                                       })
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
                id: gridNumbers
                anchors.top: parent.top
                anchors.right: parent.right
                width: gridBackground.width
                height: gridBackground.height
                cellHeight: gridBackground.cellHeight
                cellWidth: gridBackground.cellWidth
                interactive: false
                focus: false
                model: modelCells
                delegate: CellDelegate {
                    operator: Activity.operator
                    width: gridBackground.cellWidth
                    height: gridBackground.cellHeight
                }
            }

            ListModel {
                id: modelCells

                function regenCell(position: int) {
                    if (type === "equality" || type === "inequality") {
                        var terms
                        if (Activity.operator === " + ") {
                            terms = Activity.splitPlusNumber(
                                        Activity.genNumber())
                        } else if (Activity.operator === " - ") {
                            terms = Activity.splitMinusNumber(
                                        Activity.genNumber())
                        } else if (Activity.operator === " * ") {
                            terms = Activity.splitMultiplicationNumber(
                                        Activity.genNumber())
                        } else if (Activity.operator === " / ") {
                            terms = Activity.splitDivisionNumber(
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

            TopPanel {
                id: topPanel
                anchors.top: gridBackground.bottom
                anchors.topMargin: GCStyle.halfMargins
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.min(gridBackground.cellHeight - GCStyle.halfMargins, GCStyle.bigButtonHeight)
                activityType: activity.type
                goal: items.goal
                life: items.life
            }

            Warning {
                id: warning
                property int index: -1
                firstNumber: index == -1 ? -1 : modelCells.get(index).number1
                secondNumber: index == -1 ? -1 : modelCells.get(index).number2
                anchors.centerIn: gridBackground
                type: activity.type
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent {
                value: (activity.useMultipleDataset) ? (help | home | level | activityConfig) : (help | home | level)
            }
            onHelpClicked: activity.displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: activity.displayDialog(dialogActivityConfig)
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                activity.home()
            }

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        WarnMonster {
            id: warnMonsters
            z: 1000
            y: gridPart.y + topPanel.y + topPanel.height + GCStyle.halfMargins
            anchors.horizontalCenter: parent.horizontalCenter
            width: gridPart.width
            height: Math.min(topPanel.height, bar.height)
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel);
                loose.connect(Activity.initLevel)
            }
        }
    }
}
