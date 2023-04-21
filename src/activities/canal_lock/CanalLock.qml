/* GCompris - canal_lock.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/canal_lock/resource/"

    pageComponent: Image {
        id: background
        source: activity.url + "sky.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height

        property int running: 0

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: message

        IntroMessage {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            intro: [
                qsTr("Your goal is to lead Tux across the canal lock to get the wooden logs, "
                     +"using the different types of water locks available."),
                qsTr("The vertical colored bars represent the water locks, which can be operated by clicking on them. "
                     +"Two locks of the same type cannot be operated simultaneously.") ,
                qsTr("The water level inside the lock will change according to the side of the canal it is "
                     +"connected to. Use this property to help Tux get the job done.")
            ]
        }

        onStart: water.state = 'down'

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

        Rectangle {
            color: "#805451"
            anchors.left: background.left
            anchors.right: background.right
            anchors.top: canal.bottom
            anchors.topMargin: -boat.leftPositionY
            anchors.bottom: background.bottom
        }

        Item {
            id: canalArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bar.top
        }

        Image {
            id: canal
            source: activity.url + "canal_lock.svg"
            anchors.centerIn: canalArea
            height: canalArea.height
            width: canalArea.width
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit

            Image {
                id: canalLeft
                source: activity.url + "canal_left.svg"
                anchors.top: canal.top
                anchors.left: canal.left
                width: (background.width - parent.paintedWidth) / 2 + 1
                height: parent.height
                sourceSize.height: height
                fillMode: Image.TileHorizontally
            }

            Image {
                source: activity.url + "canal_right.svg"
                anchors.top: canal.top
                anchors.right: parent.right
                width: canalLeft.width
                height: parent.height
                sourceSize.height: height
                fillMode: Image.TileHorizontally
            }

            Rectangle {
                id: water
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.23
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.paintedWidth * 0.035
                color: "#4f76d6"
                width: parent.paintedWidth * 0.205
                height: minHeight
                state: "undef"

                property int maxHeight: canal.paintedHeight * 0.328
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
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.03
                anchors.horizontalCenterOffset: - canal.paintedWidth * 0.16
                minHeight: canal.paintedHeight * 0.05
                maxHeight: canal.paintedHeight * 0.18
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
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.03
                anchors.horizontalCenterOffset: canal.paintedWidth * 0.22
                minHeight: canal.paintedHeight * 0.05
                maxHeight: canal.paintedHeight * 0.18
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
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.2
                anchors.horizontalCenterOffset: - canal.paintedWidth * 0.07
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
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.2
                anchors.horizontalCenterOffset: canal.paintedWidth * 0.14
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
                anchors.bottom: canal.bottom
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.46
                anchors.horizontalCenter: canal.horizontalCenter
                anchors.horizontalCenterOffset: - canal.paintedWidth * 0.18
                sourceSize.height: canal.paintedHeight * 0.1

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
                anchors.bottom: canal.bottom
                anchors.bottomMargin: (canal.height - canal.paintedHeight) / 2 +
                                      canal.paintedHeight * 0.60
                anchors.horizontalCenter: canal.horizontalCenter
                anchors.horizontalCenterOffset: canal.paintedWidth * 0.20
                sourceSize.height: canal.paintedHeight * 0.1
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
                    bottom: canal.bottom
                    bottomMargin: leftPositionY
                    horizontalCenter: canal.horizontalCenter
                    horizontalCenterOffset: leftPositionX

                    onHorizontalCenterOffsetChanged: {
                        if(boat.anchors.horizontalCenterOffset == boat.rightPositionX &&
                            boat.source == activity.url + "boat1.svg") {
                            boat.source = activity.url + "boat2.svg"
                            bonus.good("flower")
                        } else if(boat.anchors.horizontalCenterOffset == boat.leftPositionX) {
                            boat.source = activity.url + "boat1.svg"
                        }
                    }
                }
                state: 'left'

                property int leftPositionX: - (canal.paintedWidth / 2) * 0.8
                property int leftPositionY: (canal.height - canal.paintedHeight) / 2 +
                                            canal.paintedHeight * 0.37
                property int middlePositionX: canal.paintedWidth * 0.035
                property int rightPositionX: (canal.paintedWidth / 2) * 0.7
                property int rightPositionY: (canal.height - canal.paintedHeight) / 2 +
                                            canal.paintedHeight * 0.55
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
                        if(boat.state == "left" && door1.opened)
                            boat.state = "middleDown"
                        else if(boat.state == "middleUp" && door2.opened)
                            boat.state = "right"
                        else if(boat.state == "right" && door2.opened)
                            boat.state = "middleUp"
                        else if(boat.state == "middleDown" && door1.opened)
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
            onHomeClicked: home();
        }

        Bonus {
            id: bonus
        }
    }

}
