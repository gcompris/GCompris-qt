/* GCompris - SelectionButton.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Item {
    id: selectionButton
    width: buttonSize
    height: buttonSize

    property real buttonSize
    property bool isButtonSelected: false
    property alias iconSource: buttonIcon.source

    property alias self: selectionButton

    signal buttonClicked()

    function buttonPressed() {
        buttonIcon.scale = 0.9
    }

    function buttonReleased() {
        buttonIcon.scale = 1
    }

    Image {
        id: buttonIcon
        source: parent.iconSource
        anchors.fill: parent
        anchors.margins: items.baseMargins
        sourceSize.width: height
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onPressed: buttonPressed();
        onReleased: buttonReleased();
        enabled: !selectionButton.isButtonSelected
        onClicked: {
            selectionButton.buttonClicked();
        }
    }

    Rectangle {
        id: highlight
        visible: selectionButton.isButtonSelected
        anchors.fill: parent
        radius: items.baseMargins
        border.color: items.contentColor
        border.width: 2 * ApplicationInfo.ratio
        color: "transparent"
    }
}
