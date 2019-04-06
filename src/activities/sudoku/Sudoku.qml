/* gcompris - Sudoku.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
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
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
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
        }
        onStart: Activity.start(items)

        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
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
            anchors.bottom: background.bottom
            anchors.right: background.right
        }

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
