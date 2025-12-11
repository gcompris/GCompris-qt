/* GCompris - ActionButton.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

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
        color: GCStyle.contentColor
        radius: GCStyle.halfMargins
        opacity: 0.1
    }

    Image {
        id: buttonIcon
        height: parent.height - GCStyle.halfMargins
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
