/* GCompris - Calcudoku.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "calcudoku.js" as Activity
import "."

ActivityBase {
    id: activity
    focus: true

    onStart: {focus=true}
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias canEnterSound: canEnterSound
            property alias cantEnterSound: cantEnterSound
            property alias completeSound: completeSound
            property alias deleteSound: deleteSound
            property alias availablePiecesModel: availablePieces
            property alias columns: calcudokuColumn.columns
            property alias rows: calcudokuColumn.rows
            property alias calcudokuModel: calcudokuModel
            readonly property var levels: activity.datasets
            property bool buttonsBlocked: false
        }
        onStart: Activity.start(items)

        onStop: { Activity.stop() }

        GCSoundEffect {
            id: canEnterSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        GCSoundEffect {
            id: cantEnterSound
            source: "qrc:/gcompris/src/core/resource/sounds/darken.wav"
        }

        GCSoundEffect {
            id: completeSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: deleteSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

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
                activityBackground.stop()
                activityBackground.start()
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
            onReloadClicked: {
                if(!items.buttonsBlocked)
                    Activity.reinitLevel()
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors.bottom: bar.top
            anchors.right: activityBackground.right
            anchors.bottomMargin: GCStyle.baseMargins
            onStop: Activity.incrementLevel()
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            Activity.onKeyPressed(event);
        }

        CalcudokuListWidget {
            id: availablePieces
            inputBlocked: items.buttonsBlocked
        }

        ListModel {
            id: calcudokuModel
        }

        Item {
            id: gridLayout
            anchors.margins: GCStyle.baseMargins
            anchors.bottom: score.top
            anchors.right: activityBackground.right
            states: [
                State {
                    name: "horizontalLayout"
                    when: activityBackground.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: activityBackground.top
                        anchors.left: availablePieces.right
                    }
                },
                State {
                    name: "verticalLayout"
                    when: !activityBackground.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: availablePieces.bottom
                        anchors.left: activityBackground.left
                    }
                }
            ]
        }

        Grid {
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
            enabled: !items.buttonsBlocked
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
