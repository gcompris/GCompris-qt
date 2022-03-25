/* GCompris - BalanceboxEditor.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtGraphicalEffects 1.0
import GCompris 1.0
import QtQuick.Controls 2.12

import "../../../core"
import ".."
import "balanceboxeditor.js" as Activity


Item {
    id: editor

    property string filename: ""
    onFilenameChanged: Activity.initEditor(props)

    property ActivityBase currentActivity
    property var testBox

    property bool isTesting: false

    // props needed for stackView integration:
    signal close
    signal start
    signal stop
    property bool isDialog: true
    property bool alwaysStart: true   // enforce start signal for configDialog-to-editor-transition

    function handleBackEvent()
    {
        if (!isTesting) {
            if (Activity.levelChanged)
                Activity.warnUnsavedChanges(function() {stop(); home();},
                                            function() {});
            else {
                stop();
                home();
            }
            return true;
        } else
            return false;

    }

    Keys.onEscapePressed: event.accepted = handleBackEvent();

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = handleBackEvent();
        } else
            event.accepted = false;
    }

    onStart: {
        focus = true;
        if (!isTesting)
            Activity.initEditor(props);
        else
            stopTesting();
    }

    onStop: testBox.focus = true;

    QtObject {
        id: props
        property int columns: 10
        property int rows: 10
        property int currentTool
        property alias editor: editor
        property alias mapModel: mapModel
        property alias mapWrapper: mapWrapper
        property int cellSize: mapWrapper.length / Math.min(mapWrapper.rows, mapWrapper.columns)
        property int wallSize: cellSize / 5
        property int ballSize: cellSize - 2*wallSize
        property alias toolBox: toolBox
        property string contactValue: "1"
        property int lastOrderNum: 0
        property alias file: file
        property alias parser: parser
        property alias bar: bar
        property int lastGoalIndex: -1
        property int lastBallIndex: -1
        property alias editorWorker: editorWorker
    }

    function startTesting() {
        editor.isTesting = true;
        testBox.mode = "test";
        testBox.testLevel = Activity.modelToLevel();
        testBox.needRestart = true;
        back(testBox);
        testBox.start();
    }

    function stopTesting() {
        editor.isTesting = false;
        testBox.mode = "play";
        testBox.testLevel = null;
        testBox.needRestart = true;
    }

    Rectangle {
        id: background
        anchors.fill: parent

        File {
            id: file

            onError: console.error("File error: " + msg);
        }

        JsonParser {
            id: parser
            onError: console.error("Balanceboxeditor: Error parsing JSON: " + msg);
        }

        Column {
            id: toolBox2
            anchors.top: mapWrapper.top
            anchors.left: mapWrapper.right
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: 20 * ApplicationInfo.ratio
            spacing: 5 * ApplicationInfo.ratio
            width: (background.width - mapWrapper.width - props.wallSize - 20 * ApplicationInfo.ratio) / 2
            height: parent.height
//            anchors.topMargin: 20

            GCButton {
                id: loadButton
                width: parent.width
                height: props.cellSize
                text: qsTr("Load")
                onClicked: creationHandler.loadWindow()
            }
            GCButton {
                id: saveButton
                width: parent.width
                height: props.cellSize
                text: qsTr("Save")
                onClicked: creationHandler.saveWindow(Activity.saveModel())
            }
            GCButton {
                id: testButton
                width: parent.width
                height: props.cellSize
                text: qsTr("Test")
                onClicked: editor.startTesting();
            }
        }

        Column {
            id: toolBox
            anchors.top: mapWrapper.top
            anchors.topMargin: 20 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: (mapWrapper.x - 20)
            spacing: 5 * ApplicationInfo.ratio

            Component.onCompleted: clearTool.selected = true;

            function setCurrentTool(item)
            {
                props.currentTool = item.type;
                if (clearTool !== item) clearTool.selected = false;
                if (hWallTool !== item) hWallTool.selected = false;
                if (vWallTool !== item) vWallTool.selected = false;
                if (holeTool !== item) holeTool.selected = false;
                if (ballTool !== item) ballTool.selected = false;
                if (contactTool !== item) contactTool.selected = false;
                if (goalTool !== item) goalTool.selected = false;
            }

            EditorTool {
                id: clearTool
                type: Activity.TOOL_CLEAR
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize - 2

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(clearTool);
                    }
                }

                Image {
                    id: clear

                    source: "qrc:/gcompris/src/core/resource/cancel.svg"
                    width: props.cellSize - 4
                    height: props.cellSize - 4

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: hWallTool
                type: Activity.TOOL_H_WALL
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(hWallTool);
                    }
                }

                Wall {
                    id: hWall

                    width: props.cellSize
                    height: props.wallSize

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: vWallTool
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize
                type: Activity.TOOL_V_WALL

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(vWallTool);
                    }
                }

                Wall {
                    id: vWall
                    width: props.wallSize
                    height: props.cellSize - 4
                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: holeTool
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize
                type: Activity.TOOL_HOLE
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(holeTool);
                    }
                }

                BalanceItem {
                    id: hole
                    width: props.cellSize - props.wallSize / 2
                    height: props.cellSize - props.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: props.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/hole.svg"
                }
            }

            EditorTool {
                id: ballTool
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize
                type: Activity.TOOL_BALL
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(ballTool);
                    }
                }

                BalanceItem {
                    id: ball
                    width: props.cellSize - props.wallSize / 2
                    height: parent.height - props.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: props.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/ball.svg"
                }
            }

            EditorTool {
                id: goalTool
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize
                type: Activity.TOOL_GOAL
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(goalTool);
                    }
                }

                BalanceItem {
                    id: goal
                    width: props.cellSize - props.wallSize
                    height: props.cellSize - props.wallSize
                    anchors.centerIn: parent
                    anchors.margins: props.wallSize / 2
                    z: 1
                    imageSource: Activity.baseUrl + "/door.svg"
                    imageScale: 1.1
                }
            }

            EditorTool {
                id: contactTool
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: props.cellSize
                type: Activity.TOOL_CONTACT
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(contactTool);
                    }
                }

                Row {
                    id: contactToolRow
                    spacing: 5
                    width: contact.width + contactTextInput.width + spacing
                    anchors.centerIn: parent

                    BalanceContact {
                        id: contact
                        width: props.cellSize - props.wallSize
                        height: props.cellSize - props.wallSize
                        anchors.margins: props.wallSize / 2
                        pressed: false
                        orderNum: 99
                        text: props.contactValue
                        z: 1
                    }
                    SpinBox {
                        id: contactTextInput
                        width: contact.width * 2
                        height: contact.height
                        value: props.contactValue
                        to: 99
                        from: 1
                        font.family: GCSingletonFontLoader.fontLoader.name
                        font.pixelSize: height / 2
                        onValueChanged: if (value != props.contactValue) props.contactValue = value;
                    }
                }
            }
        }

        WorkerScript {
            id: editorWorker

            source: "editor_worker.js"
            onMessage: {
                // worker finished, update all changed values (except the model):
                props.contactValue = messageObject.maxContactValue;
                props.lastBallIndex = messageObject.lastBallIndex;
                props.lastGoalIndex = messageObject.lastGoalIndex;
                props.lastOrderNum = messageObject.lastOrderNum;
                Activity.targetList = messageObject.targetList;
                testBox.loading.stop();
            }
        }

        ListModel {
            id: mapModel
        }

        Rectangle {
            id: mapWrapper

            property double margin: 20
            property int columns: props.columns
            property int rows: props.rows
            property double length: Math.min(background.height -
                    2*mapWrapper.margin, background.width - 2*mapWrapper.margin);

            color: "#E3DEDB"

            width: length
            height: length

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Grid {
                id: mapGrid
                columns: mapWrapper.columns
                rows: mapWrapper.rows
                anchors.fill: parent
                width: parent.width
                height: parent.height
                spacing: 0

                Repeater {
                    id: mapGridRepeater
                    model: mapModel//mapGrid.columns * mapGrid.rows

                    delegate: Item {  // cell wrapper
                        id: cell
                        width: props.cellSize
                        height: props.cellSize

                        property bool highlighted: false

                        Loader {
                            id: northWallLoader
                            active: value & Activity.NORTH
                            width: props.cellSize + props.wallSize
                            height: props.wallSize
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: -props.wallSize / 2
                            anchors.leftMargin: -props.wallSize / 2
                            sourceComponent: Wall {
                                id: northWall
                                shadow: false
                                anchors.centerIn: parent
                                z: 1
                            }
                        }

                        Loader {
                            id: eastWallLoader
                            active: value & Activity.EAST || (cell.highlighted && props.currentTool === Activity.TOOL_V_WALL)
                            width: props.wallSize
                            height: props.cellSize + props.wallSize
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: -props.wallSize / 2
                            anchors.rightMargin: -props.wallSize / 2
                            sourceComponent: Wall {
                                id: eastWall
                                anchors.centerIn: parent
                                shadow: false
                                z: 1
                            }
                        }

                        Loader {
                            id: southWallLoader
                            active: value & Activity.SOUTH || (cell.highlighted && props.currentTool === Activity.SOUTH)
                            width: props.cellSize + props.wallSize
                            height: props.wallSize
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: -props.wallSize / 2
                            anchors.leftMargin: -props.wallSize / 2
                            sourceComponent: Wall {
                                id: southWall
                                anchors.centerIn: parent
                                shadow: false
                                z: 1
                            }
                        }

                        Loader {
                            id: westWallLoader
                            active: value & Activity.WEST
                            width: props.wallSize
                            height: props.cellSize + props.wallSize
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: -props.wallSize / 2
                            anchors.leftMargin: -props.wallSize / 2
                            sourceComponent: Wall {
                                id: westWall
                                anchors.centerIn: parent
                                shadow: false
                                z: 1
                            }
                        }

                        Loader {
                            id: doorLoader
                            active: value & Activity.GOAL || (cell.highlighted && props.currentTool === Activity.TOOL_GOAL)
                            anchors.centerIn: parent
                            width: props.cellSize - props.wallSize
                            height: props.cellSize - props.wallSize
                            sourceComponent: BalanceItem {
                                id: goal
                                anchors.centerIn: parent
                                z: 1
                                imageSource: Activity.baseUrl + "/door.svg"
                                imageScale: 1.1
                            }
                        }

                        Loader {
                            id: holeLoader
                            active: value & Activity.HOLE || (cell.highlighted && props.currentTool === Activity.TOOL_HOLE)
                            anchors.centerIn: parent
                            sourceComponent: BalanceItem {
                                id: hole
                                width: props.ballSize
                                height:props.ballSize
                                anchors.centerIn: parent
                                z: 1
                                imageSource: Activity.baseUrl + "/hole.svg"
                            }
                        }

                        Loader {
                            id: ballLoader
                            active: value & Activity.START || (cell.highlighted && props.currentTool === Activity.TOOL_BALL)
                            anchors.centerIn: parent
                            sourceComponent: BalanceItem {
                                    id: ball
                                    width: props.ballSize
                                    height:props.ballSize
                                    anchors.centerIn: parent
                                    visible: true
                                    imageSource: Activity.baseUrl + "/ball.svg"
                                    z: 1
                            }
                        }

                        Loader {
                            id: contactLoader
                            active: (value & Activity.CONTACT) || (cell.highlighted && props.currentTool === Activity.TOOL_CONTACT)
                            width: props.cellSize - props.wallSize
                            height: props.cellSize - props.wallSize
                            anchors.centerIn: parent
                            sourceComponent: BalanceContact {
                                id: contact
                                anchors.centerIn: parent
                                visible: true
                                pressed: false
                                text: contactValue
                                z: 1
                            }
                        }

                        Rectangle {  // bounding rect
                            id: cellRect

                            width: props.cellSize
                            height: props.cellSize
                            color: "transparent"
                            border.width: 1
                            border.color: cell.highlighted ? "yellow": "lightgray"
                            z: 10

                            MouseArea {
                                id: cellMouse
                                anchors.fill: parent

                                hoverEnabled: ApplicationInfo.isMobile ? false : true
                                onEntered: cell.highlighted = true
                                onExited: cell.highlighted = false
                                onClicked: {
                                    editor.focus = true;
                                    Activity.modifyMap(props, row, col);
                                }
                            }
                        }

                    }
                }
            }

            // right:
            Wall {
                id: rightWall

                width: props.wallSize
                height: parent.height + props.wallSize

                anchors.left: mapWrapper.right
                anchors.leftMargin: - props.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -props.wallSize/2

                shadow: false
            }
            // bottom:
            Wall {
                id: bottomWall

                width: parent.width + props.wallSize
                height: props.wallSize

                anchors.left: mapWrapper.left 
                anchors.leftMargin: - props.wallSize/2
                anchors.top: parent.bottom
                anchors.topMargin: -props.wallSize/2

                shadow: false
            }
            // top:
            Wall {
                id: topWall

                width: parent.width + props.wallSize
                height: props.wallSize

                anchors.left: mapWrapper.left 
                anchors.leftMargin: - props.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -props.wallSize/2
                shadow: false
            }
            // left:
            Wall {
                id: leftWall

                width: props.wallSize
                height: parent.height + props.wallSize

                anchors.left: mapWrapper.left
                anchors.leftMargin: - props.wallSize/2
                anchors.top: parent.top
                anchors.topMargin: -props.wallSize/2
                shadow: false
            }
        }
    }

    Bar {
        id: bar
        content: BarEnumContent { value: home | level } // FIXME: add dedicated editor help?
        onPreviousLevelClicked: {
            if (Activity.currentLevel > 0) {
                if (Activity.levelChanged)
                    Activity.warnUnsavedChanges(Activity.previousLevel,
                                                function() {});
                else
                    Activity.previousLevel();
            }
        }
        onNextLevelClicked: {
            if (Activity.levelChanged)
                Activity.warnUnsavedChanges(function() {
                    Activity.levelChanged = false; // mark unchanged early to make check in nextLevel() work
                    Activity.nextLevel();
                }, function() {});
            else
                Activity.nextLevel();
        }
        onHomeClicked: {
            if (Activity.levelChanged)
                Activity.warnUnsavedChanges(activity.home,
                                            function() {});
            else {
                activity.home()
            }
        }
    }
}
