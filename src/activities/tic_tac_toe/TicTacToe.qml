/* GCompris - TicTacToe.qml
 *
 * Copyright (C) 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
import "tic_tac_toe.js" as Activity

import GCompris 1.0

ActivityBase {
    id: activity

    property bool twoPlayer: false
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
            
            property alias player1: player1
            property alias player1_score: player1_score.text
            property alias player1turn: player1turn
            property alias player1shrink: player1shrink
            property alias player1image: player1image
            property alias changeScalePlayer1: changeScalePlayer1
            property alias rotateKonqi: rotateKonqi
            
            property alias player2: player2
            property alias player2_score: player2_score.text
            property alias player2turn: player2turn
            property alias player2shrink: player2shrink
            property alias player2image: player2image
            property alias changeScalePlayer2: changeScalePlayer2
            property alias rotateTux: rotateTux
            
            property alias pieces: pieces
            property alias createPiece: createPiece
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property alias magnify: magnify
            property alias demagnify: demagnify
            property bool gameDone
            property int counter
            property int playSecond
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: Activity.start(items, twoPlayer)
        onStop: Activity.stop()

        Image {
            id: board
            source: Activity.url + "board.svg"
            sourceSize.width: 4 * Math.min(background.width / 4 , background.height / 6)
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            ListModel {
                id: pieces
            }

            Grid {
                id: grid
                rows: 3
                columns: 3
                anchors {
                fill: parent
                left: parent.left
                leftMargin: parent.width/18
                top: parent.top
                topMargin: board.width/20
                }
                spacing: board.width/16
                Repeater {
                    id: repeater
                    model: pieces
                    delegate: blueSquare
                    Component {
                        id: blueSquare
                        Rectangle {
                            width: (grid.height/4)*1.1
                            height: (grid.height/4)*1.1
                            border.color: "transparent"
                            border.width: 5
                            radius: 10
                            state: "INITIAL"
                            color: "#c7ecfb"
                            Piece {
                                anchors.fill: parent
                                state: stateTemp
                            }
                            states: [
                                State {
                                    name: "INITIAL"
                                    PropertyChanges {
                                        target: area
                                        visible: true
                                    }
                                },
                                State {
                                    name: "DONE"
                                    PropertyChanges {
                                        target: area;
                                        visible: false;
                                    }
                                }
                            ]
                            MouseArea {
                                id: area
                                enabled: !magnify.running && !items.gameDone && !player1turn.running && !player2turn.running
                                hoverEnabled: !magnify.running && !items.gameDone && !player1turn.running && !player2turn.running
                                width: parent.width
                                height: parent.height
                                onEntered: {border.color = "#62db53"}
                                onExited: {border.color = "transparent"} 
                                onClicked: {Activity.handleCreate(parent)}
                            }
                        }
                    }
                }
                Piece {
                    id: createPiece
                    state: (items.counter + items.playSecond) % 2 ? "2": "1"
                    width: (grid.height/4)*1.1
                    height: (grid.height/4)*1.1
                    opacity: 0
                }
            }

        }

        PropertyAnimation {
            id: demagnify
            target: createPiece
            properties: "scale"
            from: 1.0
            to: 0.0
            duration: 1
        }
        PropertyAnimation {
            id: magnify
            target: createPiece
            properties: "scale"
            from: 0.0
            to: 1.0
            duration: 1000
            onStarted: activity.audioEffects.play(Activity.url + 'click.wav')
            onStopped: {Activity.continueGame()}
        }
        
        PropertyAnimation {
            id: player1turn
            target: changeScalePlayer1
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                player1.state = "first"
                player2.state = "second"
                rotateTux.stop()
                player2image.rotation = 0
                rotateKonqi.start()
                player2shrink.start()
            }
            onStopped: {Activity.shouldComputerPlay()}
        }
           
        PropertyAnimation {
            id: player1shrink
            target: changeScalePlayer1
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }
         
        PropertyAnimation {
            id: player2turn
            target: changeScalePlayer2
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                player1.state = "second"
                player2.state = "first"
                rotateKonqi.stop()
                player1image.rotation = 0
                rotateTux.start()
                player1shrink.start()
            }
            onStopped: {Activity.shouldComputerPlay()}
        }
        
        PropertyAnimation {
            id: player2shrink
            target: changeScalePlayer2
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }
        
        SequentialAnimation {
            id: rotateKonqi
            loops: Animation.Infinite
            NumberAnimation {
                target: player1image
                property: "rotation"
                from: -30; to: 30
                duration: 750
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: player1image
                property: "rotation"
                from: 30; to: -30
                duration: 750
                easing.type: Easing.InOutQuad 
            }
        }
        
        SequentialAnimation {
            id: rotateTux
            loops: Animation.Infinite
            NumberAnimation {
                target: player2image
                property: "rotation"
                from: -30; to: 30
                duration: 750
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: player2image
                property: "rotation"
                from: 30; to: -30
                duration: 750
                easing.type: Easing.InOutQuad 
            }
        }

        Rectangle {
            id: player2
            height: Math.min(background.height/7,Math.min(background.width/7,bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            radius: 5
            state: "second"
            
            Image {
                id: player2background
                source: Activity.url + "score_2.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent
                
                Image {
                    id: player2image
                    source: Activity.url + "TuxCircle.svg"
                    sourceSize.height: parent.height*0.8
                    x: parent.width*0.06
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                GCText {
                    id: player2_score
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width*0.65
                    color: "#2a2a2a"
                    fontSize: largeSize
                }
            }
            
            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "TuxCircle.svg"
                    }
                    PropertyChanges {
                        target: player2
                        color: "#49bbf0"
                    }
                },
                State {
                    name: "second"
                    PropertyChanges {
                        target: player2
                        color: "transparent"
                    }
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "TuxCircle.svg"
                    }
                },
                State {
                    name: "win"
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "win.svg"
                    }
                    PropertyChanges {
                        target: player2
                        color: "#f7ec5d"
                    }
                }
            ]
            
            transform: Scale {
                id: changeScalePlayer2
                property real scale: 1
                origin.x: player2.width
                origin.y: 0
                xScale: scale
                yScale: scale
            }
        }

        Rectangle {
            id: player1
            height: Math.min(background.height/7,Math.min(background.width/7,bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            radius: 5
            state: "second"
            
            Image {
                id: player1background
                source: Activity.url + "score_1.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 0.5
                    
                Image {
                    id: player1image
                    source: Activity.url + "KonqiCross.svg"
                    sourceSize.height: parent.height*0.8
                    x: parent.width*0.06
                    anchors.verticalCenter: parent.verticalCenter
                }

                GCText {
                    id: player1_score
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#2a2a2a"
                    x: parent.width*0.65
                    fontSize: largeSize
                }
            }
            
            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player1image
                        source: Activity.url + "KonqiCross.svg"
                    }
                    PropertyChanges {
                        target: player1
                        color: "#f07c49"
                    }
                },
                State {
                    name: "second"
                    PropertyChanges {
                        target: player1
                        color: "transparent"
                    }
                    PropertyChanges {
                            target: player1image
                            source: Activity.url + "KonqiCross.svg"
                    }
                },
                State {
                    name: "win"
                    PropertyChanges {
                        target: player1image
                        source: Activity.url + "win.svg"
                    }
                    PropertyChanges {
                        target: player1
                        color: "#f7ec5d"
                    }
                }
            ]
            
            transform: Scale {
                id: changeScalePlayer1
                property real scale: 1
                xScale: scale
                yScale: scale
            }
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: (twoPlayer ? (help | home | reload) : (help | home | level | reload))}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.reset()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
