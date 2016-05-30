/* GCompris - NineMenMorris.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
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
import "nine_men_morris.js" as Activity

ActivityBase {
    id: activity

	property bool twoPlayer: false
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
            property alias board: board
            
            property alias tutorialImage: tutorialImage.source
            property alias tutorialTxt: tutorialTxt.text
            property alias tutNum: tutorialTxt.tutNum
            property bool isTutorial
            
            property alias player1: player1
            property alias firstInitial: firstInitial
            property alias player1background: player1background.visible
            property alias player1_score: player1_score.text
            property alias player1turn: player1turn
            property alias player1shrink: player1shrink
            property alias player1image: player1image
            property alias changeScalePlayer1: changeScalePlayer1
            property alias rotateKonqi: rotateKonqi
            
            property alias player2: player2
            property alias secondInitial: secondInitial
            property alias player2background: player2background.visible
            property alias player2_score: player2_score.text
            property alias player2turn: player2turn
            property alias player2shrink: player2shrink
            property alias player2image: player2image
            property alias changeScalePlayer2: changeScalePlayer2
            property alias rotateTux: rotateTux
            
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
            sourceSize.width: 3 * Math.min(background.width / 4 , background.height / 6)
            visible: !items.isTutorial
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            
            MouseArea {
				id: area
				enabled: true
				hoverEnabled: true
				width: parent.width
				height: parent.height
				onClicked: {Activity.handleCreate(parent)}
			}
        }
        
        Rectangle {
			id: firstInitial
			anchors {
				left: board.right
				leftMargin: 0.05 * parent.width
				top: board.top
				topMargin: 15
			}
			width: Math.min(0.9*parent.width - board.x - board.width, 0.65*board.width)
			height: board.height/3
			visible: !items.isTutorial
			opacity: 0.8
			radius: 10
			border.width: 2
			border.color: "black"
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#6b4723" }
				GradientStop { position: 0.9; color: "#996633" }
				GradientStop { position: 1.0; color: "#AAA" }
			}
			
			Image {
				id: initialWhite
				source: Activity.url + "white_piece.svg"
				sourceSize.height: Math.min(parent.height*0.8,parent.width*0.4)
				x: parent.width*0.06
				anchors.verticalCenter: parent.verticalCenter
			}
			
			GCText {
				id: whiteNumber
				anchors {
					verticalCenter: parent.verticalCenter
					left: initialWhite.right
					leftMargin: 7
				}
				fontSize: initialWhite.height/2
				color: "white"
				style: Text.Outline
				styleColor: "black"
				horizontalAlignment: Text.AlignHCenter
				property int count: 9
				text: "X%1".arg(count)
			}
				
		}
		
		Rectangle {
			id: secondInitial
			anchors {
				left: board.right
				leftMargin: 0.05 * parent.width
				bottom: board.bottom
				bottomMargin: 15
			}
			width: Math.min(0.9*parent.width - board.x - board.width, 0.65*board.width)
			height: board.height/3
			visible: !items.isTutorial
			opacity: 0.8
			radius: 10
			border.width: 2
			border.color: "black"
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#6b4723" }
				GradientStop { position: 0.9; color: "#996633" }
				GradientStop { position: 1.0; color: "#AAA" }
			}
			
			Image {
				id: initialBlack
				source: Activity.url + "black_piece.svg"
				sourceSize.height: Math.min(parent.height*0.8,parent.width*0.4)
				x: parent.width*0.06
				anchors.verticalCenter: parent.verticalCenter
			}
			
			GCText {
				id: blackNumber
				anchors {
					verticalCenter: parent.verticalCenter
					left: initialBlack.right
					leftMargin: 7
				}
				fontSize: initialBlack.height/2
				color: "white"
				style: Text.Outline
				styleColor: "black"
				horizontalAlignment: Text.AlignHCenter
				property int count: 9
				text: "X%1".arg(count)
			}
				
		}
        
        // Tutorial section starts
        Image {
			id: previousTutorial
			source: Activity.url + "bar_previous.svg"
			sourceSize.height: skipTutorial.height*1.1
			visible: items.isTutorial && tutorialTxt.tutNum != 1
			anchors {
				top: parent.top
				topMargin: 5
				right: skipTutorialContainer.left
				rightMargin: 5
			}
			
			MouseArea {
				id: previousArea
				width: parent.width
				height: parent.height
				onClicked: {Activity.tutorialPrevious()}
			}
		}
		
		Image {
			id: nextTutorial
			source: Activity.url + "bar_next.svg"
			sourceSize.height: skipTutorial.height*1.1
			visible: items.isTutorial && tutorialTxt.tutNum != 5
			anchors {
				top: parent.top
				topMargin: 5
				left: skipTutorialContainer.right
				leftMargin: 5
			}
			
			MouseArea {
				id: nextArea
				width: parent.width
				height: parent.height
				onClicked: {Activity.tutorialNext()}
			}
		}
		
		GCText {
			id: skipTutorial
			anchors {
				horizontalCenter: parent.horizontalCenter
				//left: parent.left
				//leftMargin: 5
				top: parent.top
				topMargin: 5
			}
			fontSize: 12 //Math.min(parent.width/10, parent.height/2.5)
			color: "white"
			style: Text.Outline
			styleColor: "black"
			horizontalAlignment: Text.AlignHCenter
			width: Math.min(implicitWidth, 0.8*parent.width )
			wrapMode: TextEdit.WordWrap
			visible: items.isTutorial
			text: qsTr("Skip Tutorial")
			z: 2
		}

		Rectangle {
			id: skipTutorialContainer
			anchors.top: skipTutorial.top
			anchors.horizontalCenter: skipTutorial.horizontalCenter
			width: skipTutorial.width + 10
			height: skipTutorial.fontSize * 2.28 * Math.ceil(skipTutorial.implicitWidth / skipTutorial.width)
			opacity: 0.8
			radius: 10
			border.width: 2
			border.color: "black"
			visible: items.isTutorial
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#000" }
				GradientStop { position: 0.9; color: "#666" }
				GradientStop { position: 1.0; color: "#AAA" }
			}
			MouseArea {
				id: skipArea
				hoverEnabled: true
				width: parent.width
				height: parent.height
				onEntered: {skipTutorialContainer.border.color = "#62db53"}
				onExited: {skipTutorialContainer.border.color = "black"} 
				onClicked: {Activity.tutorialSkip()}
			}
		}
        
        GCText {
			id: tutorialTxt
			anchors {
				horizontalCenter: parent.horizontalCenter
				//left: parent.left
				//leftMargin: 5
				top: skipTutorial.bottom
				topMargin: skipTutorial.height*0.5
			}
			fontSize: 13 //Math.min(parent.width/10, parent.height/2.5)
			color: "white"
			style: Text.Outline
			styleColor: "black"
			horizontalAlignment: Text.AlignHLeft
			width: Math.min(implicitWidth, 0.8*parent.width )//, textWidth * tutorialTxt.parent.width)
			wrapMode: TextEdit.WordWrap
			visible: items.isTutorial
			text: "Tutorial"
			z: 2
			property int tutNum: 1
			
			/*
			function changeTutorialText() {
				if (tutNum == 1) {
					text = qsTr("Each player starts with 9 pieces. Initially, they take turns to \
										place all their 9 peices onto the empty spots on the board.")
				}
			}
			*/
		}

		Rectangle {
			id: tutorialTxtContainer
			anchors.top: tutorialTxt.top
			anchors.horizontalCenter: tutorialTxt.horizontalCenter
			width: tutorialTxt.width + 20
			height: tutorialTxt.fontSize * 2.5 * Math.ceil(tutorialTxt.implicitWidth / tutorialTxt.width)
			opacity: 0.8
			radius: 10
			border.width: 2
			border.color: "black"
			visible: items.isTutorial
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#000" }
				GradientStop { position: 0.9; color: "#666" }
				GradientStop { position: 1.0; color: "#AAA" }
			}
		}
        
        Image {
			id: tutorialImage
			source: Activity.url + "tutorial" + tutorialTxt.tutNum + ".svg"
			property int heightNeed: background.height - tutorialTxtContainer.height - bar.height - 4*skipTutorialContainer.height
			//sourceSize.height: Math.min(background.height - tutorialTxtContainer.height - 1.2*bar.height - 2*skipTutorial.height, 0.5*background.width) 
			//sourceSize.width: background.width
			//height: sourceSize.height >= sourceSize.width ? heightNeed : 0.5*background.width //heightNeed*parent.width/sourceSize.width
			width: (sourceSize.width/sourceSize.height) > (0.9*background.width/heightNeed) ? 0.9*background.width :
				   (sourceSize.width*heightNeed)/sourceSize.height
			fillMode: Image.PreserveAspectFit
			visible: items.isTutorial
			anchors {
				top: tutorialTxt.bottom
				topMargin: 10
				//bottom: bar.top
				//bottomMargin: 10
				horizontalCenter: parent.horizontalCenter
			}
		}
        // Tutorial section ends
        
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
            visible: !items.isTutorial
            
            Image {
                id: player2background
                source: Activity.url + "score_2.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent
                
                Image {
                    id: player2image
                    source: Activity.url + "TuxBlack.svg"
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
                        source: Activity.url + "TuxBlack.svg"
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
                        source: Activity.url + "TuxBlack.svg"
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
            visible: !items.isTutorial
            
            Image {
                id: player1background
                source: Activity.url + "score_1.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 0.5
                    
                Image {
                    id: player1image
                    source: Activity.url + "KonqiWhite.svg"
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
                        source: Activity.url + "KonqiWhite.svg"
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
                            source: Activity.url + "KonqiWhite.svg"
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
