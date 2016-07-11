/* GCompris - Crane.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
import "crane.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffeecc"

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
            property alias board: board
            property alias grid: grid
            property alias repeater: repeater
            property alias modelRepeater: modelRepeater
            property alias gridRepeater: gridRepeater
            property alias showGrid1: showGrid1
            property int selected
            property int columns
            property int rows
            property bool ok: true
            property int sensivity: 80
            property bool gameFinished: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool portrait: height > width ? true : false
        property bool inLine: true

        Keys.onPressed: {
            if (event.key === Qt.Key_Left)
                Activity.move("left")
            else if (event.key === Qt.Key_Right)
                Activity.move("right")
            else if (event.key === Qt.Key_Up)
                Activity.move("up")
            else if (event.key === Qt.Key_Down)
                Activity.move("down")
            else if (event.key === Qt.Key_Space ||
                     event.key === Qt.Key_Tab ||
                     event.key === Qt.Key_Enter ||
                     event.key === Qt.Key_Return)
                Activity.move("next")
        }

        //implementation of Swipe effect
        MouseArea {
            anchors.fill: parent
            property int startX;
            property int startY;

            onPressed: {
                startX = mouse.x;
                startY = mouse.y;
            }
            onReleased: Activity.gesture(mouse.x - startX, mouse.y - startY)
        }

        Rectangle {
            id: board
            color: "lightblue"
            radius: width * 0.02
            z: 1

            anchors {
                verticalCenter: crane_vertical.verticalCenter
                right: crane_vertical.left
                margins: 15
            }

            width: background.portrait ? parent.width * 0.65 : ((parent.width - anchors.margins * 3 - crane_vertical.width) / 2 ) * 0.9
            height: background.portrait ? (parent.height - bar.height * 1.45 - crane_top.height - crane_body.height ) / 2 :
                                          (parent.height - bar.height * 1.45 - crane_top.height - crane_body.height) * 0.9

        }

        Grid {
            id: showGrid1
            columns: items.columns
            rows: items.rows
            z: 1
            anchors.fill: board
            Repeater {
                id: gridRepeater

                Rectangle {
                    width: board.width/items.columns
                    height: board.height/items.rows
                    color: "transparent"
                    border.width: 2
                    border.color: "grey"
                }
            }
        }

        Rectangle {
            id: coverEgdes1
            color: "transparent"
            width: board.width
            height: board.height
            border.color: board.color
            border.width: 10
            opacity: showGrid1.opacity
            anchors.centerIn: board
            z: 3
        }

        Grid {
            id: grid
            columns: items.columns
            rows: items.rows
            z: 4
            anchors.fill: board

            Repeater {
                id: repeater

                Image {
                    id: figure
                    sourceSize.height: board.width/items.columns
                    sourceSize.width: board.height/items.rows
                    width: board.width/items.columns
                    height: board.height/items.rows

                    property int initialIndex: -1

                    property alias anim: anim
                    property int distance
                    property int indexChange
                    property int startPoint
                    property string animationProperty
                    property int _index: index // make current index accessible from outside

                    SequentialAnimation {
                        id: anim
                        PropertyAction { target: items; property: "ok"; value: "false"}
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint; to: figure.startPoint + distance; duration: 200 }
                        PropertyAction { target: figure; property: "opacity"; value: 0 }
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint + distance; to: figure.startPoint; duration: 0; }
                        PropertyAction { target: figure; property: "opacity"; value: 1 }
                        PropertyAction { target: items.repeater.itemAt(items.selected + indexChange); property: "source"; value: figure.source }
                        PropertyAction { target: items.repeater.itemAt(items.selected + indexChange); property: "initialIndex"; value: figure.initialIndex }
                        PropertyAction { target: figure; property: "initialIndex"; value: -1 }
                        PropertyAction { target: figure; property: "source"; value: "" }
                        PropertyAction { target: items; property: "ok"; value: "true"}
                        ScriptAction { script: Activity.checkAnswer() }
                    }

                    MouseArea {
                        anchors.fill: parent

                        // Swipe effect
                        property int startX;
                        property int startY;

                        onPressed: {
                            startX = mouse.x;
                            startY = mouse.y;
                        }

                        onReleased:
                            Activity.gesture(mouse.x - startX, mouse.y - startY)

                        // Select a figure with mouse/touch
                        onClicked: {
                            if (source != "")
                                items.selected = index
                        }
                    }
                }
            }
        }

        Image {
            id: selected
            source: "resource/selected.png"
            sourceSize.width: board.width/items.columns
            sourceSize.height: board.height/items.rows
            width: board.width/items.columns
            height: board.height/items.rows
            opacity: 1

            property var newCoord: items.selected == 0 ? grid :
                                                         items.repeater.mapToItem(background,items.repeater.itemAt(items.selected).x,
                                                                                  items.repeater.itemAt(items.selected).y)
            x: newCoord.x
            y: newCoord.y
            z: 100

            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }

        }

        Rectangle {
            id: modelBoard
            color: "pink"
            radius: width * 0.02
            z: 1

            anchors {
                left: background.portrait ? board.left : crane_vertical.right
                top: background.portrait ? crane_body.bottom : background.inLine ? board.top : parent.top
                topMargin: background.portrait ? board.anchors.margins : background.inLine ? 0 : crane_top.height * 1.5
                leftMargin: background.portrait ? 0 : board.anchors.margins * 1.2
                margins: board.anchors.margins
            }

            width: board.width
            height: board.height
        }

        Grid {
            id: modelGrid
            columns: items.columns
            rows: items.rows
            anchors.fill: modelBoard
            z: 4

            Repeater {
                id: modelRepeater

                Image {
                    id: modelFigure
                    sourceSize.height: board.height/items.rows
                    sourceSize.width: board.width/items.columns
                    width: board.width/items.columns
                    height: board.height/items.rows
                }
            }
        }

        Grid {
            id: showGrid2
            columns: items.columns
            rows: items.rows
            z: 1
            opacity: showGrid1.opacity
            anchors.fill: modelBoard
            Repeater {
                id: gridRepeater2
                model: gridRepeater.model

                Rectangle {
                    width: modelBoard.width/items.columns
                    height: modelBoard.height/items.rows
                    color: "transparent"
                    border.width: 2
                    border.color: showGrid1.opacity == 1 ? "grey" : "transparent"
                }
            }
        }

        Rectangle {
            id: coverEgdes2
            color: "transparent"
            width: modelBoard.width
            height: modelBoard.height
            border.color: showGrid1.opacity == 1 ? modelBoard.color : "transparent"
            border.width: 10
            anchors.centerIn: modelBoard
            opacity: showGrid1.opacity
            z: 3
        }

        Image {
            id: crane_top
            source: "resource/crane_up.svg"
            sourceSize.width: background.portrait ? background.width * 0.8 : background.width * 0.5
            sourceSize.height: background.portrait ? background.height * 0.03 : background.height * 0.06
            width: background.portrait ? background.width * 0.8 : background.width * 0.5
            height: background.portrait ? background.height * 0.03 : background.height * 0.06
            z: 4
            anchors {
                top: parent.top
                right: crane_vertical.right
                rightMargin: 0
                margins: board.anchors.margins
            }
        }

        Image {
            id: crane_vertical
            source: "resource/crane_vertical.svg"
            sourceSize.width: background.width * 0.04
            sourceSize.height: background.portrait ? background.height * 0.5 : background.height * 0.73
            width: background.width * 0.05
            height: background.portrait ? background.height * 0.5 : background.height * 0.73
            anchors {
                top: crane_top.top
                right: background.portrait ? parent.right : parent.horizontalCenter
                rightMargin: background.portrait ? width / 2 : - width / 2
                topMargin: board.anchors.margins
            }
        }

        Image {
            id: crane_body
            source: "resource/crane_only.svg"
            z: 2
            sourceSize.width: parent.width / 5
            sourceSize.height: parent.height/ 3.6
            mirror: background.portrait ? true : false
            anchors {
                top: crane_vertical.bottom
                topMargin: - (height / 1.8)
                right: crane_vertical.right
                rightMargin: background.portrait ? board.anchors.margins : - crane_body.width + crane_vertical.width
                margins: board.anchors.margins
            }
        }

        Image {
            id: crane_wire
            source: "resource/crane-wire.svg"
            z: 1
            sourceSize.width: parent.width / 22
            sourceSize.height: parent.width / 17
            anchors {
                right: crane_body.left
                bottom: crane_command.verticalCenter
                rightMargin: -10
                bottomMargin: -10
            }
        }

        Image {
            id: crane_command
            source: "resource/command.svg"
            sourceSize.width: background.portrait ? parent.width / 2.7 : parent.width / 3.5
            sourceSize.height: background.portrait ? parent.height / 3.5 :  parent.height / 4

            width: background.portrait ? parent.width / 2.7 : parent.width / 3.5
            height: background.portrait ? parent.height / 3.5 :  parent.height / 4

            mirror: true

            anchors {
                top: crane_body.top
                bottom: crane_body.bottom
                right: crane_wire.left
                rightMargin: 0
                topMargin: background.portrait ? 0 : board.anchors.margins * 1.5
                bottomMargin: background.portrait ? 0 : board.anchors.margins * 1.5
            }

            Controls {
                id: up
                source: "resource/arrow_up.svg"
                anchors {
                    left: parent.left
                    leftMargin: parent.width / 13
                }
                command: "up"
            }

            Controls {
                id: down
                source: "resource/arrow_down.svg"
                anchors {
                    left: up.right
                    leftMargin: parent.width / 30
                }
                command: "down"
            }

            Controls {
                id: left
                source: "resource/arrow_left.svg"
                anchors {
                    right: right.left
                    rightMargin: parent.width / 30
                }
                command: "left"
            }

            Controls {
                id: right
                source: "resource/arrow_right.svg"
                anchors {
                    right: parent.right
                    rightMargin: parent.width / 10
                }
                command: "right"
            }
        }

        Rectangle {
            id: cable
            color: "black"
            width: 5
            height: convert.y - crane_top.y
            x: convert.x + board.width / items.columns / 2
            z: 3
            anchors.top: crane_top.top
            anchors.topMargin: 10

            property var convert: items.selected == 0 ? grid :
                items.repeater.mapToItem(background,items.repeater.itemAt(items.selected).x,
                                         items.repeater.itemAt(items.selected).y)

            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on height { NumberAnimation { duration: 200 } }
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
