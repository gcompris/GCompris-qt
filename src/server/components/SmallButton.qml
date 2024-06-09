/* GCompris - SmallButton.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls.Basic

Button {
    id: control
    text: qsTr("Button")
    hoverEnabled: true

    contentItem: Text {
        anchors.fill: parent
        anchors.margins: 2
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        opacity: enabled ? 1 : 0.3
        color: checked ? "gainsboro" : "whitesmoke"
        border.color: control.hovered ? "lightskyblue" : "gray"
        border.width: 1
        radius: 3
    }
}
