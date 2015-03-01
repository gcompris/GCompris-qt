/* GCompris - pulkit.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <Pulkit Gupta> (GTK+ version)
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
import "pulkit.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
	    property alias ball: ball
	    property alias shadow: shadow
        }

        onStart: { Activity.start(items) }
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
                fontSize: mediumSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: TextEdit.WordWrap
                z: 2
		text: qsTr("Left click on the ball to make it bounce.")
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


	Item {
            id: exercise
            z: 99
            anchors {
               	    left: parent.left
		    leftMargin: 10
		    verticalCenter: parent.verticalCenter
            }
            width: parent.width * 0.9
            property alias text: exerciseTxt.text

	    GCText {
                id: exerciseTxt
                anchors {
		    left: parent.left
                    leftMargin: 10
		    verticalCenter: parent.verticalCenter
                }
                fontSize: mediumSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width/4 + parent.width/8
		height:parent.width/2 - parent.width/8
                wrapMode: TextEdit.WordWrap
                z: 2
		text: qsTr("Made as an exercise given for new contributors in Gsoc page." + 
			   "Added an image, text in the rectangle, and made an animation in ball and in its shadow :)")
            }	    

            Rectangle {
                anchors.fill: exerciseTxt
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
            id: shadow
            source: Activity.url + "shadow.svg"
            fillMode: Image.PreserveAspectFit	
	    Behavior on x { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on y { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
	    state: "INITIAL"
            states: [
                State {
                    name: "INITIAL"
                    PropertyChanges {
                        target: shadow;
                        x: parent.width/2;
                        y: parent.height/2 + ball.height;
			width:sourceSize.width;
			height:sourceSize.height
                    }
                }
                ]	
	}

		
        Image {
            id: ball
            source: Activity.url + "bouncy_ball.svg"
            fillMode: Image.PreserveAspectFit
            Behavior on x { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on y { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }

            state: "INITIAL"
            states: [
                State {
                    name: "INITIAL"
                    PropertyChanges {
                        target: ball;
                        x: parent.width/2;
                        y: parent.height/2
                    }
                },
                State {
                    name: "TOP"
                    PropertyChanges {
                        target: ball;
                        x: parent.width/2;
                        y: parent.height/8
                    }
                }
            ]	
			
		MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: {
                ball.state = "TOP"
		shadowshrink.start()  
		timerinit.start()
                    
                }
            }
        }

	SequentialAnimation {
            id: shadowshrink
            loops: 1
            PropertyAnimation {
                target: shadow
                properties: "scale"
                from: 1.0
                to: 0.0
                duration: 1000
            }
	    PropertyAnimation {
                target: shadow
                properties: "scale"
                from: 0.0
                to: 1.0
                duration: 1000
	    }
        }

	Timer {
            id: timerinit
            interval: 1000
            onTriggered: Activity.initial()
        }

       DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
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

