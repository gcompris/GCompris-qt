/* GCompris - Penalty.qml
 *
 * SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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

        // To enable tapping/clicking on left side of goal
        GoalZone {
            id: rectLeft
            state: "LEFT"
            progress: progressLeft
            anchors.right: player.left
            anchors.leftMargin: parent.width * 0.08
            anchors.bottomMargin: parent.height * 0.45
        }

        // To enable tapping/clicking on top of goal
        GoalZone {
            id: rectTop
            state: "CENTER"
            progress: progressTop
            anchors.left: player.left
            anchors.right: player.right
            anchors.bottom: player.top
        }

        // To enable tapping/clicking on right side of goal
        GoalZone {
            id: rectRight
            state: "RIGHT"
            progress: progressRight
            anchors.left: player.right
            anchors.rightMargin: parent.width * 0.06
            anchors.bottomMargin: parent.height * 0.45
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias ball: ball
            property alias progressLeft: progressLeft
            property alias progressRight: progressRight
            property alias progressTop: progressTop
            property alias bonus: bonus
            property int duration: 0
            property int progressBarOpacity: 40
            property string saveBallState: "INITIAL"
            property double ballX: ball.parent.width/2 - ball.width/2
            property double ballY: ball.parent.height*0.77 - ball.height/2
        }

        onStart: { Activity.start(items) }
        onStop: {
            timerBonus.stop()
            Activity.stop()
        }

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
        Progress {
            id: progressLeft
            anchors.left: parent.left
            anchors.leftMargin: parent.width / parent.implicitWidth * 62
        }

        Progress {
            id: progressRight
            anchors.right: parent.right
            anchors.rightMargin: parent.width/parent.implicitWidth * 50
        }

        Progress {
            id: progressTop
            anchors.topMargin: parent.width / parent.implicitWidth * 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.height / parent.implicitHeight * 20
            height: ratio / 100 * parent.width / parent.implicitWidth * 100
        }

        /* The player */
        Image {
            id: player
            source: Activity.url + "penalty_player.svg"
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            sourceSize.width: 154 * ApplicationInfo.ratio
        }

        /* The 2 click icon */
        Image {
            source: Activity.url + "click_icon.svg"
            sourceSize.width: 90 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.right: parent.right
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 10 * ApplicationInfo.ratio
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
                        text: qsTr("Double click or double tap on the side of the goal you want to put the ball in.")
                    }
                },
                State {
                    name: "RIGHT"
                    PropertyChanges {
                        target: ball
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: background.width * 0.7
                        y: background.height * 0.3
                    }
                },
                State {
                    name: "LEFT"
                    PropertyChanges {
                        target: ball
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: background.width * 0.2
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
                        target: ball
                        sourceSize.width: 75 * ApplicationInfo.ratio
                        x: parent.width/2 - width/2
                        y: player.y + player.height / 2
                    }
                    PropertyChanges {
                        target: instruction
                        text: qsTr("Click or tap on the ball to bring it back to its initial position.")
                    }
                }
            ]

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
                onClicked: {
                    Activity.resetLevel()
                }
            }
        }

        Timer {
            id: timerBonus
            interval: 1500
            onTriggered: {
                if (ball.state == "FAIL" || ball.state == "INITIAL") {
                    bonus.bad("smiley")
                    ball.state = "FAIL"
                } else {
                    bonus.good("smiley")
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
