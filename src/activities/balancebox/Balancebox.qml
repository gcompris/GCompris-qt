/* GCompris - balance.qml
 *
 * Copyright (C) 2014,2015 Holger Kaelberer <holger.k@elberer.de>
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
import QtQuick.Controls 1.0


import "../../core"
import "editor/"
import "balancebox.js" as Activity

ActivityBase {
    id: activity

    property string mode: "play"  // "play" or "test"
    property string levelSet: "builtin"   // "builtin" or "user"
    property var testLevel

    onStart: {
        console.log("XXX BalanceBox onStart");
        focus = true;
    }
    onStop: {console.log("XXX BalanceBox onStop");}

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

        Keys.onPressed: {
            if (event.key == Qt.Key_A) {
                startEditor()
            }
        }

        Keys.onEscapePressed: {
            console.log("XXX Balancebox onEscape");
            if (activity.mode == "test") {
                console.log("XXX Balancebox onEscape");
                startEditor();
                event.accepted = true;
            } else
                event.accepted = false;
        }

        function startEditor() {
            console.log("XXX: launching editor");
            editorLoader.active = true;
            if (activity.mode == "test")
                displayDialogs([dialogActivityConfig, editorLoader.item]);
            else
                displayDialog(editorLoader.item);
        }

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
            items.dpi = Math.round(Screen.pixelDensity*25.4);

        }

        onStart: Activity.start(items)

        onStop: { Activity.stop() }

        QtObject {
            id: items
            property string mode: activity.mode
            property string levelSet: activity.levelSet
            property var testLevel: activity.testLevel
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias tilt: tilt
            property alias timer: timer
            property alias ball: ball
            property int ballSize: cellSize - 2*wallSize
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

        Loader {
            id: editorLoader
            active: false
            sourceComponent: BalanceboxEditor {
                id: editor
                visible: true
                testBox: activity

                onClose: {
                    console.log("XXX editor.onClose");
                    activity.home()
                }

            }
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
                
                shadow: false
                shadowHorizontalOffset: Math.min(items.tilt.yRotation, items.wallSize)
                shadowVerticalOffset: Math.min(items.tilt.xRotation, items.wallSize)
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
                
                shadow: false
                shadowHorizontalOffset: Math.min(items.tilt.yRotation, items.wallSize)
                shadowVerticalOffset: Math.min(items.tilt.xRotation, items.wallSize)
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
                shadow: false
                shadowHorizontalOffset: Math.min(items.tilt.yRotation, items.wallSize)
                shadowVerticalOffset: Math.min(items.tilt.xRotation, items.wallSize)
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
                shadow: false
                shadowHorizontalOffset: Math.min(items.tilt.yRotation, items.wallSize)
                shadowVerticalOffset: Math.min(items.tilt.xRotation, items.wallSize)
            }
            
            BalanceItem {
                id: ball
                world: physicsWorld
                imageSource: Activity.baseUrl + "/ball.svg"
                scale: 1.0
                width: items.ballSize
                height: items.ballSize
                z: 1
                categories: items.ballType
                collidesWith: items.wallType | items.holeType | items.goalType 
                              | items.buttonType
                density: 1
                friction: Activity.friction
                linearDamping: Activity.friction
                restitution: Activity.restitution
                bodyType: Body.Dynamic
                shadow: true
                shadowHorizontalOffset: Math.min(items.tilt.yRotation, items.wallSize)
                shadowVerticalOffset: Math.min(items.tilt.xRotation, items.wallSize)

                Behavior on scale {
                    NumberAnimation {
                        id: fallAnimation
                        duration: 1000
                    }
                }
            
                onBeginContact: {
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
            content: BarEnumContent {
                value: activity.mode == "play"
                           ? (help | home | level | config )
                           : ( help | home )
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if (activity.mode == "test")
                    background.startEditor();
                else
                    activity.home()
            }
            onConfigClicked: {
                dialogActivityConfig.active = true
                // Set default values
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
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

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias levelsBox: levelsBox

                    property var availableLevels: [
                        { "text": qsTr("Bultin"), "value": "builtin" },
                        { "text": qsTr("User"), "value": "user" },
                    ]

                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: levelsBox
                            model: availableLevels
                            background: dialogActivityConfig
                            label: qsTr("Select your level set")
                        }

                        Button {
                            id: editorButton
                            style:  GCButtonStyle {}
                            //width: 80
                            height: levelsBox.height
                            text: "Start Editor"
                            visible: levelsBox.currentIndex == 1
                            onClicked: background.startEditor()
                        }
                    }
                }
            }

            onClose: home()

            onLoadData: {
                if(dataToSave && dataToSave["levels"]) {
                    activity.levelSet = dataToSave["levels"];
                }
            }

            onSaveData: {
                var newLevels = dialogActivityConfig.configItem
                    .availableLevels[dialogActivityConfig.configItem.levelsBox.currentIndex].value;
                if (newLevels !== activity.levelSet) {
                    activity.levelSet = newLevels;
                    dataToSave = {"levels": activity.levelSet};
                    //activity.start();  done automatically during view switch
                }
            }

            function setDefaultValues() {
                for(var i = 0 ;
                    i < dialogActivityConfig.configItem.availableLevels.length;
                    i ++) {
                    if(dialogActivityConfig.configItem.availableLevels[i].value === activity.levelSet) {
                        dialogActivityConfig.configItem.levelsBox.currentIndex = i;
                        break;
                    }
                }
            }
        }
    }
}
