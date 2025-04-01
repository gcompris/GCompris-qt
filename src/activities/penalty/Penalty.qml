/* GCompris - Penalty.qml
 *
 * SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "penalty.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: Activity.url + "penalty_bg.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.Stretch
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias ball: ball
            property alias progressLeft: progressLeft
            property alias progressRight: progressRight
            property alias progressTop: progressTop
            property alias textItem: instructionPanel.textItem
            property alias brickSound: brickSound
            property alias flipSound: flipSound
            property alias bonus: bonus
            property alias timerFail: timerFail
            property alias ballAnim: ballAnim
            property int duration: 0
            property string saveBallState: "INITIAL"
            property bool ballToReturn: false
        }

        onStart: { Activity.start(items) }
        onStop: {
            timerFail.stop()
            ballAnim.stop()
            Activity.stop()
        }

        GCSoundEffect {
            id: brickSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        GCSoundEffect {
            id: flipSound
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            hideIfEmpty: true
            textItem.text: ball.initialInstruction
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Rectangle {
            id: playField
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: goal.top
            anchors.topMargin: goal.height * 0.75
            color: "#71ba50"
        }

        Rectangle {
            id: goalLine
            color: GCStyle.whiteBg
            width: activityBackground.width
            height: goal.height * 0.034
            anchors.bottom: goal.bottom
            anchors.left: activityBackground.left
        }

        Image {
            id: goal
            source: Activity.url + "goal.svg"
            anchors.bottom: activityBackground.verticalCenter
            anchors.horizontalCenter: activityBackground.horizontalCenter
            height: Math.min(activityBackground.height * 0.5 - instructionPanel.height - instructionPanel.anchors.topMargin - GCStyle.baseMargins, layoutArea.width * 0.5)
            width: height * 2
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        // To enable tapping/clicking on left side of goal
        GoalZone {
            id: rectLeft
            side: "LEFT"
            progress: progressLeft
            anchors.right: player.left
            anchors.left: goal.left
            anchors.leftMargin: goal.width * 0.025
            anchors.bottom: goal.bottom
            anchors.top: goal.top
            anchors.topMargin: goal.height * 0.06
        }

        // To enable tapping/clicking on top of goal
        GoalZone {
            id: rectTop
            side: "TOP"
            progress: progressTop
            anchors.left: player.left
            anchors.right: player.right
            anchors.bottom: player.top
            anchors.top: goal.top
            anchors.topMargin: rectLeft.anchors.topMargin
        }

        // To enable tapping/clicking on right side of goal
        GoalZone {
            id: rectRight
            side: "RIGHT"
            progress: progressRight
            anchors.left: player.right
            anchors.right: goal.right
            anchors.rightMargin: rectLeft.anchors.leftMargin
            anchors.bottom: goal.bottom
            anchors.top: goal.top
            anchors.topMargin: rectLeft.anchors.topMargin
        }

        /* The progress bars */
        Progress {
            id: progressLeft
            anchors.centerIn: rectLeft
            width: rectLeft.width - GCStyle.baseMargins
            height: GCStyle.baseMargins
        }

        Progress {
            id: progressRight
            rotation: 180
            anchors.centerIn: rectRight
            width: progressLeft.width
            height: GCStyle.baseMargins
        }

        Progress {
            id: progressTop
            rotation: 90
            anchors.centerIn: rectTop
            width: rectTop.height - GCStyle.baseMargins
            height: GCStyle.baseMargins
        }

        /* The player */
        Image {
            id: player
            source: Activity.url + "penalty_player.svg"
            fillMode: Image.PreserveAspectFit
            height: goal.height * 0.6
            sourceSize.height: height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: goal.bottom
            anchors.bottomMargin: -height * 0.2
        }

        /* The 2 click icon */
        Image {
            source: Activity.url + "click_icon.svg"
            sourceSize.width: GCStyle.bigButtonHeight
            anchors.bottom: bar.top
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
        }

        /* The spot under the ball */
        Rectangle {
            id: ballOrigin
            radius: width * 0.5
            width: ball.width * 0.5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: layoutArea.bottom
            color: GCStyle.whiteBg
            transform: [
                Scale { origin.y: ballOrigin.height; yScale: 0.7 }
            ]
        }

        /* The ball */
        Image {
            id: ball
            source: Activity.url + "penalty_ball.svg"
            fillMode: Image.PreserveAspectFit
            width: Math.min(100 * ApplicationInfo.ratio, player.height * 0.5)
            sourceSize.width: width
            x: initialPoint.x
            y: initialPoint.y

            property string ballState: "INITIAL"
            property string initialInstruction: qsTr("Double click or double tap on the side of the goal you want to put the ball in.")
            property string resetBallInstruction: qsTr("Click or tap on the ball to bring it back to its initial position.")

            property point destinationPoint
            property real destinationScale
            property int animDuration: 500

            readonly property point initialPoint: Qt.point(
                (activityBackground.width - ball.width) * 0.5,
                ballOrigin.y - ball.height + ballOrigin.height * 0.7)
            readonly property point rightPoint: Qt.point(
                rectRight.x + (rectRight.width - ball.width) * 0.5,
                rectRight.y + (rectRight.height - ball.height) * 0.5)
            readonly property point leftPoint:  Qt.point(
                rectLeft.x + (rectLeft.width - ball.width) * 0.5,
                rectLeft.y + (rectLeft.height - ball.height) * 0.5)
            readonly property point topPoint:  Qt.point(
                rectTop.x + (rectTop.width - ball.width) * 0.5,
                rectTop.y + (rectTop.height - ball.height) * 0.5)
            readonly property point failPoint: Qt.point(
                player.x + (player.width - ball.width) * 0.5,
                player.y + player.height * 0.5)

            onBallStateChanged: {
                switch(ball.ballState) {
                    case "INITIAL":
                        ball.destinationPoint = ball.initialPoint
                        ball.destinationScale = 1
                        ball.animDuration = 500
                        ballAnim.restart();
                        break;
                    case "RIGHT":
                        ball.destinationPoint = ball.rightPoint
                        ball.destinationScale = 0.6
                        ball.animDuration = 500
                        ballAnim.restart();
                        break;
                    case "LEFT":
                        ball.destinationPoint = ball.leftPoint
                        ball.destinationScale = 0.6
                        ball.animDuration = 500
                        ballAnim.restart();
                        break;
                    case "TOP":
                        ball.destinationPoint = ball.topPoint
                        ball.destinationScale = 0.6
                        ball.animDuration = 500
                        ballAnim.restart();
                        break;
                    case "FAIL":
                        ball.destinationPoint = ball.failPoint
                        ball.destinationScale = 0.6
                        ball.animDuration = 1000
                        ballAnim.restart();
                        break;
                }
            }
        }

        SequentialAnimation {
            id: ballAnim
            ScriptAction {
                script: { instructionPanel.textItem.text = "" }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: ball
                    property: "x"
                    to: ball.destinationPoint.x
                    duration: ball.animDuration
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: ball
                    property: "y"
                    to: ball.destinationPoint.y
                    duration: ball.animDuration
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: ball
                    property: "scale"
                    to: ball.destinationScale
                    duration: ball.animDuration
                    easing.type: Easing.OutQuad
                }
            }
            ScriptAction {
                script: {
                    if(ball.ballState === "INITIAL") {
                        instructionPanel.textItem.text = ball.initialInstruction;
                    } else if (ball.ballState === "FAIL") {
                        bonus.bad("smiley")
                    } else {
                        bonus.good("smiley")
                    }
                }
            }

        }

        MouseArea {
            anchors.centerIn: ball
            height: Math.max(GCStyle.bigButtonHeight, ball.height)
            width: height
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            enabled: items.ballToReturn
            onClicked: {
                Activity.resetLevel()
            }
        }

        Timer {
            id: timerFail
            interval: 1500
            onTriggered: ball.ballState = "FAIL";
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
                loose.connect(Activity.setBallToRetun)
                win.connect(Activity.nextLevel)
            }
        }
    }

}
