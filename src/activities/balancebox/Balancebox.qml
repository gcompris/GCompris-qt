/* GCompris - balancebox.qml
 *
 * Copyright (C) 2014-2016 Holger Kaelberer <holger.k@elberer.de>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Window 2.2
import QtSensors 5.0
import QtGraphicalEffects 1.0
import GCompris 1.0
import Box2D 2.0
import QtQuick.Controls 1.5


import "../../core"
import "editor/"
import "balancebox.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    property string mode: "play"  // "play" or "test"
    property string levelSet: "builtin"   // "builtin" or "user"
    // When the user launches the activity in "user" mode by default(due to previously save config mode) for the first time after updating GCompris, default user file must be loaded as they must be having created levels in it.
    // From next time onwards, the saved file path is loaded. Refer to line 567.
    property string loadedFilePath: (levelSet == "builtin") ? Activity.builtinFile : Activity.userFile
    property var testLevel
    property bool inForeground: false   // to avoid unneeded reconfigurations

    property bool alwaysStart: true     // enforce start signal for editor-to-testing- and returning from config-transition
    property bool needRestart: true

    onWidthChanged: if (inForeground && pageView.currentItem === activity)
                       Activity.reconfigureScene();

    onHeightChanged: if (inForeground && pageView.currentItem === activity)
                         Activity.reconfigureScene();

    onStart: {
        inForeground = true;
        focus = true;
    }
    onStop: inForeground = false;

    Keys.onPressed: Activity.processKeyPress(event.key)
    Keys.onReleased: Activity.processKeyRelease(event.key)

    pageComponent: Image {
        id: background
        source: Activity.baseUrl + "/maze_bg.svg"
        sourceSize.width: parent.width
        anchors.fill: parent
        signal start
        signal stop

        function startEditor() {
            editorLoader.active = true;
            if (activity.mode == "test")
                displayDialogs([dialogActivityConfig, editorLoader.item]);
            else
                displayDialog(editorLoader.item);
        }

        function handleBackEvent() {
            if (activity.mode == "test") {
                startEditor();
                return true;
            } else
                return false;
        }

        Keys.onEscapePressed: event.accepted = handleBackEvent();

        Keys.onReleased: {
            if (event.key === Qt.Key_Back)
                event.accepted = handleBackEvent();
        }

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
            items.dpi = Math.round(Screen.pixelDensity*25.4);

        }

        onStart: if (activity.needRestart) {
                     Activity.start(items);
                     activity.needRestart = false;
                 } else
                     Activity.initLevel();

        onStop: {
            Activity.stop();
            activity.needRestart = true;
        }

        QtObject {
            id: items
            property string mode: activity.mode
            property string levelSet: activity.levelSet
            property string filePath: activity.loadedFilePath
            property var testLevel: activity.testLevel
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias tilt: tilt
            property alias timer: timer
            property alias ball: ball
            property alias file: file
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
            property GCSfx audioEffects: activity.audioEffects
            property Loading loading: activity.loading
        }

        Loader {
            id: editorLoader
            active: false
            sourceComponent: BalanceboxEditor {
                id: editor
                visible: true
                testBox: activity

                onClose: activity.home()

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

            transform: [
                Rotation {
                    origin.x: mapWrapper.width / 2
                    origin.y: mapWrapper.height / 2
                    axis { x: 1; y: 0; z: 0 }
                    angle: ApplicationInfo.isMobile ? 0 : -items.tilt.xRotation
                },
                Rotation {
                    origin.x: mapWrapper.width / 2
                    origin.y: mapWrapper.height / 2
                    axis { x: 0; y: 1; z: 0 }
                    angle: ApplicationInfo.isMobile ? 0 : items.tilt.yRotation
                }
            ]

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
                visible: false
                scale: 1.0
                width: items.ballSize
                height: items.ballSize
                z: 3  // above other BalanceItems
                categories: items.ballType
                collidesWith: items.wallType | items.holeType | items.goalType 
                              | items.buttonType
                density: 1
                friction: Activity.friction
                linearDamping: Activity.friction
                restitution: Activity.restitution
                bodyType: Body.Dynamic
                shadow: true
                shadowHorizontalOffset: (items.tilt.yRotation > 0) ? Math.min(items.tilt.yRotation, items.wallSize) : Math.max(items.tilt.yRotation, -items.wallSize)
                shadowVerticalOffset: (items.tilt.xRotation > 0) ? Math.min(items.tilt.xRotation, items.wallSize) : Math.max(items.tilt.xRotation, -items.wallSize)

                Behavior on scale {
                    NumberAnimation {
                        id: fallAnimation
                        duration: 1000
                    }
                }

                onBeginContact: {
                    if (other.categories !== items.wallType)
                        Activity.addBallContact(other);
                    else {
                        // sound-effect on each contact with a wall might be too annoying:
                        //items.audioEffects.stop();
                        //items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav");
                    }
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
                z: 100
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

            property bool swapAxes: false
            property bool invertX: false
            property bool invertY: false
            
            onXRotationChanged: {
                if (xRotation > 90)
                    xRotation = 90;
                else if (xRotation < -90)
                    xRotation = -90;
            }
            onYRotationChanged: {
                if (yRotation > 90)
                    yRotation = 90;
                else if (yRotation < -90)
                    yRotation = -90;
            }

            TiltSensor {
                id: tiltSensor
                active: ApplicationInfo.isMobile ? true : false
    
                onReadingChanged: {
                    if (!tilt.swapAxes) {
                        tilt.xRotation = tilt.invertX ? -reading.xRotation : reading.xRotation;
                        tilt.yRotation = tilt.invertY ? -reading.yRotation : reading.yRotation;
                    } else {
                        tilt.xRotation = tilt.invertX ? -reading.yRotation : reading.yRotation;
                        tilt.yRotation = tilt.invertY ? -reading.xRotation : reading.xRotation;
                    }

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

        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [ TouchPoint { id: point1 } ]
            property real startX
            property real startY
            property int offset: 30

            function reset() {
                startX = point1.x
                startY = point1.y
            }

            onPressed: {
                reset()
            }

            onUpdated: {
                var moveX = point1.x - startX
                var moveY = point1.y - startY
                // Find the direction with the most move
                if(Math.abs(moveX) * ApplicationInfo.ratio > offset &&
                   Math.abs(moveX) > Math.abs(moveY)) {
                    if(moveX > offset * ApplicationInfo.ratio) {
                        Activity.processKeyPress(Qt.Key_Right)
                        reset()
                    } else if(moveX < -offset * ApplicationInfo.ratio) {
                        Activity.processKeyPress(Qt.Key_Left)
                        reset()
                    }
                } else if(Math.abs(moveY) * ApplicationInfo.ratio > offset &&
                          Math.abs(moveX) < Math.abs(moveY)) {
                    if(moveY > offset * ApplicationInfo.ratio) {
                        Activity.processKeyPress(Qt.Key_Down)
                        reset()
                    } else if(moveY < -offset * ApplicationInfo.ratio) {
                        Activity.processKeyPress(Qt.Key_Up)
                        reset()
                    }
                }
            }
            onReleased: {
                Activity.keyboardIsTilting = false
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
                // stop everything or the ball keeps moving while we're away:
                items.timer.stop();
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: if (!Activity.finishRunning)
                                        Activity.previousLevel()
            onNextLevelClicked: if (!Activity.finishRunning)
                                    Activity.nextLevel()
            onHomeClicked: {
                if (activity.mode == "test")
                    background.startEditor();
                else
                    activity.home()
            }
            onConfigClicked: {
                items.timer.stop();
                dialogActivityConfig.active = true
                // Set default values
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus

            looseSound: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
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

        GCCreationHandler {
            id: creationHandler
            readonly property bool isEditorActive: editorLoader.active && editorLoader.item.visible
            onFileLoaded: {
                if(!isEditorActive)
                    activity.loadedFilePath = filePath
                else
                    editorLoader.item.filename = filePath
                close()
            }
            parent: isEditorActive ? editorLoader.item : dialogActivityConfig
        }

        File {
            id: file
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias levelsBox: levelsBox
                    property var availableLevels: [
                        { "text": qsTr("Built-in"), "value": "builtin" },
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

                        Column {
                            spacing: 5
                            Button {
                                id: editorButton
                                style:  GCButtonStyle {}
                                height: levelsBox.height
                                text: qsTr("Start Editor")
                                visible: levelsBox.currentIndex == 1
                                onClicked: background.startEditor()
                            }

                            Button {
                                id: loadButton
                                style:  GCButtonStyle {}
                                height: levelsBox.height
                                text: qsTr("Load saved levels")
                                visible: levelsBox.currentIndex == 1
                                onClicked: creationHandler.loadWindow()
                            }
                        }
                    }
                }
            }

            onClose: home();

            onLoadData: {
                if(dataToSave && dataToSave["levels"]) {
                    activity.levelSet = dataToSave["levels"];
                    if(dataToSave['filePath'])
                        activity.loadedFilePath = dataToSave["filePath"]
                }
            }

            onSaveData: {
                var newLevels = dialogActivityConfig.configItem
                    .availableLevels[dialogActivityConfig.configItem.levelsBox.currentIndex].value;
                var initialFilePath = dataToSave['filePath'] ? dataToSave['filePath'] : ""
                if(newLevels === "builtin")
                    activity.loadedFilePath = Activity.builtinFile
                if (newLevels !== activity.levelSet || initialFilePath != activity.loadedFilePath) {
                    activity.levelSet = newLevels;
                    dataToSave = {"levels": activity.levelSet, "filePath": activity.loadedFilePath};
                    activity.needRestart = true;
                }
            }

            dataValidationFunc: function() {
                var newLevels = dialogActivityConfig.configItem
                    .availableLevels[dialogActivityConfig.configItem.levelsBox.currentIndex].value
                if (newLevels === "user" && activity.loadedFilePath === Activity.builtinFile) {
                    Core.showMessageDialog(dialogActivityConfig,
                                           qsTr("You selected the user-defined level set, but you have not yet defined any user levels!<br/> " +
                                 "Either create your user levels by starting the level editor or choose the 'built-in' level set."),
                                  qsTr("Ok"), null,
                                  "", null,
                                  null);
                    return false;
                }

                return true;
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
