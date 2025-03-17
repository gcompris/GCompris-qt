/* GCompris - Leftright.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0
import "../../core"
import "leftright.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true;

    pageComponent: Rectangle {
        id: activityBackground
        color: GCStyle.lightBlueBg
        focus: true
        signal start
        signal stop

        QtObject {
            id: items
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias imageAnimOff: imageAnimOff
            property alias leftButton: leftButton
            property alias rightButton: rightButton
            property alias score: score
            property bool buttonsBlocked: false
        }

        Keys.onLeftPressed: leftButton.pressed()
        Keys.onRightPressed: rightButton.pressed()
        Keys.enabled: !items.buttonsBlocked

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            width: parent.width - 2 * GCStyle.baseMargins
            height: parent.height - bar.height * 1.5 - score.height - 2 * GCStyle.baseMargins
            anchors.top: score.bottom
            anchors.left: parent.left
            anchors.margins: GCStyle.baseMargins
        }

        Image {
            id: blackBoard
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.verticalCenterOffset: -leftButton.height * 0.5
            fillMode: Image.PreserveAspectFit
            height: (layoutArea.height - 10) * 0.85
            width: layoutArea.width
            sourceSize.height: height
            sourceSize.width: width
            source: "qrc:/gcompris/src/activities/leftright/resource/blackboard.svg"

            Image {
                id: lightImage
                source: "qrc:/gcompris/src/activities/leftright/resource/light.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: blackBoard.paintedWidth
                sourceSize.height: blackBoard.paintedHeight
                anchors.centerIn: parent
                anchors.topMargin: 2 * GCStyle.baseMargins
                opacity: 0
            }

            Image {
                id: handImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                width: blackBoard.paintedHeight * 0.7
                height: width
                opacity: 0
            }

            ParallelAnimation {
                id: imageAnimOff
                onRunningChanged: {
                    if (!imageAnimOff.running) {
                        handImage.source = Activity.getCurrentHandImage()
                        handImage.rotation = Activity.getCurrentHandRotation()

                        imageAnimOn.start()
                    }
                }
                NumberAnimation {
                    target: handImage
                    property: "opacity"
                    from: 1; to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: lightImage
                    property: "opacity"
                    from: 1; to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            ParallelAnimation {
                id: imageAnimOn
                onStopped: bonus.isPlaying ? items.buttonsBlocked = true : items.buttonsBlocked = false
                NumberAnimation {
                    target: handImage
                    property: "opacity"
                    from: 0; to: 1.0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: lightImage
                    property: "opacity"
                    from: 0; to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            GCSoundEffect {
                id: goodAnswerEffect
                source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
            }

            GCSoundEffect {
                id: badAnswerEffect
                source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
            }

            AnswerButton {
                id: leftButton
                width: blackBoard.paintedWidth * 0.45
                height: (layoutArea.height - 10) * 0.15
                anchors.right: blackBoard.horizontalCenter
                anchors.rightMargin: blackBoard.paintedWidth * 0.04
                anchors.top: blackBoard.verticalCenter
                anchors.topMargin: blackBoard.paintedHeight * 0.5 + GCStyle.halfMargins
                textLabel: qsTr("Left hand")
                onPressed: {
                    items.buttonsBlocked = true
                    if(isCorrectAnswer) {
                        goodAnswerEffect.play()
                        Activity.goodAnswerPressed()
                    } else {
                        badAnswerEffect.play()
                    }
                }
                blockAllButtonClicks: items.buttonsBlocked
                onIncorrectlyPressed: items.buttonsBlocked = false
            }

            AnswerButton {
                id: rightButton
                width: leftButton.width
                height: leftButton.height
                anchors.left: blackBoard.horizontalCenter
                anchors.leftMargin: leftButton.anchors.rightMargin
                anchors.top: blackBoard.verticalCenter
                anchors.topMargin: leftButton.anchors.topMargin
                textLabel: qsTr("Right hand")
                onPressed: {
                    items.buttonsBlocked = true
                    if(isCorrectAnswer) {
                        goodAnswerEffect.play()
                        Activity.goodAnswerPressed()
                    } else {
                        badAnswerEffect.play()
                    }
                }
                blockAllButtonClicks: items.buttonsBlocked
                onIncorrectlyPressed: items.buttonsBlocked = false
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            onStop: {
                Activity.nextLevel();
            }
        }

        Score {
            id: score
            anchors.top: activityBackground.top
            anchors.topMargin: GCStyle.baseMargins
            anchors.bottom: undefined
            onStop: Activity.displayNextHand()
        }
    }
}
