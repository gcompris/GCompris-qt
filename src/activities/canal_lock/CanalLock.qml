/* GCompris - canal_lock.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/canal_lock/resource/"

    pageComponent: Item {
        id: background
        anchors.fill: parent

        property int running: 0

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: water.state = 'down'

        Image {
            id: sky
            source: activity.url + "sky.svg"
            sourceSize.width: parent.width
            anchors.top: parent.top
            height: (background.height - canal.paintedHeight) / 2 + canal.paintedHeight * 0.6
        }

        Image {
            source: activity.url + "sun.svg"
            sourceSize.width: Math.min(120 * ApplicationInfo.ratio, parent.width * 0.15)
            x: 10
            y: 10
        }

        Image {
            source: activity.url + "cloud1.svg"
            sourceSize.width: Math.min(120 * ApplicationInfo.ratio, parent.width * 0.15)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.18
            anchors.topMargin: parent.height * 0.1
        }

        Image {
            source: activity.url + "cloud2.svg"
            sourceSize.width: Math.min(130 * ApplicationInfo.ratio, parent.width * 0.2)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.25
            anchors.topMargin: parent.height * 0.02
        }

        Image {
            source: activity.url + "ground.svg"
            sourceSize.width: parent.width
            anchors.bottom: parent.bottom
            height: (background.height - canal.paintedHeight) / 2 + canal.paintedHeight * 0.3
        }

        Image {
            id: canal
            source: activity.url + "canal_lock.svg"
            anchors.fill: parent
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit

            Image {
                source: activity.url + "canal_left.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: (background.width - parent.paintedWidth) / 2 + 1
                sourceSize.height: parent.paintedHeight
            }

            Image {
                source: activity.url + "canal_right.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: (background.width - parent.paintedWidth) / 2 + 1
                sourceSize.height: parent.paintedHeight
            }

            Rectangle {
                id: water
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.23
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.paintedWidth * 0.035
                color: "#4f76d6"
                width: parent.paintedWidth * 0.205
                height: minHeight
                state: "undef"

                property int maxHeight: parent.paintedHeight * 0.33
                property int minHeight: canal.paintedHeight * 0.15
                property int duration: 3500

                Behavior on height { NumberAnimation { duration: water.duration } }

                onStateChanged: {
                    if( water.state == "undef")
                        return
                    activity.audioEffects.play(activity.url + 'water_fill.wav')
                    if( water.state == 'up' && boat.state == 'middleDown')
                        boat.state = 'middleUp'
                    else if( water.state == 'down' && boat.state == 'middleUp')
                        boat.state = 'middleDown'
                }

                states: [
                    State {
                        name: "undef"
                        PropertyChanges { target: water; height: water.minHeight}
                    },
                    State {
                        name: "down"
                        PropertyChanges { target: water; height: water.minHeight}
                    },
                    State {
                        name: "up"
                        PropertyChanges { target: water; height: water.maxHeight}
                    }
                ]
            }

            Lock {
                id: lock1
                color: "#dfb625"
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.03
                anchors.horizontalCenterOffset: - parent.paintedWidth * 0.16
                minHeight: canal.paintedHeight * 0.05
                maxHeight: parent.paintedHeight * 0.18
                duration: 0

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -20 * ApplicationInfo.ratio
                    onClicked: {
                        if(background.running)
                            return
                        lock1.duration = 400
                        if(lock1.state == 'close' &&
                                door2.state == 'close' &&
                                lock2.state == 'close') {
                            activity.audioEffects.play(activity.url + 'lock.wav')
                            lock1.state = 'open'
                            water.state = 'down'
                        } else if(lock1.state == 'open') {
                            activity.audioEffects.play(activity.url + 'lock.wav')
                            lock1.state = 'close'
                        } else {
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                        }
                    }
                }

            }

            Lock {
                id: lock2
                color: "#dfb625"
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.03
                anchors.horizontalCenterOffset: parent.paintedWidth * 0.22
                minHeight: canal.paintedHeight * 0.05
                maxHeight: parent.paintedHeight * 0.18
                duration: 0

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -20 * ApplicationInfo.ratio
                    onClicked: {
                        if(background.running)
                            return
                        lock2.duration = lock1.duration
                        if(lock2.state == 'close' &&
                                door1.state == 'close' &&
                                lock1.state == 'close') {
                            activity.audioEffects.play(activity.url + 'lock.wav')
                            lock2.state = 'open'
                            water.state = 'up'
                        } else if(lock2.state == 'open') {
                            activity.audioEffects.play(activity.url + 'lock.wav')
                            lock2.state = 'close'
                        } else {
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                        }
                    }
                }

            }

            Lock {
                id: door1
                color: "#31cb25"
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.2
                anchors.horizontalCenterOffset: - parent.paintedWidth * 0.07
                minHeight: canal.paintedHeight * 0.05
                maxHeight: canal.paintedHeight * 0.4
                duration: 0

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -20 * ApplicationInfo.ratio
                    onClicked: {
                        if(background.running)
                            return
                        door1.duration = water.duration
                        if(door1.state == 'close' &&
                                water.state == 'down') {
                            door1.state = 'open'
                            leftLight.state = 'green'
                            activity.audioEffects.play(activity.url + 'door_open.wav')
                        } else if(door1.state == 'open') {
                            door1.state = 'close'
                            leftLight.state = 'red'
                            activity.audioEffects.play(activity.url + 'door_close.wav')
                        } else {
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                        }
                    }
                }
            }

            Lock {
                id: door2
                color: "#31cb25"
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.2
                anchors.horizontalCenterOffset: parent.paintedWidth * 0.14
                minHeight: canal.paintedHeight * 0.15
                maxHeight: canal.paintedHeight * 0.4
                duration: 0

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -20 * ApplicationInfo.ratio
                    onClicked: {
                        if(background.running)
                            return
                        door2.duration = water.duration
                        if(door2.state == 'close' &&
                                water.state == 'up') {
                            door2.state = 'open'
                            rightLight.state = 'green'
                            activity.audioEffects.play(activity.url + 'door_open.wav')
                        } else if(door2.state == 'open') {
                            door2.state = 'close'
                            rightLight.state = 'red'
                            activity.audioEffects.play(activity.url + 'door_close.wav')
                        } else {
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                        }
                    }
                }
            }

            Image {
                id: leftLight
                source: activity.url + "light_red.svg"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.46
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: - parent.paintedWidth * 0.18
                sourceSize.height: parent.paintedHeight * 0.1

                states: [
                    State {
                        name: "green"
                        PropertyChanges {
                            target: leftLight
                            source: activity.url + "light_green.svg"
                        }
                    },
                    State {
                        name: "red"
                        PropertyChanges {
                            target: leftLight
                            source: activity.url + "light_red.svg"
                        }
                    }
                ]
            }

            Image {
                id: rightLight
                source: activity.url + "light_red.svg"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (background.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.60
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.paintedWidth * 0.20
                sourceSize.height: parent.paintedHeight * 0.1
                mirror: true

                states: [
                    State {
                        name: "green"
                        PropertyChanges {
                            target: rightLight
                            source: activity.url + "light_green.svg"
                        }
                    },
                    State {
                        name: "red"
                        PropertyChanges {
                            target: rightLight
                            source: activity.url + "light_red.svg"
                        }
                    }
                ]
            }

            Image {
                id: boat
                source: activity.url + "boat1.svg"
                sourceSize.width: water.width * 0.74
                anchors {
                    bottom: parent.bottom
                    bottomMargin: leftPositionY
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: leftPositionX

                    onHorizontalCenterOffsetChanged: {
                        if(boat.anchors.horizontalCenterOffset == boat.rightPositionX) {
                            boat.source = activity.url + "boat2.svg"
                            bonus.good("flower")
                        } else if(boat.anchors.horizontalCenterOffset == boat.leftPositionX) {
                            boat.source = activity.url + "boat1.svg"
                        }
                    }
                }
                state: 'left'

                property int leftPositionX: - (parent.paintedWidth / 2) * 0.8
                property int leftPositionY: (background.height - canal.paintedHeight) / 2 +
                                            canal.paintedHeight * 0.37
                property int middlePositionX: canal.paintedWidth * 0.035
                property int rightPositionX: (parent.paintedWidth / 2) * 0.7
                property int rightPositionY: (background.height - canal.paintedHeight) / 2 +
                                            canal.paintedHeight * 0.55 // > 0.5  < 0.6
                property int duration: 0

                Behavior on anchors.horizontalCenterOffset {
                    NumberAnimation {
                        duration: boat.duration
                        onRunningChanged: background.running ? background.running++ : background.running--
                    }
                }
                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: boat.duration
                        onRunningChanged: background.running ? background.running++ : background.running--
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(background.running)
                            return
                        boat.duration = water.duration
                        var prevState = boat.state
                        if(boat.state == "left" && door1.state == "open")
                            boat.state = "middleDown"
                        else if(boat.state == "middleUp" && door2.state == "open")
                            boat.state = "right"
                        else if(boat.state == "right" && door2.state == "open")
                            boat.state = "middleUp"
                        else if(boat.state == "middleDown" && door1.state == "open")
                            boat.state = "left"

                        if(prevState !== boat.state)
                            activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/water.wav')

                    }
                }

                states: [
                    State {
                        name: "left"
                        PropertyChanges {
                            target: boat
                            anchors.horizontalCenterOffset: boat.leftPositionX
                            anchors.bottomMargin: boat.leftPositionY
                        }
                    },
                    State {
                        name: "middleDown"
                        PropertyChanges {
                            target: boat
                            anchors.horizontalCenterOffset: boat.middlePositionX
                            anchors.bottomMargin: boat.leftPositionY
                        }
                    },
                    State {
                        name: "middleUp"
                        PropertyChanges {
                            target: boat
                            anchors.horizontalCenterOffset: boat.middlePositionX
                            anchors.bottomMargin: boat.rightPositionY
                        }
                    },
                    State {
                        name: "right"
                        PropertyChanges {
                            target: boat
                            anchors.horizontalCenterOffset: boat.rightPositionX
                            anchors.bottomMargin: boat.rightPositionY
                        }
                    }
                ]
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
        }
    }

}
