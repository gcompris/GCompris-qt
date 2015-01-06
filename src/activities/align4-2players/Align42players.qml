/* GCompris - align4-2players.qml
 *
 * Copyright (C) 2014 Bharath M S
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"
import "align4-2players.js" as Activity

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
        sourceSize.width: parent.width
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
            property alias player1_score: player1_score.text
            property alias player2_score: player2_score.text
            property alias bar: bar
            property alias bonus: bonus
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property int cellSize: Math.min(background.width / (columns + 1),
                                            background.height / (rows + 3))
            property bool gameDone
            property int counter
        }

        onStart: { Activity.start(items, twoPlayer) }
        onStop: { Activity.stop() }

        ListModel {
            id: pieces
        }

        Grid {
            id: grid
            anchors.horizontalCenter: parent.horizontalCenter
            anchors {
                top: parent.top
                topMargin: items.cellSize + 5 * ApplicationInfo.ratio
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
                        border.color: "#FFFFFFFF"
                        border.width: 1 * ApplicationInfo.ratio
                        Piece {
                            anchors.fill: parent
                            state: stateTemp
                        }
                    }
                }
            }

            Piece {
                id: fallingPiece
                state: items.gameDone ? "invisible" : items.counter % 2 ? "2": "1"
                width: items.cellSize
                height: items.cellSize

                Behavior on x { PropertyAnimation { duration: 200 } }
            }

        }

        PropertyAnimation {
            id: drop
            target: fallingPiece
            properties: "y"
            duration: 1500
            onStopped: {
                dynamic.display()
                Activity.continueGame()
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: parent
            enabled: !drop.running && !items.gameDone
            hoverEnabled: !drop.running && !items.gameDone

            function display() {
                var coord = grid.mapFromItem(background, mouseX, mouseY)
                Activity.setPieceLocation(coord.x, coord.y)
            }

            onPositionChanged: items.dynamic.enabled ? display() : ''
            onClicked: {
                display()
                var coord = grid.mapFromItem(background, mouseX, mouseY)
                Activity.handleDrop(coord.x, coord.y)
            }
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.reset()
            }
        }

        Image {
            id: player1
            source: Activity.url + "score_1.svg"
            sourceSize.height: bar.height * 1.2
            anchors {
                bottom: bar.bottom
                bottomMargin: 10
                right: parent.right
                rightMargin: 2 * ApplicationInfo.ratio
            }

            GCText {
                id: player1_score
                anchors.verticalCenter: parent.verticalCenter
                x: parent.width / 2 + 5
                color: "white"
                font.pointSize: 24
            }
        }

        Image {
            id: player2
            source: Activity.url + "score_2.svg"
            sourceSize.height: bar.height * 1.2
            anchors {
                bottom: bar.bottom
                bottomMargin: 10
                right: player1.left
                rightMargin: 2 * ApplicationInfo.ratio
            }

            GCText {
                id: player2_score
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                x: parent.width / 2 + 5
                font.pointSize: 24
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
