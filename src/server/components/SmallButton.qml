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
    id: smallButton
    text: qsTr("Button")
    hoverEnabled: true

    contentItem: Text {
        anchors.fill: parent
        anchors.margins: 2
        text: smallButton.text
        font: smallButton.font
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        opacity: enabled ? 1 : 0.3
        color: smallButton.checked ? "gainsboro" : "whitesmoke"
        border.color: smallButton.hovered ? "lightskyblue" : "gray"
        border.width: 1
        radius: 2
    }
}
