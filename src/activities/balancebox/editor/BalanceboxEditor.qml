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
import "../balancebox.js" as Activity


Item {
    id: editor

    property bool isDialog: true

    property ActivityBase currentActivity

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
    onStart: Activity.initEditor(props);

    Component.onCompleted: console.log("XXX editor complete");

    QtObject {
        id: props
        property int columns: 10
        property int rows: 10
        property int currentTool
        property alias mapModel: mapModel
        property alias mapGrimd: mapGrid
        property alias toolBox: toolBox
        property string contactValue: "1"
        // singletons:
        property int lastGoalIndex: -1
        property int lastBallIndex: -1
        property int lastOrderNum: 0
    }

    Rectangle {
        id: background
        anchors.fill: parent

        Component.onCompleted: {
            console.log("XXX editor completed");
        }

        JsonParser {
            id: parser
            onError: console.error("Balancebox: Error parsing JSON: " + msg);
        }

        GCText {
            id: title
            text: "Editor"
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Column {
            id: toolBox2
            anchors.top: background.top
            anchors.right: background.right
            width: 80
            height: parent.height
            anchors.topMargin: 20
//            /anchors.rightMargin: (background.width - mapWrapper.x - mapWrapper.width ) / 2

            Button {
                id: saveButton
                width: 80
                height: 30
                style: GCButtonStyle {}
                text: "Save"
                onClicked: {
                    Activity.modelToLevel(props);
                }
            }
        }

        Column {
            id: toolBox
            anchors.top: title.bottom
            anchors.left: parent.left
            width: items.cellSize
            anchors.leftMargin: (mapWrapper.x - width ) / 2


            function setCurrentTool(item)
            {
                props.currentTool = item.type;
                if (hWallTool !== item) hWallTool.selected = false;
                if (vWallTool !== item) vWallTool.selected = false;
                if (holeTool !== item) holeTool.selected = false;
                if (ballTool !== item) ballTool.selected = false;
                if (contactTool !== item) contactTool.selected = false;
                if (goalTool !== item) goalTool.selected = false;
                console.log("XXX new current tool: " + item);
            }

            EditorTool {
                id: hWallTool
                type: Activity.TOOL_H_WALL
                anchors.left: parent.left
                width: items.cellSize
                height: items.cellSize

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(hWallTool);
                    }
                }

                Wall {
                    id: hWall

                    width: parent.width
                    height: items.wallSize

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: vWallTool
                anchors.left: parent.left
                width: items.cellSize
                height: items.cellSize
                type: Activity.TOOL_V_WALL

                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(vWallTool);
                    }
                }

                Wall {
                    id: vWall

                    width: items.wallSize
                    height: parent.height

                    anchors.centerIn: parent
                    anchors.margins: 3
                }
            }

            EditorTool {
                id: holeTool
                anchors.left: parent.left
                width: items.cellSize
                height: items.cellSize
                type: Activity.TOOL_HOLE
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(holeTool);
                    }
                }

                BalanceItem {
                    id: hole
                    width: parent.width - items.wallSize / 2
                    height: parent.height - items.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: items.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/hole.svg"
                }
            }

            EditorTool {
                id: ballTool
                anchors.left: parent.left
                width: items.cellSize
                height: items.cellSize
                type: Activity.TOOL_BALL
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(ballTool);
                    }
                }

                BalanceItem {
                    id: ball
                    width: parent.width - items.wallSize / 2
                    height: parent.height - items.wallSize / 2
                    anchors.centerIn: parent
                    anchors.margins: items.wallSize / 2
                    visible: true
                    imageSource: Activity.baseUrl + "/ball.svg"
                }
            }

            EditorTool {
                id: goalTool
                anchors.left: parent.left
                width: items.cellSize
                height: items.cellSize
                type: Activity.TOOL_GOAL
                onSelectedChanged: {
                    if (selected) {
                        toolBox.setCurrentTool(goalTool);
                    }
                }

                BalanceItem {
                    id: goal
                    width: items.cellSize - items.wallSize
                    height: items.cellSize - items.wallSize
                    anchors.centerIn: parent
                    anchors.margins: items.wallSize / 2
                    z: 1
                    imageSource: Activity.baseUrl + "/door.svg"
                }
            }

            Rectangle {
                id: contactToolWrapper
                width: items.cellSize * 2
                height: items.cellSize
                color: "silver"

                EditorTool {
                    id: contactTool
                    anchors.left: parent.left
                    width: items.cellSize
                    height: items.cellSize
                    type: Activity.TOOL_CONTACT
                    onSelectedChanged: {
                        if (selected) {
                            toolBox.setCurrentTool(contactTool);
                        }
                    }

                    BalanceContact {
                        id: contact
                        width: items.cellSize - items.wallSize
                        height: items.cellSize - items.wallSize
                        anchors.centerIn: parent
                        anchors.margins: items.wallSize / 2
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
                        width: items.cellSize
                        height: items.cellSize

                        property bool highlighted: false

                        Wall {
                            id: northWall
                            width: items.cellSize + items.wallSize
                            height: items.wallSize
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: -items.wallSize / 2
                            anchors.leftMargin: -items.wallSize / 2
                            shadow: false
                            visible: value & Activity.NORTH
                            z: 1
                        }

                        Wall {
                            id: eastWall
                            width: items.wallSize
                            height: items.cellSize + items.wallSize
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: -items.wallSize / 2
                            anchors.rightMargin: -items.wallSize / 2
                            shadow: false
                            visible: value & Activity.EAST || (cell.highlighted && props.currentTool === Activity.TOOL_V_WALL)
                            z: 1
                        }

                        Wall {
                            id: southWall
                            width: items.cellSize + items.wallSize
                            height: items.wallSize
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: -items.wallSize / 2
                            anchors.leftMargin: -items.wallSize / 2
                            shadow: false
                            visible: value & Activity.SOUTH || (cell.highlighted && props.currentTool === Activity.SOUTH)
                            z: 1
                        }

                        Wall {
                            id: westWall
                            width: items.wallSize
                            height: items.cellSize + items.wallSize
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: -items.wallSize / 2
                            anchors.leftMargin: -items.wallSize / 2
                            shadow: false
                            visible: value & Activity.WEST
                            z: 1
                        }

                        BalanceItem {
                            id: goal
                            width: items.cellSize - items.wallSize
                            height: items.cellSize - items.wallSize
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: items.wallSize / 2
                            visible: value & Activity.GOAL || (cell.highlighted && props.currentTool === Activity.TOOL_GOAL)
                            z: 1
                            imageSource: Activity.baseUrl + "/door.svg"
                        }

                        BalanceItem {
                            id: hole
                            width: items.ball.width
                            height:items.ball.height
                            anchors.centerIn: parent
                            visible: value & Activity.HOLE || (cell.highlighted && props.currentTool === Activity.TOOL_HOLE)
                            z: 1
                            imageSource: Activity.baseUrl + "/hole.svg"
                        }

                        BalanceItem {
                            id: ball
                            width: items.ball.width
                            height:items.ball.height
                            anchors.centerIn: parent
                            visible: value & Activity.START || (cell.highlighted && props.currentTool === Activity.TOOL_BALL)
                            imageSource: Activity.baseUrl + "/ball.svg"
                            z: 1
                        }

                        BalanceContact {
                            id: contact
                            width: items.cellSize - items.wallSize
                            height: items.cellSize - items.wallSize
                            anchors.top: parent.top
                            anchors.margins: items.wallSize / 2
                            anchors.left: parent.left
                            visible: (orn > 0) || (cell.highlighted && props.currentTool === Activity.TOOL_CONTACT)
                            pressed: false
                            orderNum: orn
                            text: contactValue
                            z: 1
                        }

                        Rectangle {  // bounding rect
                            id: cellRect

                            width: items.cellSize
                            height: items.cellSize
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
        }
    }

    // The cancel button
    /*GCButtonCancel {
        onClose: {
            parent.close()
        }
    }*/

}
