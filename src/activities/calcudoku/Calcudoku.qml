/* GCompris - Calcudoku.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "calcudoku.js" as Activity
import "."

ActivityBase {
    id: activity
    focus: true

    onStart: {focus=true}
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        property double baseMargins: 10 * ApplicationInfo.ratio
        property double activityLayoutHeight: height - bar.height * 1.5
        property bool isHorizontalLayout: width >= activityLayoutHeight

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
            focus = true
        }

        QtObject {
            id: items
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property GCSfx audioEffects: activity.audioEffects
            property alias availablePiecesModel: availablePieces
            property alias columns: calcudokuColumn.columns
            property alias rows: calcudokuColumn.rows
            property alias calcudokuModel: calcudokuModel
            readonly property var levels: activity.datasetLoader.data
        }
        onStart: Activity.start(items)

        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onReloadClicked: Activity.reinitLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            z: 1002
            Component.onCompleted: win.connect(Activity.incrementLevel)
        }

        Score {
            id: score
            z: 1003
            height: 48 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.right: background.right
            anchors.bottomMargin: background.baseMargins
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            Activity.onKeyPressed(event);
        }

        CalcudokuListWidget {
            id: availablePieces
            audioEffects: activity.audioEffects
        }

        ListModel {
            id: calcudokuModel
        }

        Item {
            id: gridLayout
            anchors.margins: background.baseMargins
            anchors.bottom: score.top
            anchors.right: background.right
            states: [
                State {
                    name: "horizontalLayout"
                    when: background.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: background.top
                        anchors.left: availablePieces.right
                    }
                },
                State {
                    name: "verticalLayout"
                    when: !background.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: availablePieces.bottom
                        anchors.left: background.left
                    }
                }
            ]
        }

        Grid {
            z: 100
            id: calcudokuColumn
            x: Math.round(gridLayout.x + gridLayout.width * 0.5 - width * 0.5)
            y: Math.round(gridLayout.y + gridLayout.height * 0.5 - height * 0.5)
            width:  Math.min(gridLayout.width, gridLayout.height)
            height: width
            property int squareSize: 2 * Math.round(width / calcudokuColumn.columns / 2)

            Repeater {
                model: calcudokuModel
                delegate: blueSquare

                Component {
                    id: blueSquare
                    CalcudokuCase {
                        x: Math.floor((index % calcudokuColumn.columns) * width)
                        y: Math.floor((index / calcudokuColumn.columns) * height)
                        width: parent != null ? calcudokuColumn.squareSize : 1
                        height: width
                        gridIndex: index
                        isInitial: initial
                        operator: operatorValue
                        result: resultValue
                        text: textValue
                        state: mState
                    }
                }
            }
        }

        Grid {
            z: 100
            id: calcudokuCages
            x: calcudokuColumn.x
            y: calcudokuColumn.y
            width:  calcudokuColumn.width
            height: calcudokuColumn.height
            columns: calcudokuColumn.columns
            rows: calcudokuColumn.rows

            Repeater {
                model: calcudokuModel
                delegate: cageWalls

                Component {
                    id: cageWalls
                    CalcudokuCage {
                        x: Math.floor((index % calcudokuColumn.columns) * width)
                        y: Math.floor((index / calcudokuColumn.columns) * height)
                        width: parent != null ? calcudokuColumn.squareSize : 1
                        height: width
                        topWallVisible: topWall
                        leftWallVisible: leftWall
                        rightWallVisible: rightWall
                        bottomWallVisible: bottomWall
                    }
                }
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: calcudokuColumn
            enabled: !bonus.isPlaying
            hoverEnabled: true

            property int previousHoveredCase: -1
            onPositionChanged: {
                var x = Math.floor(calcudokuColumn.rows * mouseX / (calcudokuColumn.width+1));
                var y = Math.floor(calcudokuColumn.columns * mouseY / (calcudokuColumn.height+1));
                var id = x + y * calcudokuColumn.rows;

                // Only color if we can modify the case
                if(calcudokuModel.get(id).mState === "default")
                    calcudokuModel.get(id).mState = "hovered";

                // Restore previous case if different from the new one
                if(previousHoveredCase != id) {
                    if(previousHoveredCase != -1 && calcudokuModel.get(previousHoveredCase).mState === "hovered")
                        calcudokuModel.get(previousHoveredCase).mState = "default"
                    previousHoveredCase = id
                }
            }
            onExited: {
                if(previousHoveredCase != -1 && calcudokuModel.get(previousHoveredCase).mState === "hovered")
                    calcudokuModel.get(previousHoveredCase).mState = "default"
                previousHoveredCase = -1
            }

            onClicked: {
                var x = Math.floor(calcudokuColumn.rows * mouseX / calcudokuColumn.width);
                var y = Math.floor(calcudokuColumn.columns * mouseY / calcudokuColumn.height);
                Activity.clickOn(x, y)
            }
        }
    }
}
