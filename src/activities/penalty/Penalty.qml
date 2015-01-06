/* GCompris - Penalty.qml
 *
 * Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
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
import "penalty.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "penalty_bg.svgz"
        sourceSize.width: parent.width
        fillMode: Image.Stretch
        anchors.fill: parent
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
            property alias ball: ball
            property alias progressLeft: progressLeft
            property alias progressRight: progressRight
            property alias progressTop: progressTop
            property alias bonus: bonus
            property int duration : 0
            property int progressBarOpacity : 40
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /* Instruction */
        GCText {
            id: instruction
            y: parent.height * 0.65
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 22
            color: "white"
            text: ""
            z: 99
        }

        /* The progress bars */
        Rectangle {
            id: progressLeft
            property int ratio: 0
            property ParallelAnimation anim: animationLeft

            opacity: items.progressBarOpacity
            anchors.left: parent.left
            anchors.leftMargin: parent.width / parent.implicitWidth * 62
            anchors.top: parent.top
            anchors.topMargin: parent.height / parent.implicitHeight * 100
            width: ratio / 100 * parent.width / parent.implicitWidth * 200
            height: parent.height / parent.implicitHeight * 20
            ParallelAnimation {
                id: animationLeft
                onRunningChanged: {
                    if (!animationLeft.running) {
                        timerBad.start()
                    }
                }
                PropertyAnimation
                {
                    target: progressLeft
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressLeft
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }

        Rectangle {
            id: progressRight
            property int ratio: 0
            property ParallelAnimation anim: animationRight

            opacity: items.progressBarOpacity
            anchors.right: parent.right
            anchors.rightMargin: parent.width/parent.implicitWidth * 50
            anchors.top: parent.top
            anchors.topMargin: parent.height/parent.implicitHeight * 100
            width: ratio / 100 * parent.width / parent.implicitWidth * 200
            height: parent.height / parent.implicitHeight * 20
            ParallelAnimation {
                id: animationRight
                onRunningChanged: {
                    if (!animationRight.running) {
                        timerBad.start()
                    }
                }
                PropertyAnimation
                {
                    target: progressRight
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressRight
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }

        Rectangle {
            id: progressTop
            property int ratio: 0
            property ParallelAnimation anim: animationTop

            opacity: items.progressBarOpacity
            anchors.top: parent.top
            anchors.topMargin: parent.width / parent.implicitWidth * 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.height / parent.implicitHeight * 20
            height: ratio / 100 * parent.width / parent.implicitWidth * 100
            ParallelAnimation {
                id: animationTop
                onRunningChanged: {
                    if (!animationTop.running) {
                        timerBad.start()
                    }
                }
                PropertyAnimation
                {
                    target: progressTop
                    property: "ratio"
                    from: 0
                    to: 100
                    duration: items.duration
                }
                PropertyAnimation
                {
                    target: progressTop
                    property: "color"
                    from: "#00FF00"
                    to: "#FF0000"
                    duration: items.duration
                }
            }
        }
        /* The player */
        Image {
            id: player
            source: Activity.url + "penalty_player.svgz"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            sourceSize.width: 154 * ApplicationInfo.ratio
            x: parent.width/2 - width/2

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
                onClicked: {
                    /* The ball is  on the initial place */
                    instruction.text = qsTr("Click twice on the ball to shoot it.")
                }
            }
        }

        /* The 2 click icon */
        Image {
            source: Activity.url + "click_icon.svgz"
            sourceSize.width: 90 * ApplicationInfo.ratio
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        /* The spot under the ball */
        Rectangle {
            radius: ball.width / 2
            color: "white"
            width: ball.width / 2
            height: ball.height / 3
            x: parent.width / 2 - width / 2
            y: parent.height * 0.77 + ball.height / 2 - height / 2
            border.width: 1
            border.color: "#b4b4b4"
        }

        /* The ball */
        Image {
            id: ball
            source: Activity.url + "penalty_ball.svgz"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 62 * ApplicationInfo.ratio

            Behavior on x { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on y { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }

            state: "INITIAL"
            states: [
                State {
                    name: "INITIAL"
                    PropertyChanges {
                        target: ball;
                        x: parent.width/2 - width/2;
                        y: parent.height*0.77 - height/2
                    }
                },
                State {
                    name: "RIGHT"
                    PropertyChanges {
                        target: ball;
                        x: background.width * 0.8;
                        y: background.height * 0.3
                    }
                },
                State {
                    name: "LEFT"
                    PropertyChanges {
                        target: ball;
                        x: background.width * 0.2;
                        y: background.height * 0.3
                    }
                },
                State {
                    name: "CENTER"
                    PropertyChanges {
                        target: ball;
                        x: parent.width/2 - width/2;
                        y: background.height * 0.1
                    }
                },
                State {
                    name: "FAIL"
                    PropertyChanges {
                        target: ball;
                        x: parent.width/2 - width/2;
                        y: player.y + player.height / 2
                    }
                }
            ]

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
                onClicked: {
                    instruction.text = ""

                    if(ball.state === "FAIL") {
                        Activity.resetLevel()
                        return
                    }

                    /* This is a shoot */
                    var progess = progressTop
                    if (mouse.button == Qt.LeftButton) {
                        progess = progressLeft
                    } else if (mouse.button == Qt.RightButton) {
                        progess = progressRight
                    }

                    if(progess.ratio > 0) {
                        /* Second click, stop animation */
                        progess.anim.running = false;

                        /* Play sound */
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")

                        /* Success or not */
                        if(progess.ratio < 100) {
                            /* Success */
                            if(progess === progressLeft) {
                                ball.state = "LEFT"
                            } else if(progess === progressRight) {
                                ball.state = "RIGHT"
                            } else {
                                ball.state = "CENTER"
                            }

                            timerGood.start()
                        } else {
                            /* failure */
                            ball.state = "FAIL"
                            timerBad.start()
                        }
                    } else {
                        /* First click, start animation*/
                        progess.anim.running = true;

                        /* Play sound */
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/flip.wav")
                    }
                }
            }
        }

        Timer {
            id: timerGood
            interval: 1500
            onTriggered: bonus.good("tux")
        }

        Timer {
            id: timerBad
            interval: 1500
            onTriggered: bonus.bad("tux")
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
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }
    }

}
