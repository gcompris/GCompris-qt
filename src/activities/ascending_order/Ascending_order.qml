/* GCompris - ascending_order.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
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
            property alias flow: flow
            property alias container: container
            property real ratio: ApplicationInfo.ratio
            property Score score: score
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            id: instruction
            wrapMode: TextEdit.WordWrap
            fontSize: tinySize
            horizontalAlignment: Text.Center
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            text: qsTr("Drag and drop the numbers in correct position in Ascending order")
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
            width: Math.min(parent.width, ((boxes.itemAt(0)).width*boxes.model)+(boxes.model-1)*flow.spacing)
            height: parent.height/2

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Flow {
                id: flow
                spacing: 10

                /*
                 * Count number of active animations in the activity
                 * at this current time
                 * (No input will be taken at this time)
                 */
                property int onGoingAnimationCount: 0
                property bool validMousePress
                anchors {
                    fill: parent
                }
                Repeater {
                    id: boxes
                    model: 6
                    Rectangle {
                        id: box
                        color: "white"
                        z: mouseArea.drag.active ||  mouseArea.pressed ? 2 : 1
                        property int boxValue: 0
                        property point beginDragPosition

                        width: 65 * ApplicationInfo.ratio
                        height: 65 * ApplicationInfo.ratio
                        radius: 10
                        border{
                            color: "black"
                            width: 3 * ApplicationInfo.ratio
                        }
                        GCText {
                            id: numText
                            anchors.centerIn: parent
                            text: boxValue.toString()
                            font.pointSize: 20 * ApplicationInfo.ratio
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            drag.target: parent
                            enabled: (flow.onGoingAnimationCount == 0 && flow.validMousePress == true) ? true : false
                            onPressed: {
                                box.beginDragPosition = Qt.point(box.x, box.y)
                            }
                            onReleased: {
                                Activity.placeBlock(box, box.beginDragPosition);
                            }
                        }
                        Behavior on x {
                            PropertyAnimation {
                                id: animationX
                                duration: 500
                                easing.type: Easing.InOutBack
                                onRunningChanged: {
                                    if(animationX.running) {
                                        flow.onGoingAnimationCount++
                                    } else {
                                        flow.onGoingAnimationCount--
                                    }
                                }
                            }
                        }
                        Behavior on y {
                            PropertyAnimation {
                                id: animationY
                                duration: 500
                                easing.type: Easing.InOutBack
                                onRunningChanged: {
                                    if(animationY.running) {
                                        flow.onGoingAnimationCount++
                                    } else {
                                        flow.onGoingAnimationCount--
                                    }
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
              bottom: bar.top
              bottomMargin: 10 * ApplicationInfo.ratio
              rightMargin: 10 * ApplicationInfo.ratio
          }
          onClicked: Activity.checkOrder()
        }

        Score {
            id: score
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
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
