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

    Image {
        id: buttonIcon
        source: parent.iconSource
        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins
        sourceSize.width: height
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        scale: buttonArea.pressed ? 0.9 : 1
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        enabled: !selectionButton.isButtonSelected
        onClicked: {
            selectionButton.buttonClicked();
        }
    }

    Rectangle {
        id: highlight
        visible: selectionButton.isButtonSelected
        anchors.fill: parent
        radius: GCStyle.halfMargins
        border.color: GCStyle.contentColor
        border.width: GCStyle.thinBorder
        color: "transparent"
    }
}
