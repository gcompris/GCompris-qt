/* gcompris - Sudoku.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import core 1.0

import "../../core"
import "sudoku.js" as Activity
import "."

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
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

        property bool isHorizontalLayout: layoutArea.width >= layoutArea.height

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
            focus = true
        }

        property int nbRegions

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
            property alias columns: sudoColumn.columns
            property alias rows: sudoColumn.rows
            property alias sudokuModel: sudokuModel
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
            onReloadClicked: Activity.initLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            z: 1002
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            z: 1003
            anchors.bottom: bar.top
            anchors.right: activityBackground.right
            anchors.margins: GCStyle.baseMargins
            onStop: Activity.incrementLevel()
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            Activity.onKeyPressed(event);
        }

        Item {
            id: layoutArea
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
                bottom: score.top
                margins: GCStyle.baseMargins
            }
        }

        SudokuListWidget {
            id: availablePieces
            inputBlocked: items.buttonsBlocked
        }

        ListModel {
            id: sudokuModel
        }

        Item {
            id: gridLayout
            anchors.bottom: layoutArea.bottom
            anchors.right: layoutArea.right
            states: [
                State {
                    name: "horizontalLayout"
                    when: activityBackground.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: layoutArea.top
                        anchors.left: availablePieces.right
                    }
                    PropertyChanges {
                        gridLayout {
                            anchors.leftMargin: GCStyle.baseMargins
                            anchors.topMargin: 0
                        }
                    }
                },
                State {
                    name: "verticalLayout"
                    when: !activityBackground.isHorizontalLayout
                    AnchorChanges {
                        target: gridLayout
                        anchors.top: availablePieces.bottom
                        anchors.left: layoutArea.left
                    }
                    PropertyChanges {
                        gridLayout {
                            anchors.leftMargin: 0
                            anchors.topMargin: GCStyle.baseMargins
                        }
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
            enabled: !items.buttonsBlocked
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
            property int regionLineSize: GCStyle.thickBorder

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
