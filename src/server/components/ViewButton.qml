/* GCompris - ViewButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import "../singletons"

Button {
    width: 180
    height: 40
    contentItem: Text {
        anchors.fill: parent
        anchors.margins: 5
        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: 18 * height / 40
        font.family: Style.fontAwesome
        color: enabled ? "black" : "gray"
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 5
        color: (parent.focus || parent.hovered) ? Style.colorHoveredButton : Style.colorButton
        border.color: "black"
        border.width: parent.hovered ? 3 : 1
    }
}

