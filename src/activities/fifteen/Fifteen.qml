/* GCompris - fifteen.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

import "../../core"
import "fifteen.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Keys.onPressed: Activity.processPressedKey(event)

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
            property alias model: fifteenModel
            property string scene: bar.level < 5 ? Activity.url + "Fishing_Boat_Scene.svg" :
                                                   Activity.url + "Coastal_Path.svg"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            source: Activity.url + "goldframe.svg"
            sourceSize.width: Math.min(background.width * 0.9,
                                       background.height * 0.9)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            columns: 4
            spacing: 0

            ListModel {
                id: fifteenModel
            }


            move: Transition {
                NumberAnimation {
                    properties: "x, y"
                    easing.type: Easing.InOutQuad
                }
            }

            Repeater {
                id: repeater
                model: fifteenModel
                delegate: Item {
                    width: Math.min(background.width * 0.2,
                                    background.height * 0.2)
                    height: width
                    clip: true

                    Image {
                        id: image
                        source: value ? items.scene : ""
                        sourceSize.width: parent.width * 4
                        fillMode: Image.Pad
                        transform: Translate {
                            x: - image.width / 4 * ((value - 1) % 4)
                            y: - image.width / 4 * Math.floor((value - 1) / 4)
                        }
                    }

                    GCText {
                        id: text
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text: value && bar.level % 2 == 1 ? value : ""
                        font.pointSize: 16
                    }

                    DropShadow {
                        anchors.fill: text
                        cached: true
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        samples: 16
                        color: "#80000000"
                        source: text
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Activity.onClick(value)
                            if(Activity.checkAnswer())
                                bonus.good('flower')
                        }
                    }
                }
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
