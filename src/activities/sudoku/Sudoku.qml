/* gcompris - Sudoku.qml

 Copyright (C)
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
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "sudoku.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop

        source: "qrc:/gcompris/src/activities/sudoku/resource/background.jpg"

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            focus = true
        }

        property int nbRegions: 1;

        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias availablePiecesModel: availablePieces
            property alias grid: sudoColumn
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
            content: BarEnumContent { value: help | home | previous | next | reload }
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
            Component.onCompleted: win.connect(Activity.incrementLevel)
        }

        Score {
            id: score
            anchors.bottom: background.bottom
            anchors.right: background.right
        }

        SudokuListWidget {
            id: availablePieces
        }

        ListModel {
            id: sudokuModel
        }

        Grid {
            x: 100
            //spacing: 2

            id: sudoColumn
            width: Math.min(background.width, background.height-2*bar.height)
            height: width

            Repeater {
                id: repeater
                model: sudokuModel
                delegate: blueSquare

                Component {
                    id: blueSquare
//                    Rectangle {
//                        color: "#DDAAAAAA";
//                        width: items.cellSize
//                        height: items.cellSize
//                        border.color: "#FFFFFFFF"
//                        border.width: 1
                        SudokuCase {
                            x: (index%sudoColumn.columns)*width
                            y: Math.floor(index/sudoColumn.columns)*height
                            width: parent != null ? parent.width / sudoColumn.columns : 1
                            height: parent != null ? parent.height/ sudoColumn.columns : 1
                        }
//                    }
                }
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: sudoColumn

            onClicked: {
                var x = Math.floor(sudoColumn.rows * mouseX / sudoColumn.width);
                var y = Math.floor(sudoColumn.columns * mouseY / sudoColumn.height);
                Activity.clickOn(x, y)
            }
        }
    }
}
