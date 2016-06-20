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

/* TODOs
  1. add grid for first levels
  2. change images from png to svg
  */

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "white"

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
            id: grid
            columns: items.columns
            rows: items.rows
            z: 3
            anchors.fill: board

            Repeater {
                id: repeater

                Image {
                    id: figure
                    width: board.width/items.columns
                    height: board.height/items.rows

                    property bool showSelected: false
                    property alias selected: selected
                    property alias anim: anim
                    property alias opac: selected.opacity
                    property int distance
                    property int indexChange
                    property int startPoint
                    property string animationProperty
                    property int _index: index   // make current index accessible from outside

                    SequentialAnimation {
                        id: anim
                        PropertyAction { target: items; property: "ok"; value: "false"}
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint; to: figure.startPoint + distance; duration: 200 }
                        PropertyAction { target: figure; property: "opacity"; value: 0 }
                        PropertyAction { target: selected; property: "opacity"; value: 0 }
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint + distance; to: figure.startPoint; duration: 0; }
                        PropertyAction { target: figure; property: "opacity"; value: 1 }
                        PropertyAction { target: items.repeater.itemAt(items.selected + indexChange); property: "source"; value: figure.source }
                        PropertyAction { target: items.repeater.itemAt(items.selected + indexChange); property: "opac"; value: 1 }
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
                        onClicked: source != "" ? items.selected = index : undefined
                    }

                    // selected marker
                    Image {
                        id: selected
                        source: "resource/selected.png"
                        width: parent.width
                        height: parent.height
                        opacity: 0
                    }
                }
            }
        }

        Rectangle {
            id: modelBoard
            color: "pink"
            radius: width * 0.02

            anchors {
                left: background.portrait ? board.left : crane_vertical.right
                top: background.portrait ? crane_body.bottom : parent.top
                topMargin: background.portrait ? board.anchors.margins : crane_top.height * 1.5
                margins: board.anchors.margins
            }

            width: board.width
            height: board.height

            Grid {
                id: modelGrid
                columns: items.columns
                rows: items.rows

                Repeater {
                    id: modelRepeater

                    Image {
                        id: modelFigure
                        width: board.width/items.columns
                        height: board.height/items.rows
                    }
                }
            }
        }

        Image {
            id: crane_top
            source: "resource/crane_up.svg"
            sourceSize.width: background.portrait ? background.width * 0.8 : background.width * 0.5
            sourceSize.height: background.portrait ? background.height * 0.03 : background.height * 0.06
            width:  background.portrait ? background.width * 0.8 : background.width * 0.5
            height: background.portrait ? background.height * 0.03 : background.height * 0.06
            z: 3
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
            sourceSize.height: background.height * 0.73
            width: background.width * 0.05
            height: background.portrait ? background.height * 0.45 : background.height * 0.73
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
            sourceSize.width: parent.width / 6
            sourceSize.height: parent.height/ 4
            anchors {
                top: crane_vertical.bottom
                topMargin: - (height / 1.8)
                right: crane_vertical.right
                margins: board.anchors.margins
            }
        }

        Image {
            id: crane_wire
            source: "resource/crane-wire.svg"
            sourceSize.width: parent.width / 22
            sourceSize.height: parent.width / 17
            anchors {
                right: crane_body.left
                bottom: crane_command.verticalCenter
            }
        }

        Image {
            id: crane_command
            source: "resource/command.svg"
            sourceSize.width: parent.width / 4
            sourceSize.height: parent.height/ 3.5
            mirror: true
            anchors {
                top: crane_body.top
                bottom: crane_body.bottom
                right: crane_wire.left
                rightMargin: 0
                margins: board.anchors.margins
            }

            Controls {
                id: up
                source: "resource/arrow_up.svg"
                anchors {
                    left: parent.left
                    leftMargin: parent.width / 10
                }
                command: "up"
            }

            Controls {
                id: down
                source: "resource/arrow_down.svg"
                anchors {
                    left: up.right
                    leftMargin: parent.width / 20
                }
                command: "down"
            }

            Controls {
                id: left
                source: "resource/arrow_left.svg"
                anchors {
                    right: right.left
                    rightMargin: parent.width / 20
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
            height: convert.y
            x: convert.x + items.repeater.itemAt(items.selected).width / 2
            y: crane_top.height/2
            z: 1
            property var convert: items.repeater.mapToItem(background,items.repeater.itemAt(items.selected).x,items.repeater.itemAt(items.selected).y)

            Behavior on x {
                NumberAnimation { duration: 200 }
            }
            Behavior on height {
                NumberAnimation { duration: 200 }
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
