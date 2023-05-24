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

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
            focus = true
        }

        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
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
            height: background.height - availablePieces.height - 1.5 * bar.height
            anchors.bottom: bar.top
            anchors.right: background.right
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
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

        Grid {
            //z: 100
            anchors {
                left: availablePieces.right
                top: parent.top
                topMargin: 2 * ApplicationInfo.ratio
            }

            id: calcudokuColumn
            width:  Math.min(background.width - availablePieces.width -
                             availablePieces.anchors.leftMargin,
                             background.height - 2 * bar.height)
            height: width

            Repeater {
                id: repeater
                model: calcudokuModel
                delegate: blueSquare

                Component {
                    id: blueSquare
                    CalcudokuCase {
                        x: (index % calcudokuColumn.columns) * width
                        y: Math.floor(index / calcudokuColumn.columns) * height
                        width: parent != null ? parent.width / calcudokuColumn.columns : 1
                        height: parent != null ? parent.height / calcudokuColumn.columns : 1
                        gridIndex: index
                        isInitial: initial
                        operator: operatorValue
                        result: resultValue
                        text: textValue
                        state: mState
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
