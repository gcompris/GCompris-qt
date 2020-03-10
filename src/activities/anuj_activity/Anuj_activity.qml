/* GCompris - anuj_activity.qml
 *
 * Copyright (C) 2018 Anuj Yadav <yadavanuj952@gmail.com>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import QtQuick.Controls 1.1

import "../../core"
import "anuj_activity.js" as Activity

ActivityBase {
    id: activity
    x: 0

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
            property alias header: header
            property alias rocket: rocket
            property alias mountain : mountain
            property alias launchbutton: launchbutton
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Rectangle {
            id: header
            width: parent.width
            height: headerText.height
            anchors.top: parent.top
            anchors.topMargin: 10
            border.width: 2
            border.color: "black"
            color: "blue"
            z: 5

            property alias headerText: headerText

            GCText {
                id: headerText
                anchors.centerIn: parent
                width: parent.width * 3 / 4
                fontSize: mediumSize
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Click on the button to shoot the ROCKET! and Click on Sun to change Time of Day !")
                color: "white"
            }
        }


                Image {
                    id : mountain
                source: "../anuj_activity/resource/mountain.png"
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height : parent.height * 0.8
              }



            Image {
                id: rocket
                x : 0
                y : 300
                width: 300
                height: 400
                source: "../anuj_activity/resource/anuj.svg"
                sourceSize.width: 300
            }

            BarButton {
                id: launchbutton
                x : 1400
                y : 1000
                width : 200
                height: 200
                anchors {
                    bottom: bar.top
                    rightMargin: 10
                }
                source: "../anuj_activity/resource/launch.svg"
                sourceSize.width: 200
                onClicked:   PropertyAnimation {
                    target: rocket
                    property: "x"
                    from : 0
                    to : background.width
                    duration: 2000
                    easing.type : Easing.OutInCubic
                    running: true
                }
            }

            Rectangle {
                id : sun
                width : 200
                height : 200
                x : 1500
                y : 175

                Image {
                    id : sunimage
                    source: "../anuj_activity/resource/sun.svg"
                    width : parent.width
                    height : parent.height
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: ParallelAnimation {

                        OpacityAnimator {
                              target: sun;
                              from: 1;
                              to: 0;
                              duration: 2000
                              running: true
                          }
                        PropertyAnimation {
                                            target: background
                                            property: "color"
                                            from : background.color
                                            to : "blue"
                                            duration: 2000
                                            running: true
                                        }
                    }

                }
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
