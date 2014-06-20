/* GCompris - align4-2players.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
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

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
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
            property alias piece1: piece1
            property alias pieces: pieces
            property alias dynamic: dynamic
            property alias drop: drop
            property alias line: line
            property alias player1: player1
            property alias player2: player2
            property alias player1_score: player1_score
            property alias player2_score: player2_score
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        ListModel {
            id: pieces
        }

        Image {
            id: player1
            source: Activity.url + "score_1.svg"
            sourceSize.height: background.height * 0.12
            x: background.width * 0.05
            y: background.height * 0.3

            Text {
                id: player1_score
                text: "0"
                x: parent.width / 2
                y: - parent.height / 10
                color: "white"
                font.pointSize: parent.height * 0.85
            }
        }

        Image {
            id: player2
            source: Activity.url + "score_2.svg"
            sourceSize.height: background.height * 0.12
            x: background.width * 0.05
            y: background.height * 0.6

            Text {
                id: player2_score
                text: "0"
                color: "white"
                x: parent.width / 2
                y: - parent.height / 10
                font.pointSize: parent.height * 0.85
            }
        }

        Rectangle {
            id: board
            width: parent.width * 0.625
            height: parent.height * 0.835
            color: "transparent"
            x: parent.width * 0.175
            y: parent.height * 0.1

            GridView {
                id: grid
                anchors.fill: parent
                anchors.leftMargin: background.width * 0.075 / 7
                anchors.topMargin: background.height * 0.116 / 6
                model: pieces

                Component {
                    id: blueSquare
                    Rectangle {
                        color: "grey";
                        width: background.width * 0.075;
                        height: background.height * 0.116
                        Piece {
                            state: stateTemp
                            back: background
                        }
                    }
                }

                cellWidth: background.width * 0.075 + background.width * 0.075 / 6
                cellHeight: background.height * 0.116 + background.height * 0.116 / 6
                delegate: blueSquare
            }
        }

        Piece {
            id: piece1
            x: background.width * 0.4505
            y: - background.height * 0.019
            state: Activity.counter % 2? "red": "green"
            back: background
        }

        PropertyAnimation {
            id: drop
            target: piece1
            properties: "y"
            duration: 1500
            onStopped: {
                Activity.continueGame()
            }
        }

        MouseArea {
            id: dynamic
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                Activity.setPieceLocation(mouseX, mouseY)
            }
            onClicked: {
                if(mouseX > background.width * 0.188 & mouseX < background.width * 0.8005) {
                    if(mouseY > background.height * 0.1 & mouseY < background.height * 0.935) {
                        dynamic.hoverEnabled = false
                        Activity.handleDrop(mouseX, mouseY)
                    }
                }
            }
        }

        Rectangle {
            id: line
            opacity: 0.0
            color: "red"
            transformOrigin: Item.TopLeft
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
