/* GCompris - BalanceboxEditor.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
import QtGraphicalEffects 1.0
import GCompris 1.0
import QtQuick.Controls 1.0

import "../../../core"
import ".."
import "balanceboxeditor.js" as Activity


Item {
    id: editor

    property string filename: Activity.userFile
    property bool isDialog: true

    property ActivityBase currentActivity
    property var testBox

    property bool isTesting: false

    /**
     * Emitted when the config dialog has been closed.
     */
    signal close

    /**
     * Emitted when the config dialog has been started.
     */
    signal start

    signal stop

/*    Keys.enabled: ApplicationInfo.isMobile ? false : true
    Keys.onPressed: Activity.processKeyPress(event.key)
    Keys.onReleased: Activity.processKeyRelease(event.key)
  */

    Keys.onEscapePressed: {
        console.log("XXX editor onEscape");
        if (!isTesting) {
            if (Activity.levelChanged)
                Activity.warnUnsavedChanges(home,
                                            function() {});
            else
                home()
        } else
            event.accepted = false;
    }

    onStart: {
        console.log("XXX Editor onStart");
        if (!isTesting)
            Activity.initEditor(props);
        else
            stopTesting();
    }
    onStop: {console.log("XXX Editor onStop");}

    Component.onCompleted: console.log("XXX editor complete " + filename);

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
        // singletons:
        property int lastGoalIndex: -1
        property int lastBallIndex: -1
    }

    function startTesting() {
        console.log("BalanceboxEditor: entering testing mode");
        editor.isTesting = true;
        testBox.mode = "test";
        testBox.testLevel = Activity.modelToLevel();
        //testBox.start();
        //activity.home();
        back(testBox);
    }

    function stopTesting() {
        console.log("BalanceboxEditor: stopping testing mode");
        editor.isTesting = false;
        testBox.mode = "play";
        testBox.testLevel = null;
    }

    Rectangle {
        id: background
        anchors.fill: parent

        Component.onCompleted: {
            console.log("XXX editor completed");
        }

        File {
            id: file

            onError: console.error("File error: " + msg);
        }

        JsonParser {
            id: parser
            onError: console.error("Balanceboxeditor: Error parsing JSON: " + msg);
        }

        GCText {
            id: title
            text: "Editor"
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Column {
            id: toolBox2
            anchors.top: mapWrapper.top
            anchors.left: mapWrapper.right
            anchors.leftMargin: 20
            spacing: 5
            width: 80
            height: parent.height
            anchors.topMargin: 20
//            /anchors.rightMargin: (background.width - mapWrapper.x - mapWrapper.width ) / 2

            Button {
                id: saveButton
                width:100
                height: 30
                style: GCButtonStyle {}
                text: "Save"
                onClicked: {
                    Activity.saveModel();
                }
            }
            Button {
                id: testButton
                width: 100
                height: 30
                style: GCButtonStyle {}
                text: "Test"
                onClicked: editor.startTesting();
            }
        }

        Column {
            id: toolBox
            anchors.top: title.bottom
            anchors.left: parent.left
            width: props.cellSize
            spacing: 5
            anchors.leftMargin: (mapWrapper.x - width ) / 2

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
                console.log("XXX new current tool: " + item);
            }

            EditorTool {
                id: clearTool
                type: Activity.TOOL_CLEAR
                anchors.left: parent.left
                width: props.cellSize - 2
                height: props.cellSize - 2

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(clearTool);
                    }
                }

                Image {
                    id: clear

                    source: "qrc:/gcompris/src/core/resource/cancel.svg"
                    width: parent.width
                    height: parent.height

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: hWallTool
                type: Activity.TOOL_H_WALL
                anchors.left: parent.left
                width: props.cellSize
                height: props.cellSize

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(hWallTool);
                    }
                }

                Wall {
                    id: hWall

                    width: parent.width
                    height: props.wallSize

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: vWallTool
                anchors.left: parent.left
                width: props.cellSize
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
                    height: parent.height

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: holeTool
                anchors.left: parent.left
                width: props.cellSize
                height: props.cellSize
                type: Activity.TOOL_HOLE
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(holeTool);
                    }
                }

                BalanceItem {
                    id: hole
                    width: parent.width - props.wallSize / 2
                    height: parent.height - props.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: props.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/hole.svg"
                }
            }

            EditorTool {
                id: ballTool
                anchors.left: parent.left
                width: props.cellSize
                height: props.cellSize
                type: Activity.TOOL_BALL
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(ballTool);
                    }
                }

                BalanceItem {
                    id: ball
                    width: parent.width - props.wallSize / 2
                    height: parent.height - props.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: props.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/ball.svg"
                }
            }

            EditorTool {
                id: goalTool
                anchors.left: parent.left
                width: props.cellSize
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
                }
            }

            Rectangle {
                id: contactToolWrapper
                width: props.cellSize * 2
                height: props.cellSize
                color: "silver"

                EditorTool {
                    id: contactTool
                    anchors.left: parent.left
                    width: props.cellSize
                    height: props.cellSize
                    type: Activity.TOOL_CONTACT
                    onSelectedChanged: {
                        if (selected) {
                            toolBox.setCurrentTool(contactTool);
                        }
                    }

                    BalanceContact {
                        id: contact
                        width: props.cellSize - props.wallSize
                        height: props.cellSize - props.wallSize
                        anchors.centerIn: parent
                        anchors.margins: props.wallSize / 2
                        pressed: false
                        orderNum: 99
                        text: props.contactValue
                        z: 1
                    }
                }
                TextInput {
                    id: contactTextInput
                    width: contactTool.width
                    height: contactTool.height
                    anchors.left: contactTool.right
                    text: props.contactValue
                    maximumLength: 2
                    //activeFocusOnPress: true
                    font.pixelSize: width / 2
                    //horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    onTextChanged: if (text !== props.contactValue) props.contactValue = text;
                }
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
                            active: (orn > 0) || (cell.highlighted && props.currentTool === Activity.TOOL_CONTACT)
                            width: props.cellSize - props.wallSize
                            height: props.cellSize - props.wallSize
                            anchors.centerIn: parent
                            sourceComponent: BalanceContact {
                                id: contact
                                anchors.centerIn: parent
                                visible: true
                                pressed: false
                                orderNum: orn
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
                                    activity.focus = true;
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
        content: BarEnumContent { value: help | home | level }
        onHelpClicked: {
            // FIXME: show help
        }
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
                Activity.warnUnsavedChanges(Activity.nextLevel,
                                            function() {});
            else
                Activity.nextLevel();
        }
        onHomeClicked: {
            if (Activity.levelChanged)
                Activity.warnUnsavedChanges(activity.home,
                                            function() {});
            else
                activity.home()
        }
    }

}
