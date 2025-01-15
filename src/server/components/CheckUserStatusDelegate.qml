/* GCompris - CheckUserStatusDelegate.qml
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
import QtQuick.Layouts 1.15
import "../singletons"

Control {
    id: lineBox
    font.pixelSize: Style.defaultPixelSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
    }
    CheckBox {
        anchors.fill: parent
        anchors.leftMargin: 10
        text: user_name
        checked: user_checked
        ButtonGroup.group: childGroup
        indicator.scale: Style.checkerScale
        onClicked: {
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked(foldModel.get(index)[indexKey], checked)
            currentChecked = index
        }
    }

    Text {
        anchors.right: pupilStatus.left
        anchors.top: parent.top
        anchors.rightMargin: 10
        width: 50
        height: parent.height
        clip: true
        text: user_received ? user_received : ""
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Rectangle {
        id: pupilStatus
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        width: parent.height - 4
        height: parent.height - 4
        radius: 6
        border.color: "black"
        color: setConnectionColor(user_status)
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            ToolTip.visible: containsMouse
            ToolTip.text: setConnectionHelp(user_status)
        }
    }
}
