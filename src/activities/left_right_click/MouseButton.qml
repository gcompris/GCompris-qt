/* GCompris - MouseButton.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

Item {
    id: mouseButton
    Rectangle {
        id: mouseButtonRect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        color: "white"
        border.color: "black"
        border.width: 2
        radius: 30
        SequentialAnimation {
            id: runCodeClickAnimation
            NumberAnimation { target: mouseButtonRect; property: "scale"; to: 0.9; duration: 100 }
            NumberAnimation { target: mouseButtonRect; property: "scale"; to: 1.0; duration: 100 }
        }
        PropertyAnimation {
            id: changeToInitialColor
            target: mouseButtonRect
            property: "color"
            to: "white"
            duration: 1000
        }
    }
    signal clickTrigger
    onClickTrigger: {
        mouseButtonRect.color = "orange"
        runCodeClickAnimation.running = true
        changeToInitialColor.running = true
    }
}
