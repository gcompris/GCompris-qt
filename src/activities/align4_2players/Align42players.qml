/* GCompris - Align42players.qml
 *
 * SPDX-FileCopyrightText: 2014 Bharath M S <brat.197@gmail.com>
 *
 * Authors:
 *   Laurent Lacheny <laurent.lacheny@wanadoo.fr> (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

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
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property bool horizontalLayout: layoutArea1.width >  layoutArea1.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int baseMargins: 10 * ApplicationInfo.ratio
            property int smallMargins: 5 * ApplicationInfo.ratio
            property alias fallingPiece: fallingPiece
            property alias pieces: pieces
            property alias dynamic: dynamic
            property alias drop: drop
            property alias player1score: player1score
            property alias player2score: player2score
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property alias trigTuxMove: trigTuxMove
            property int cellSize: background.horizontalLayout ? layoutArea1.height / (grid.rows + 1) - smallMargins :
                    Math.min(layoutArea2.width / grid.columns, layoutArea2.height / (grid.rows + 1)) - smallMargins
            property bool gameDone: false
            property int counter
            property int nextPlayerStart: 1
        }

        onStart: { Activity.start(items, twoPlayer) }
        onStop: { Activity.stop() }

        Keys.onPressed: (event) => {
            if(drop.running || bonus.isPlaying || (items.counter % 2 != 0 && !twoPlayer))
                return
            if(items.gameDone && !bonus.isPlaying)
                Activity.reset();
            if(event.key === Qt.Key_Right)
                Activity.moveCurrentIndexRight();
            else if(event.key === Qt.Key_Left)
                Activity.moveCurrentIndexLeft();
            else if(event.key === Qt.Key_Down || event.key === Qt.Key_Space)
                Activity.handleDrop(Activity.currentLocation);
        }

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

        Item {
            id: layoutArea1
            width: background.width - 4 * items.baseMargins - 2.8 * player1score.width
            anchors.top: background.top
            anchors.bottom: background.bottom
            anchors.topMargin: player1score.height * 0.5
            anchors.bottomMargin: bar.height * 1.2
            anchors.horizontalCenter: background.horizontalCenter
        }

        Item {
            id: layoutArea2
            anchors {
                fill: parent
                bottomMargin: bar.height * 1.2
                topMargin: player1score.height * 1.4 + 2 * items.baseMargins
                leftMargin: items.baseMargins
                rightMargin: items.baseMargins

            }
        }

        Item {
            id: gridContainer
            z: 2
            width: items.cellSize * grid.columns + 6 * items.smallMargins
            height: items.cellSize * grid.rows + 5 * items.smallMargins
            anchors.verticalCenterOffset: items.cellSize * 0.5
            states: [
                State {
                    name: "isHorizontalLayout"
                    when: background.horizontalLayout
                    AnchorChanges {
                        target: gridContainer
                        anchors.verticalCenter: layoutArea1.verticalCenter
                        anchors.horizontalCenter: layoutArea1.horizontalCenter
                    }
                },
                State {
                    name: "isVerticalLayout"
                    when: !background.horizontalLayout
                    AnchorChanges {
                        target: gridContainer
                        anchors.verticalCenter: layoutArea2.verticalCenter
                        anchors.horizontalCenter: layoutArea2.horizontalCenter
                    }
                }
            ]

            Piece {
                id: fallingPiece
                z: 100
                state: items.counter % 2 ? "2": "1"
                sourceSize.width: items.cellSize

                Behavior on x { PropertyAnimation { duration: 200 } }
            }

            Grid {
                id: grid
                spacing: items.smallMargins
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
            level: items.currentLevel + 1
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
                topMargin: items.baseMargins
                left: background.left
                leftMargin: items.baseMargins
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
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
                topMargin: items.baseMargins
                right: background.right
                rightMargin: items.baseMargins
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
        }

        Bonus {
            id: bonus
        }
    }
}
