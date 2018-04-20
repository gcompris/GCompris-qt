/* GCompris - Leftright.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
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
import "leftright.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true;

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/leftright/resource/back.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        focus: true
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop

        QtObject {
            id: items
            property alias bar: bar
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            property alias imageAnimOff: imageAnimOff
            property alias leftButton: leftButton
            property alias rightButton: rightButton
            property alias score: score
            property bool buttonsBlocked: false
        }

        Keys.onLeftPressed: Activity.leftClickPressed()
        Keys.onRightPressed: Activity.rightClickPressed()
        Keys.enabled: !items.buttonsBlocked
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: topBorder
            height: background.height * 0.08
        }

        Image {
            id: blackBoard
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topBorder.bottom
            fillMode: Image.PreserveAspectFit
            sourceSize.width: Math.min(background.width,
                                       (background.height - leftButton.height - bar.height) * 1.3)
            source: "qrc:/gcompris/src/activities/leftright/resource/blackboard.svg"

            Image {
                id: handImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                scale: blackBoard.height / 300 * 0.8
                opacity: 0
            }

            Image {
                id: lightImage
                source: "qrc:/gcompris/src/activities/leftright/resource/light.svg"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 40
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
                    from: 0.2; to: 0
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
                    from: 0; to: 0.2
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            AnswerButton {
                id: leftButton
                width: blackBoard.width * 0.45
                height: background.height * 0.15
                anchors.left: blackBoard.left
                anchors.top: blackBoard.bottom
                anchors.margins: 10
                textLabel: qsTr("Left hand")
                audioEffects: activity.audioEffects
                onPressed: items.buttonsBlocked = true
                onCorrectlyPressed: Activity.leftClick()
                blockAllButtonClicks: items.buttonsBlocked
                onIncorrectlyPressed: items.buttonsBlocked = false
            }

            AnswerButton {
                id: rightButton
                width: blackBoard.width * 0.45
                height: background.height * 0.15
                anchors.right: blackBoard.right
                anchors.top: blackBoard.bottom
                anchors.margins: 10
                audioEffects: activity.audioEffects
                textLabel: qsTr("Right hand")
                onPressed: items.buttonsBlocked = true
                onCorrectlyPressed: Activity.rightClick()
                blockAllButtonClicks: items.buttonsBlocked
                onIncorrectlyPressed: items.buttonsBlocked = false
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            onStart: items.buttonsBlocked = true
            onStop: items.buttonsBlocked = false
        }

        Score {
            id: score
            anchors.top: background.top
            anchors.bottom: undefined
        }
    }
}
