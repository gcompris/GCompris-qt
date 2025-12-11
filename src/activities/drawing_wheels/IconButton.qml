/* GCompris - IconButton.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
import QtQuick
import QtQuick.Controls
import core 1.0

Item {
    id: iconButton
    property string toolTip: ""
    property bool selected: false
    property alias source: iconImage.source
    property alias mirror: iconImage.mirror
    property alias buttonArea: buttonArea
    smooth: true
    width: 50
    height: width
    opacity: selected && enabled ? 1.0 : 0.5

    signal clicked

    Image {
        id: iconImage
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        scale: buttonArea.pressed ? 0.9 : 1
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: iconButton.clicked()
    }

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    // disable tooltip on mobile as they sometime appear for weird reasons...
    ToolTip.visible: (toolTip !== "") && buttonArea.containsMouse && !ApplicationInfo.isMobile
    ToolTip.text: toolTip
}
