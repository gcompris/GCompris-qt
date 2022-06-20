/* GCompris - MouseButton.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

Image {
    id: mouseButton
    property bool isRightButton: false
    source: "qrc:/gcompris/src/activities/left_right_click/resource/mouse_button.svg"
    width: parent.width
    height: parent.height
    sourceSize.width: parent.sourceSize.width
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit
    opacity: 0
    mirror: mouseButton.isRightButton

    SequentialAnimation {
        id: runCodeClickAnimation
        NumberAnimation { target: mouseButton; property: "scale"; to: 0.9; duration: 100 }
        NumberAnimation { target: mouseButton; property: "scale"; to: 1.0; duration: 100 }
    }
    PropertyAnimation {
        id: changeToInitialColor
        target: mouseButton
        property: "opacity"
        to: 0
        duration: 1000
    }

    signal clickTrigger
    onClickTrigger: {
        mouseButton.opacity = 1
        runCodeClickAnimation.running = true
        changeToInitialColor.running = true
    }
}
