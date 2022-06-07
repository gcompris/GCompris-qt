/* GCompris - Left_right_click.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import GCompris 1.0
import "../../core"
import "left_right_click.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            property alias animalListModel: animalListModel
            property alias animalCardsArea: animalCardsArea
            property double animalWidth: animalCardsArea.animalCardSize
            property double animalHeight: animalCardsArea.animalCardSize
            property alias leftArea: leftAreaTarget
            property alias rightArea: rightAreaTarget
            property alias displayMouse: displayMouse
            property alias leftClickDisplayMouse: leftClickDisplayMouse
            property alias rightClickDisplayMouse: rightClickDisplayMouse
            property alias cross: cross
            property int animalCount
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Image {
            id: leftAreaTarget
            parent: layoutArea
            width: layoutArea.width * 0.3
            height: sourceSize.height
            sourceSize.height: layoutArea.height * 0.5
            anchors.left: layoutArea.left
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/left_right_click/resource/redbarn.png"
        }

        Image {
            id: rightAreaTarget
            parent: layoutArea
            width: layoutArea.width * 0.3
            height: sourceSize.height
            sourceSize.height: layoutArea.height * 0.5
            anchors.right: layoutArea.right
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/babymatch/resource/images/tree.svg"
        }

        ListModel {
            id: animalListModel
        }

        Rectangle {
            id: animalCardsArea
            parent: layoutArea
            width: layoutArea.width
            height: layoutArea.height * 0.5
            anchors.top: leftAreaTarget.bottom
            color: "pink"
            border.color: "black"
            border.width: 2
            radius: 5
            property double animalCardSize: Core.fitItems(animalCardsArea.width,animalCardsArea.height,items.animalCount)

            GridView {
                id: container
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                cellHeight: animalCardsArea.animalCardSize
                cellWidth: animalCardsArea.animalCardSize
                model: animalListModel
                delegate: Animal {
                    height: items.animalHeight
                    width: items.animalWidth
                }
            }
        }

        Rectangle {
            id: mouseDisplayContainer
            parent: layoutArea
            anchors.top: layoutArea.top
            anchors.bottom: animalCardsArea.top
            anchors.left: leftAreaTarget.right
            anchors.right: rightAreaTarget.left
            color: "transparent"

            Rectangle {
                id: displayMouse
                width: 2 * height / 3
                height: layoutArea.height * 0.45
                anchors.centerIn: parent
                color: "white"
                border.width: 2
                border.color: "black"
                radius: 30

                MouseButton {
                    id: leftClickDisplayMouse
                    height: displayMouse.height * 0.3
                    width: displayMouse.width * 0.5
                }

                MouseButton {
                    id: rightClickDisplayMouse
                    height: displayMouse.height * 0.3
                    width: displayMouse.width * 0.5
                    anchors.right: parent.right
                }

                Rectangle {
                    id: lowerMouseArea
                    width: parent.width
                    height: parent.height - rightClickDisplayMouse.height
                    anchors.bottom: parent.bottom
                    color: "white"
                    border.width: 2
                    border.color: "black"
                    radius: 30
                }

                Image {
                    id: cross
                    anchors.fill: lowerMouseArea
                    sourceSize.height: lowerMouseArea.height
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
