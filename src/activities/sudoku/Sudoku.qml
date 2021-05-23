/* gcompris - Sudoku.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "sudoku.js" as Activity
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

        property int nbRegions

        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property GCSfx audioEffects: activity.audioEffects
            property alias availablePiecesModel: availablePieces
            property alias columns: sudoColumn.columns
            property alias rows: sudoColumn.rows
            property alias sudokuModel: sudokuModel
            property var levels: activity.datasetLoader.data
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
            onReloadClicked: Activity.initLevel()
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

        SudokuListWidget {
            id: availablePieces
            audioEffects: activity.audioEffects
        }

        ListModel {
            id: sudokuModel
        }

        Grid {
            z: 100
            anchors {
                left: availablePieces.right
                top: parent.top
                topMargin: 2 * ApplicationInfo.ratio
            }

            id: sudoColumn
            width:  Math.min(background.width - availablePieces.width -
                             availablePieces.anchors.leftMargin,
                             background.height - 2 * bar.height)
            height: width

            Repeater {
                id: repeater
                model: sudokuModel
                delegate: blueSquare

                Component {
                    id: blueSquare
                    SudokuCase {
                        x: (index%sudoColumn.columns)*width
                        y: Math.floor(index/sudoColumn.columns)*height
                        width: parent != null ? parent.width / sudoColumn.columns : 1
                        height: parent != null ? parent.height/ sudoColumn.columns : 1
                        gridIndex: index
                        isInitial: initial
                        text: textValue
                        state: mState
                    }
                }
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: sudoColumn
            enabled: !bonus.isPlaying
            hoverEnabled: true

            property int previousHoveredCase: -1
            onPositionChanged: {
                var x = Math.floor(sudoColumn.rows * mouseX / (sudoColumn.width+1));
                var y = Math.floor(sudoColumn.columns * mouseY / (sudoColumn.height+1));
                var id = x + y * sudoColumn.rows;

                // Only color if we can modify the case
                if(sudokuModel.get(id).mState === "default")
                    sudokuModel.get(id).mState = "hovered";

                // Restore previous case if different from the new one
                if(previousHoveredCase != id) {
                    if(previousHoveredCase != -1 && sudokuModel.get(previousHoveredCase).mState === "hovered")
                        sudokuModel.get(previousHoveredCase).mState = "default"
                    previousHoveredCase = id
                }
            }
            onExited: {
                if(previousHoveredCase != -1 && sudokuModel.get(previousHoveredCase).mState === "hovered")
                    sudokuModel.get(previousHoveredCase).mState = "default"
                previousHoveredCase = -1
            }

            onClicked: {
                var x = Math.floor(sudoColumn.rows * mouseX / sudoColumn.width);
                var y = Math.floor(sudoColumn.columns * mouseY / sudoColumn.height);
                Activity.clickOn(x, y)
            }
        }

        Grid {
            z: 1001
            id: regionGrid
            columns: rows
            rows: nbRegions
            visible: nbRegions > 1

            anchors.fill: sudoColumn

            Repeater {
                id: regionRepeater
                model: nbRegions*nbRegions

                Rectangle {
                    z: 1001
                    color: "transparent"
                    border.color: "orange"
                    border.width: 4
                    x: index / nbRegions * sudoColumn.width
                    y: (index % nbRegions) * sudoColumn.width
                    width: nbRegions * sudoColumn.width / sudoColumn.columns
                    height: nbRegions * sudoColumn.height/ sudoColumn.columns
                }
            }
        }
    }
}
