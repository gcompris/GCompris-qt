/* GCompris - Left_right_click.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import core 1.0
import "../../core"
import "left_right_click.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/canal_lock/resource/sky.svg"
        sourceSize.height: height
        sourceSize.width: width
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
            property alias bonus: bonus
            property alias badAnswerSound: badAnswerSound
            property alias animalListModel: animalListModel
            property alias animalCardsArea: animalCardsArea
            property alias leftArea: leftAreaTarget
            property alias rightArea: rightAreaTarget
            property alias displayMouse: displayMouse
            property alias leftClickDisplayMouse: leftClickDisplayMouse
            property alias rightClickDisplayMouse: rightClickDisplayMouse
            property alias cross: cross
            property int cardCount: 1
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Image {
            id: hillArea
            source: "qrc:/gcompris/src/activities/left_right_click/resource/hill.svg"
            width: activityBackground.width
            height: activityBackground.height - leftAreaTarget.height * 0.5
            anchors.bottom: activityBackground.bottom
            sourceSize.width: width
            sourceSize.height: height
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 0.2
        }

        Image {
            id: leftAreaTarget
            parent: layoutArea
            width: layoutArea.width * 0.3
            height: layoutArea.height * 0.5
            sourceSize.height: Math.min(width, height)
            anchors.left: layoutArea.left
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/left_right_click/resource/pond.svg"
        }

        Image {
            id: rightAreaTarget
            parent: layoutArea
            width: leftAreaTarget.width
            height: leftAreaTarget.height
            sourceSize.height: leftAreaTarget.sourceSize.height
            anchors.right: layoutArea.right
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/left_right_click/resource/tree.svg"
        }

        ListModel {
            id: animalListModel
        }

        Item {
            id: animalCardsArea
            parent: layoutArea
            width: layoutArea.width
            height: leftAreaTarget.height
            anchors.top: leftAreaTarget.bottom
            property int animalCardSize: Math.floor(Core.fitItems(animalCardsArea.width, animalCardsArea.height, items.cardCount))

            GridView {
                id: container
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                interactive: false
                cellHeight: animalCardsArea.animalCardSize
                cellWidth: animalCardsArea.animalCardSize
                model: animalListModel
                delegate: Animal {
                    width: animalCardsArea.animalCardSize
                }
            }
        }

        Item {
            id: mouseDisplayContainer
            parent: layoutArea
            anchors.top: layoutArea.top
            anchors.bottom: animalCardsArea.top
            anchors.left: leftAreaTarget.right
            anchors.right: rightAreaTarget.left

            Image {
                id: displayMouse
                source: "qrc:/gcompris/src/activities/left_right_click/resource/mouse.svg"
                width: Math.min(parent.width, parent.height)
                height: width
                sourceSize.width: width
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit

                MouseButton {
                    id: leftClickDisplayMouse
                }

                MouseButton {
                    id: rightClickDisplayMouse
                    isRightButton: true
                }

                Image {
                    id: cross
                    height: parent.width * 0.5
                    width: height
                    sourceSize.height: height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    source: "qrc:/gcompris/src/core/resource/cancel.svg"
                    visible: false // only visible when a wrong click is pressed
                }
            }
        }

        // for left click of the mouse
        signal leftClickTrigger
        onLeftClickTrigger: {
            leftClickDisplayMouse.clickTrigger()
        }

        // for the right click of the mouse
        signal rightClickTrigger
        onRightClickTrigger: {
            rightClickDisplayMouse.clickTrigger()
        }

        //for the cross to hide
        signal wrongClick
        onWrongClick: {
            cross.visible = true
            hideCross.running = true
            Activity.playWrongClickSound()
        }

        PropertyAnimation {
            id: hideCross
            target: cross
            property: "visible"
            to: false
            duration: 500
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.start(items)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
