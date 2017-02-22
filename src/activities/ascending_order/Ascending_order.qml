/* GCompris - ascending_order.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "ascending_order.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}


    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "resource/background.svg"
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
            property alias boxes: boxes
            property alias ansText: ansText
            property alias flow: flow
            property alias container: container
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            id: ansText
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            text: ""
            font.pixelSize: 40
        }

        GCText {
            id: instruction
            wrapMode: TextEdit.WordWrap
            fontSize: tinySize
            anchors.horizontalCenter: parent.horizontalCenter
//            width: parent.width * 0.9
            text: "Arrange the given numbers in ascending order"
            color: 'white'
            Rectangle {
                z: -1
                opacity: 0.8
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                radius: 10
                border.color: 'black'
                border.width: 1
                anchors.centerIn: parent
                width: parent.width * 1.1
                height: parent.contentHeight
            }
        }

        Rectangle {
            id: container
            color: "transparent"
//            width: parent.width
            width: Math.min(parent.width, ((boxes.itemAt(0)).width*boxes.model)+(boxes.model-1)*flow.spacing)
            height: parent.height/2

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Flow {
//                anchors.fill: parent
//                anchors.margins: 4
                id: flow
                spacing: 10

                /*
                property int rowCount : parent.width / (boxes .itemAt(0).width + spacing )
                property int rowWidth: rowCount * boxes.itemAt(0).width + (rowCount-1)*spacing
                property int margin: (parent.width - rowWidth)/2
                */
                anchors {
//                    horizontalCenter: parent.horizontalCenter
//                    verticalCenter: parent.verticalCenter
                    fill: parent
//                    margins: margin
//                    leftMargin: margin
//                    rightMargin: margin
                }
                Repeater {
                    id: boxes
                    model: 6
                    Rectangle {
                        id: box
                        color: selected ? "lightblue" : "white"
                        z: mouseArea.drag.active ||  mouseArea.pressed ? 2 : 1
                        property bool selected: false
                        property int imageX: 0
                        property int pos
                        property bool animateVert: false
                        property bool animateHor: false
                        property real currentPos
                        property point beginDrag
                        property real screen_ratio : Math.min(Math.max(background.width, background.height)/800 , Math.min(background.width, background.height)/520)
                        /*
                        width: 88 * ApplicationInfo.ratio
                        height: 88 * ApplicationInfo.ratio
                        */
                        width: 65 * screen_ratio
                        height: 65 * screen_ratio//88
                        radius: 10
                        border{
                            color: "black"
//                            width: 5 * ApplicationInfo.ratio
                            width: 3 * screen_ratio
                        }
                        GCText {
                            id: numText
                            anchors.centerIn: parent
                            text: imageX.toString()
                            font.pointSize: 20 * screen_ratio
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            drag.target: parent
                            onPressed: {
                                box.beginDrag = Qt.point(box.x, box.y)
                            }
                            onPressAndHold: {
                            }
                            onReleased: {
                                Activity.placeBlock(box, box.beginDrag);
                            }
                        }
                        Behavior on color {
                            PropertyAnimation {
                                duration: 300
                                easing.type: Easing.InOutBack
                            }
                        }
                        Behavior on x {
                            ParallelAnimation {
                                PropertyAnimation {
                                    duration: 500
                                    easing.type: Easing.InOutBack
                                }
                            }
                        }
                        Behavior on y {
                            ParallelAnimation {
                                PropertyAnimation {
                                    duration: 500
                                    easing.type: Easing.InOutBack
                                }
                            }
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
          id: ok
          source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
          sourceSize.width: 75 * ApplicationInfo.ratio
          visible: true
          anchors {
              right: parent.right
              bottom: parent.bottom
              bottomMargin: 10 * ApplicationInfo.ratio
              rightMargin: 10 * ApplicationInfo.ratio
          }
          onClicked: Activity.checkOrder()
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
