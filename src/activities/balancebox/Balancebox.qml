/* GCompris - balance.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
import QtQuick.Window 2.1
import QtSensors 5.0
import QtGraphicalEffects 1.0
import GCompris 1.0
import Box2D 2.0

import "../../core"
import "balancebox.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    Keys.enabled: ApplicationInfo.isMobile ? false : true
    Keys.onPressed: Activity.processKeyPress(event.key)
    Keys.onReleased: Activity.processKeyRelease(event.key)
        
    pageComponent: Image {
        id: background
        source: Activity.baseUrl + "/maze_bg.svg"
        sourceSize.width: parent.width
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            items.dpi = Math.round(Screen.pixelDensity*25.4);
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias tilt: tilt
            property alias timer: timer
            property alias ball: ball
            property alias mapWrapper: mapWrapper
            property int cellSize: mapWrapper.length / Math.min(mapWrapper.rows, mapWrapper.columns)
            property int wallSize: cellSize / 5
            property var world: physicsWorld
            property alias keyboardTimer: keyboardTimer
            property var ballType: Fixture.Category1
            property var wallType: Fixture.Category2
            property var holeType: Fixture.Category3
            property var goalType: Fixture.Category4
            property var buttonType: Fixture.Category5
            property alias parser: parser
            property double dpi
        }

        JsonParser {
            id: parser
            onError: console.error("Balancebox: Error parsing JSON: " + msg);
        }

        Rectangle {
            id: mapWrapper

            property double margin: 20
            property int columns: 0
            property int rows: 0
            property double length: Math.min(background.height -
                    2*mapWrapper.margin, background.width - 2*mapWrapper.margin);

            color: "#E3DEDB"

            width: length
            height: length
        
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            
            // right:
            Wall {
                id: rightWall
                
                width: items.wallSize
                height: parent.height + items.wallSize
                
                anchors.left: mapWrapper.right
                anchors.leftMargin: - items.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize/2
                
                shadow: true
                shadowHorizontalOffset: items.tilt.yRotation
                shadowVerticalOffset: items.tilt.xRotation
            }
            // bottom:
            Wall {
                id: bottomWall
                
                width: parent.width + items.wallSize
                height: items.wallSize
                
                anchors.left: mapWrapper.left 
                anchors.leftMargin: - items.wallSize/2
                anchors.top: parent.bottom
                anchors.topMargin: -items.wallSize/2
                
                shadow: true
                shadowHorizontalOffset: items.tilt.yRotation
                shadowVerticalOffset: items.tilt.xRotation
            }
            // top:
            Wall {
                id: topWall
                
                width: parent.width + items.wallSize
                height: items.wallSize
                
                anchors.left: mapWrapper.left 
                anchors.leftMargin: - items.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize/2
                shadow: true
                shadowHorizontalOffset: items.tilt.yRotation
                shadowVerticalOffset: items.tilt.xRotation                
            }
            // left:
            Wall {
                id: leftWall
                
                width: items.wallSize
                height: parent.height + items.wallSize
                
                anchors.left: mapWrapper.left
                anchors.leftMargin: - items.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize/2
                shadow: true
                shadowHorizontalOffset: items.tilt.yRotation
                shadowVerticalOffset: items.tilt.xRotation
            }
            
            BalanceItem {
                id: ball
                world: physicsWorld
                imageSource: Activity.baseUrl + "/ball.svg"
                scale: 1.0
                z: 1
                categories: items.ballType
                collidesWith: items.wallType | items.holeType | items.goalType 
                              | items.buttonType
                density: 1
                friction: Activity.friction
                linearDamping: Activity.friction
                restitution: Activity.restitution
                bodyType: Body.Dynamic

                //Component.onCompleted: console.log("XXX ball: " + width + "/" + height 
                //        + " - " + parent.width + "/" + parent.height); 

                Behavior on scale {
                    NumberAnimation {
                        id: fallAnimation
                        duration: 1000
                    }
                }
            
                onBeginContact: {
                    //console.log("ZZZ: contact with " + other.categories);
                    if (other.categories !== items.wallType)
                        Activity.addBallContact(other);
                }
                onEndContact: {
                    if (other.categories !== items.wallType)
                        Activity.removeBallContact(other);
                }
            }
            World {
                id: physicsWorld
                
                gravity: Qt.point(0, 0)  // we calculate acceleration ourselves
                
                pixelsPerMeter: Activity.box2dPpm // default: 32
                timeStep: Activity.step/1000  // default: 1/60
                
            }

            DebugDraw {
                id: debugDraw
                world: physicsWorld
                visible: Activity.debugDraw
                z: 1
            }            
            
        }
        
        Timer {
            id: timer
            interval: Activity.step;
            running: false;
            repeat: true
            onTriggered: Activity.moveBall()
        }

        Item {
            id: tilt

            property double xRotation: 0
            property double yRotation: 0
            
            onXRotationChanged: {
                if (xRotation > 90)
                    xRotation = 90;
                else if (xRotation < -90)
                    xRotation = -90;
                //console.log("xRotation changed to " + xRotation);
            }
            onYRotationChanged: {
                //console.log("yRotation changed to " + yRotation);
                if (yRotation > 90)
                    yRotation = 90;
                else if (yRotation < -90)
                    yRotation = -90;
                //console.log("xRotation changed to " + xRotation);
            }
            
            TiltSensor {
                id: tiltSensor
                active: ApplicationInfo.isMobile ? true : false
    
                onReadingChanged: {
                    tilt.xRotation = reading.xRotation;
                    tilt.yRotation = reading.yRotation;
                    
                    tiltText.text = "X/Y Rotation: " 
                        + tiltSensor.reading.xRotation 
                        + "/" + tiltSensor.reading.yRotation
                }
            }

        }
        
        Item {
            id: textWrapper
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            height: parent.height / 3
            visible: Activity.debugDraw
            
            Text {
                id: tiltText
                anchors.left: parent.left
                anchors.top: parent.top
                text: "X/Y Rotation: " + tilt.xRotation + "/" + tilt.yRotation
                font.pointSize: 12
            }
        
            Text {
                id: posText
                anchors.left: parent.left
                anchors.top: tiltText.bottom
                text: "X/Y = " + ball.x + "/" + ball.y
                font.pointSize: 12
            }
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
            Component.onCompleted: {
                win.connect(Activity.nextLevel);
                loose.connect(Activity.initLevel);
            }
        }
        
        Timer {
            id: keyboardTimer
            interval: Activity.keyboardTimeStep;
            running: false
            repeat: false
            onTriggered: Activity.keyboardHandler()
        }
    }
}
