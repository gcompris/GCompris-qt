/* GCompris - ActionButton.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: selectionButton
    width: buttonSize
    height: buttonSize

    property real buttonSize
    property alias iconSource: buttonIcon.source

    signal buttonClicked()

    Rectangle {
        id: buttonColor
        anchors.fill: parent
        radius: items.baseMargins
        border.color: items.contentColor
        color: items.contentColor
        opacity: 0.1
    }

    Image {
        id: buttonIcon
        source: parent.iconSource
        height: parent.height - items.baseMargins
        width: height
        sourceSize.width: height
        sourceSize.height: height
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onPressed: buttonColor.opacity = 0.5
        onReleased: buttonColor.opacity = 0.1
        onClicked: {
            selectionButton.buttonClicked();
        }
    }
}
