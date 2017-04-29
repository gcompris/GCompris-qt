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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "penalty.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "penalty_bg.svg"
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
        Item {
            id: instruction
            z: 99
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.9
            property alias text: instructionTxt.text
            visible: bar.level === 1 && text != ""

            GCText {
                id: instructionTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                fontSize: mediumSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: TextEdit.WordWrap
                z: 2
            }

            Rectangle {
                anchors.fill: instructionTxt
                z: 1
                opacity: 0.8
                radius: 10
                border.width: 2
                border.color: "black"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
            }
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
                        timerBonus.start()
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
                        timerBonus.start()
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
                        timerBonus.start()
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
            source: Activity.url + "penalty_player.svg"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            sourceSize.width: 154 * ApplicationInfo.ratio
            x: parent.width/2 - width/2
        }

        /* The 2 click icon */
        Image {
            source: Activity.url + "click_icon.svg"
            sourceSize.width: 90 * ApplicationInfo.ratio
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        /* The spot under the ball */
        Rectangle {
            radius: 100 * ApplicationInfo.ratio
            color: "white"
            width: 50 * ApplicationInfo.ratio
            height: 33 * ApplicationInfo.ratio
            x: parent.width / 2 - width / 2
            y: parent.height * 0.77 + width - height / 2
            border.width: 1
            border.color: "#b4b4b4"
        }

        /* The ball */
        Image {
            id: ball
            source: Activity.url + "penalty_ball.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 100 * ApplicationInfo.ratio

            Behavior on x { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on y { PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000} }
            Behavior on sourceSize.width { PropertyAnimation {easing.type: Easing.OutQuad; duration: 1000} }

            state: "INITIAL"
            states: [
                State {
                    name: "INITIAL"
                    PropertyChanges {
                        target: ball;
                        sourceSize.width: 100 * ApplicationInfo.ratio
                        x: parent.width/2 - width/2;
                        y: parent.height*0.77 - height/2
                    }
                    PropertyChanges {
                        target: instruction
                        text: qsTr("Double click or double tap on the ball to kick it.")
                    }
                },
                State {
                    name: "RIGHT"
                    PropertyChanges {
                        target: ball;
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: background.width * 0.8;
                        y: background.height * 0.3
                    }
                },
                State {
                    name: "LEFT"
                    PropertyChanges {
                        target: ball;
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: background.width * 0.2;
                        y: background.height * 0.3
                    }
                },
                State {
                    name: "CENTER"
                    PropertyChanges {
                        target: ball;
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: parent.width/2 - width/2;
                        y: background.height * 0.1
                    }
                },
                State {
                    name: "FAIL"
                    PropertyChanges {
                        target: ball;
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: parent.width/2 - width/2;
                        y: player.y + player.height / 2
                    }
                    PropertyChanges {
                        target: instruction
                        text: qsTr("Click or tap the ball to bring it back to its former position")
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
                    var progress = progressTop
                    if (mouse.button == Qt.LeftButton) {
                        progress = progressLeft
                    } else if (mouse.button == Qt.RightButton) {
                        progress = progressRight
                    } else if (mouse.button == Qt.MidButton) {
                        progress = progressTop
                    }

                    if(progress.ratio > 0) {
                        /* Second click, stop animation */
                        progress.anim.running = false;

                        /* Play sound */
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")

                        /* Success or not */
                        if(progress.ratio < 100) {
                            /* Success */
                            if(progress === progressLeft) {
                                ball.state = "LEFT"
                            } else if(progress === progressRight) {
                                ball.state = "RIGHT"
                            } else {
                                ball.state = "CENTER"
                            }
                        } else {
                            /* failure */
                            ball.state = "FAIL"
                        }
                        timerBonus.start()
                    } else {
                        /* First click, start animation*/
                        progress.anim.running = true;

                        /* Play sound */
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/flip.wav")
                    }
                }
            }
        }

        Timer {
            id: timerBonus
            interval: 1500
            onTriggered: {
                if (ball.state == "FAIL" || ball.state == "INITIAL") {
                    bonus.bad("tux")
                    ball.state = "FAIL"
                } else {
                    bonus.good("tux")
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
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            looseSound: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }
    }

}
