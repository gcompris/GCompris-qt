/* GCompris - chess.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "."
import "chess.js" as Activity

ActivityBase {
    id: activity

    property bool twoPlayers: false
    // difficultyByLevel means that at level 1 computer is bad better at last level
    property bool difficultyByLevel: true
    property variant fen: [
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"]
    ]

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + 'background.svg'
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int cellSize: Math.min(background.width / (8 + 1),
                                            background.height / (8 + 3))
            property variant fen: activity.fen
            property bool twoPlayer: activity.twoPlayers
            property bool difficultyByLevel: activity.difficultyByLevel
            property var positions
            property var pieces: pieces
            property var history
            property int from
            property bool blackTurn
            property bool gameOver
            property string message
            property alias trigComputerMove: trigComputerMove
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // TODO Imprement a vertical layout
        Grid {
            anchors {
                top: parent.top
                topMargin: items.cellSize / 2
                leftMargin: 10 * ApplicationInfo.ratio
            }
            columns: 3
            rows: 1
            width: background.width
            spacing: 10
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            Column {
                id: controls
                spacing: 10
                width: undo.width + (background.width * 0.9 - undo.width - chessboard.width) / 2

                GCText {
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: undo.width * 1.2
                    fontSize: smallSize
                    text: items.message
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }

                Button {
                    id: undo
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30 * ApplicationInfo.ratio
                    text: qsTr("Undo");
                    style: GCButtonStyle {}
                    onClicked: Activity.undo()
                    opacity: items.history.length > 0 ? 1 : 0
                    Behavior on opacity {
                        PropertyAnimation {
                            easing.type: Easing.InQuad
                            duration: 200
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30 * ApplicationInfo.ratio
                    text: qsTr("Swap");
                    style: GCButtonStyle {}
                    opacity: items.twoPlayer
                    onClicked: chessboard.swap()
                }
            }

            // The chessboard
            GridView {
                id: chessboard
                cellWidth: items.cellSize
                cellHeight: items.cellSize
                width: items.cellSize * 8
                height: items.cellSize * 8
                interactive: false
                keyNavigationWraps: true
                model: 64
                layoutDirection: Qt.RightToLeft
                delegate: square
                rotation: 180

                Component {
                    id: square
                    Rectangle {
                        color: index % 2 + (Math.floor(index / 8) % 2) == 1 ?
                                   "#FFFFFF99" : '#FF9999FF';
                        width: items.cellSize
                        height: items.cellSize
                    }
                }

                Behavior on rotation { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1400 } }

                function swap() {
                    if(chessboard.rotation == 180)
                        chessboard.rotation = 0
                    else
                        chessboard.rotation = 180
                }
            }
        }

        Repeater {
            id: pieces
            model: items.positions
            delegate: piece
            parent: chessboard

            Piece {
                id: piece
                sourceSize.width: items.cellSize
                width: items.cellSize - spacing
                height: items.cellSize - spacing
                source: img ? Activity.url + img + '.svg' : ''
                img: modelData.img
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                pos: modelData.pos
                newPos: modelData.pos
                rotation: - chessboard.rotation

                property int spacing: 6 * ApplicationInfo.ratio

                MouseArea {
                    anchors.fill: parent
                    enabled: !items.gameOver
                    onClicked: {
                        if(parent.isWhite == 1 && !items.blackTurn ||
                                parent.isWhite == 0 && items.blackTurn) {
                            items.from = parent.newPos
                            Activity.showPossibleMoves(items.from)
                        } else if(items.from != -1 && parent.acceptMove) {
                            Activity.moveTo(items.from, parent.newPos)
                        }
                    }
                }
            }

            function moveTo(from, to) {
                var fromPiece = getPieceAt(from)
                var toPiece = getPieceAt(to)
                toPiece.hide(from)
                fromPiece.pos = to
                fromPiece.newPos = to
            }

            function promotion(to) {
                var toPiece = getPieceAt(to)
                toPiece.promotion()
            }

            function getPieceAt(pos) {
                for(var i=0; i < pieces.count; i++) {
                    if(pieces.itemAt(i).newPos == pos)
                        return pieces.itemAt(i)
                }
                return(undefined)
            }
        }

        Timer {
            id: trigComputerMove
            repeat: false
            interval: 400
            onTriggered: Activity.randomMove()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | (items.twoPlayer ? 0 : level) |
                                             (items.twoPlayer ? 0 : reload) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
