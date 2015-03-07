/* GCompris - TicTacToe.qml
 *
 * Copyright (C) 2014 Pulkit Gupta
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
			property alias player1_score: player1_score.text
            property alias player2_score: player2_score.text
			property alias pieces: pieces
			property alias createPiece: createPiece
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
			property alias magnify: magnify
			property alias demagnify: demagnify
			property alias instructionTxt: instructionTxt
			property alias playButton: playButton
			property bool gameDone
            property int counter
            property int playSecond
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items, twoPlayer) }
        onStop: { Activity.stop() }

		Item {
            id: instruction
            z: 99
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.9
            property alias text: instructionTxt.text
	    
            GCText {
                id: instructionTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
				}
				fontSize: largeSize
				color: "white"
				style: Text.Outline
				styleColor: "black"
				horizontalAlignment: Text.AlignHCenter
				width: parent.width
				wrapMode: TextEdit.WordWrap
				z: 2
			}

			Rectangle {
				anchors.fill: instructionTxt
				z: 1
				opacity: 0.8
				radius: 10
				border.width: 2
				border.color: "black"
				gradient: Gradient {
					GradientStop { position: 0.0; color: "#000" }
					GradientStop { position: 0.9; color: "#666" }
					GradientStop { position: 1.0; color: "#AAA" }
				}
			}
        }

		Image {
			id: board
			source: Activity.url + "board.svg"
			fillMode: Image.PreserveAspectFit
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
							gradient: Gradient {
								GradientStop { position: 0.0; color: "lightsteelblue" }
								GradientStop { position: 1.0; color: "#7B68EE" }
							}
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
								enabled: !magnify.running && !items.gameDone
								hoverEnabled: !magnify.running && !items.gameDone
								width: parent.width
								height: parent.height
								onEntered: {border.color = "orange"}
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
			onStopped: {
			Activity.changeText()
			Activity.continueGame()
			}
	    }
	    
	    Item {
            id: playButton
            z: 99
            anchors {
                right: parent.right
                rightMargin: 5
                verticalCenter: background.verticalCenter
            }
            width: parent.width * 0.2
            property alias text: buttonTxt.text
	    
            GCText {
                id: buttonTxt
                anchors {
                    verticalCenter: parent.verticalCenter
				}
				fontSize: largeSize
				color: "white"
				style: Text.Outline
				styleColor: "black"
				horizontalAlignment: Text.AlignHCenter
				width: parent.width
				wrapMode: TextEdit.WordWrap
				z: 2
			}

			Rectangle {
				id: button
				anchors.fill: buttonTxt
				z: 1
				opacity: 0.8
				radius: 10
				border.width: 5
				border.color: "black"
				state: "first"
				gradient: Gradient {
					GradientStop { position: 0.0; color: "#98868A" }
					GradientStop { position: 0.9; color: "#FA0D3C" }
					GradientStop { position: 1.0; color: "#FF97AC" }
				}
				states: [
					State {
						name: "first"
						PropertyChanges {
							target: buttonTxt
							text: "Play Second"
						}
					},
					State {
						name: "second"
						PropertyChanges {
							target: buttonTxt
							text: "Play First"
						}
					}
				]
				MouseArea {
					id: buttonArea
					hoverEnabled: true
					width: parent.width
					height: parent.height
					onEntered: {parent.border.color = "#158B19"}
					onExited: {parent.border.color = "black"} 
					onClicked: {
						if ( button.state == "first") {
							button.state = "second"
							Activity.changePlayToSecond()
						}
						else {
							button.state = "first"
							Activity.changePlayToFirst()
						}
						
					}
				}
			}
			
        }
     
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
            onHomeClicked: activity.home()
			onReloadClicked: {
                Activity.reset()
            }
        }

		Image {
            id: player2
            source: Activity.url + "score_2.svg"
            sourceSize.height: bar.height * 1.1
            anchors {
                bottom: bar.bottom
                bottomMargin: 10
                right: parent.right
                rightMargin: 2 * ApplicationInfo.ratio
            }

            GCText {
                id: player2_score
                anchors.verticalCenter: parent.verticalCenter
                x: parent.width*0.70
                color: "white"
                fontSize: largeSize
            }
        }

        Image {
            id: player1
            source: Activity.url + "score_1.svg"
            sourceSize.height: bar.height * 1.1
            anchors {
                bottom: bar.bottom
                bottomMargin: 10
                right: player2.left
                rightMargin: 2 * ApplicationInfo.ratio
            }

            GCText {
                id: player1_score
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                x: parent.width*0.70
                fontSize: largeSize
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
