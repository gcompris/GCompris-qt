/* GCompris - align4-2players.qml
 *
 * Copyright (C) 2014 Bharath M S <brat.197@gmail.com>
 *
 * Authors:
 *   Laurent Lacheny <laurent.lacheny@wanadoo.fr> (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

import "../../core"
import "align4.js" as Activity

import GCompris 1.0

ActivityBase {
    id: activity

    property bool twoPlayer: true

    onStart: focus = true
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
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias fallingPiece: fallingPiece
            property alias pieces: pieces
            property alias dynamic: dynamic
            property alias drop: drop
            property alias player1score: player1score
            property alias player2score: player2score
            property alias bar: bar
            property alias bonus: bonus
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property alias trigTuxMove: trigTuxMove
            property int cellSize: background.width < background.height ? (background.width / (columns + 3)) : (background.height / (rows + 4))
            property bool gameDone
            property int counter
        }

        onStart: { Activity.start(items, twoPlayer) }
        onStop: { Activity.stop() }

        Keys.onRightPressed: Activity.moveCurrentIndexRight();
        Keys.onLeftPressed: Activity.moveCurrentIndexLeft();
        Keys.onDownPressed: Activity.handleDrop(Activity.currentLocation);
        Keys.onSpacePressed: Activity.handleDrop(Activity.currentLocation);

        ListModel {
            id: pieces
        }

        // Tux move delay
        Timer {
            id: trigTuxMove
            repeat: false
            interval: 1500
            onTriggered: {
                Activity.doMove()
                items.player2score.endTurn()
                items.player1score.beginTurn()
            }
        }

        Grid {
            id: grid
            z: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            spacing: 5
            columns: 7
            rows: 6

            Repeater {
                id: repeater
                model: pieces
                delegate: blueSquare

                Component {
                    id: blueSquare
                    Rectangle {
                        color: "#DDAAAAAA";
                        width: items.cellSize
                        height: items.cellSize
                        radius: width / 2
                        border.color: "#FFFFFFFF"
                        border.width: 0
                        Piece {
                            anchors.fill: parent
                            state: stateTemp
                            sourceSize.width: items.cellSize
                        }
                    }
                }
            }

            Piece {
                id: fallingPiece
                state: items.gameDone ? "invisible" : items.counter % 2 ? "2": "1"
                sourceSize.width: items.cellSize

                Behavior on x { PropertyAnimation { duration: 200 } }
            }

        }

        PropertyAnimation {
            id: drop
            target: fallingPiece
            properties: "y"
            duration: 720
            onStarted: activity.audioEffects.play(Activity.url + 'slide.wav')
            onStopped: {
                dynamic.display()
                Activity.continueGame()
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: parent
            enabled: hoverEnabled
            hoverEnabled: (!drop.running && !items.gameDone && (items.counter % 2 == 0 || twoPlayer))

            property bool holdMode: true
            function display() {
                var coord = grid.mapFromItem(background, mouseX, mouseY)
                Activity.setPieceLocation(coord.x, coord.y)
            }

            onPositionChanged: items.dynamic.enabled ? display() : ''
            onPressed: holdMode = false
            onPressAndHold: holdMode = true
            onClicked: {
                display()
                if(!holdMode) {
                    var coord = grid.mapFromItem(background, mouseX, mouseY)
                    var column = Activity.whichColumn(coord.x, coord.y)
                    Activity.handleDrop(column)
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload | (twoPlayer ? 0 : level) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.reset()
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
        }

        ScoreItem {
            id: player1score
            z: 1
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            playerImageSource: Activity.url + "player_1.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
        }

        ScoreItem {
            id: player2score
            z: 1
            player: 2
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: Activity.url + "player_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
        }

        Bonus {
            id: bonus
        }
    }
}
