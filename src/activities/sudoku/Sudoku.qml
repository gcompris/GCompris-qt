/* gcompris - Sudoku.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "sudoku.js" as Activity
import "."

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
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

        property int nbRegions

        QtObject {
            id: items
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property GCSfx audioEffects: activity.audioEffects
            property alias availablePiecesModel: availablePieces
            property alias columns: sudoColumn.columns
            property alias rows: sudoColumn.rows
            property alias sudokuModel: sudokuModel
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
            height: 48 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.right: background.right
            anchors.bottomMargin: background.baseMargins
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
            id: sudoColumn
            anchors.centerIn: gridLayout
            width:  Math.min(gridLayout.width, gridLayout.height)
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
            property int regionLineSize: Math.round(3 * ApplicationInfo.ratio)

            Repeater {
                id: regionRepeater
                model: nbRegions*nbRegions

                Rectangle {
                    z: 1001
                    color: "transparent"
                    x: index / nbRegions * sudoColumn.width
                    y: (index % nbRegions) * sudoColumn.width
                    width: nbRegions * sudoColumn.width / sudoColumn.columns
                    height: nbRegions * sudoColumn.height/ sudoColumn.columns
                    Rectangle {
                        id: topWall
                        color: "#2A2A2A"
                        height: regionGrid.regionLineSize
                        width: parent.width + regionGrid.regionLineSize
                        anchors.verticalCenter: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle {
                        id: leftWall
                        color: "#2A2A2A"
                        width: regionGrid.regionLineSize
                        height: parent.height + regionGrid.regionLineSize
                        anchors.horizontalCenter: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        id: rightWall
                        color: "#2A2A2A"
                        width: regionGrid.regionLineSize
                        height: parent.height + regionGrid.regionLineSize
                        anchors.horizontalCenter: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        id: bottomWall
                        color: "#2A2A2A"
                        height: regionGrid.regionLineSize
                        width: parent.width + regionGrid.regionLineSize
                        anchors.verticalCenter: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
