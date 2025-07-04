/* GCompris - balancebox.qml
 *
 * SPDX-FileCopyrightText: 2014-2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Window
import QtSensors
import core 1.0
import Box2D 2.0


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
    property string loadedFilePath: Activity.builtinFile
    property var testLevel
    property bool inForeground: false   // to avoid unneeded reconfigurations

    property bool needRestart: true

    onStart: {
        inForeground = true;
        focus = true;
    }
    onStop: inForeground = false;

    Keys.onPressed: (event) => { Activity.processKeyPress(event.key) }
    Keys.onReleased: (event) => { Activity.processKeyRelease(event.key) }

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/maze/resource/maze_bg.svg"
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

        function handleBackEvent(): bool {
            if (activity.mode == "test") {
                startEditor();
                return true;
            } else
                return false;
        }

        function noUserLevelSelected() {
            Core.showMessageDialog(activity,
                                  qsTr("You selected the user-defined level set, but you have not yet loaded any user level!") + "<br/>" +
                                  Activity.createLevelsMsg,
                                  qsTr("OK"), null,
                                  "", null,
                                  null);
        }

        Keys.onEscapePressed: (event) => event.accepted = handleBackEvent();

        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Back)
                event.accepted = handleBackEvent();
        }

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
            items.dpi = Math.round(Screen.pixelDensity*25.4);

        }

        onStart: {
            if (activity.needRestart) {
                Activity.start(items);
                activity.needRestart = false;
            } else
                Activity.initLevel();
            if(activity.levelSet === "user" && activity.loadedFilePath === Activity.builtinFile) {
                noUserLevelSelected();
            }
        }

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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias tilt: tilt
            property alias timer: timer
            property alias ball: ball
            property alias file: file
            property int ballSize: cellSize - 2*wallSize
            property alias mapWrapper: mapWrapper
            property int cellSize: mapWrapper.length / Math.min(mapWrapper.rows, mapWrapper.columns)
            property int wallSize: cellSize * 0.2
            property var world: physicsWorld
            property alias keyboardTimer: keyboardTimer
            property var ballType: Fixture.Category1
            property var wallType: Fixture.Category2
            property var holeType: Fixture.Category3
            property var goalType: Fixture.Category4
            property var buttonType: Fixture.Category5
            property alias parser: parser
            property double dpi
            property alias winSound: winSound
            property alias contactSound: contactSound
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
            onError: (msg) => console.error("Balancebox: Error parsing JSON: " + msg);
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        GCSoundEffect {
            id: contactSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        // color overlay to better see the map outline
        Rectangle {
            anchors.fill: parent
            color: "#40FFFFFF"
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Rectangle {
            id: mapWrapper
            property double margin: GCStyle.baseMargins
            property int columns: 1
            property int rows: 1
            property double length: Math.min(layoutArea.width, layoutArea.height)

            color: "#E3DEDB"
            width: Math.min(layoutArea.width, layoutArea.height)
            height: width
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.verticalCenterOffset: layoutArea.height < length + layoutArea.anchors.bottomMargin ?
                0 : layoutArea.anchors.bottomMargin * 0.5

            onLengthChanged: if (activity.inForeground && pageView.currentItem === activity)
            resizeTimer.restart()

            transform: [
                Rotation {
                    origin.x: mapWrapper.width * 0.5
                    origin.y: mapWrapper.height * 0.5
                    axis { x: 1; y: 0; z: 0 }
                    angle: ApplicationInfo.isMobile ? 0 : -items.tilt.xRotation
                },
                Rotation {
                    origin.x: mapWrapper.width * 0.5
                    origin.y: mapWrapper.height * 0.5
                    axis { x: 0; y: 1; z: 0 }
                    angle: ApplicationInfo.isMobile ? 0 : items.tilt.yRotation
                }
            ]

            Timer {
                id: resizeTimer
                interval: 100
                onTriggered: Activity.reconfigureScene()
            }

            // right:
            Wall {
                id: rightWall

                width: items.wallSize
                height: parent.height + items.wallSize

                anchors.left: mapWrapper.right
                anchors.leftMargin: - items.wallSize * 0.5
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize * 0.5
            }
            // bottom:
            Wall {
                id: bottomWall

                width: parent.width + items.wallSize
                height: items.wallSize

                anchors.left: mapWrapper.left
                anchors.leftMargin: - items.wallSize * 0.5
                anchors.top: parent.bottom
                anchors.topMargin: -items.wallSize * 0.5
            }
            // top:
            Wall {
                id: topWall

                width: parent.width + items.wallSize
                height: items.wallSize

                anchors.left: mapWrapper.left
                anchors.leftMargin: - items.wallSize * 0.5
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize * 0.5
            }
            // left:
            Wall {
                id: leftWall

                width: items.wallSize
                height: parent.height + items.wallSize

                anchors.left: mapWrapper.left
                anchors.leftMargin: - items.wallSize * 0.5
                anchors.top: parent.top
                anchors.topMargin: -items.wallSize * 0.5
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

                onBeginContact: (item, other) => {
                    if (other.categories !== items.wallType)
                        Activity.addBallContact(other);
                    else {
                        // sound-effect on each contact with a wall might be too annoying:
                        //contactSound.stop();
                        //contactSound.play();
                    }
                }
                onEndContact: (item, other) => {
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
            onClose: {
                home()
                items.timer.start();
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent {
                value: activity.mode == "play"
                           ? (help | home | level | activityConfig )
                           : ( help | home )
            }
            onHelpClicked: {
                // stop everything or the ball keeps moving while we're away:
                Activity.stopBall();
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: if (!Activity.finishRunning)
                                        Activity.previousLevel()
            onNextLevelClicked: if (!Activity.finishRunning)
                                    Activity.nextLevel()
            onHomeClicked: {
                if (activity.mode == "test")
                    activityBackground.startEditor();
                else
                    activity.home()
            }
            onActivityConfigClicked: {
                Activity.stopBall();
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
            onFileLoaded: (data, filePath) => {
                if(!isEditorActive) {
                    activity.loadedFilePath = filePath
                }
                else
                    editorLoader.item.filename = filePath
                close()
            }
            parent: isEditorActive ? editorLoader.item : dialogActivityConfig
        }

        File {
            id: file
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
                items.timer.start();
            }
            onLoadData: {
                if(activityData && activityData["levels"]) {
                    activity.levelSet = activityData["levels"];
                    if(activityData['filePath'])
                        activity.loadedFilePath = activityData["filePath"];
                }
            }
            onStartActivity: {
                activityBackground.stop();
                activityBackground.start();
            }
        }
    }
}
