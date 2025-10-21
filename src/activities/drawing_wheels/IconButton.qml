/* GCompris - IconButton.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
import QtQuick
import QtQuick.Controls

Image {
    id: iconButton
    property string toolTip: ""
    property bool selected: false
    smooth: true
    width: 60
    height: width
    sourceSize.width: width
    sourceSize.height: height
    fillMode: Image.PreserveAspectFit
    opacity: selected ? 1.0 : 0.4

    signal pushed

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: pushed()

        onContainsMouseChanged: {
            if (containsMouse && iconButton.enabled)
                iconButton.scale = 1.1
            else
                iconButton.scale = 1.0
        }
    }

    ToolTip.visible: (toolTip !== "")  && buttonArea.containsMouse
    ToolTip.text: toolTip

}
