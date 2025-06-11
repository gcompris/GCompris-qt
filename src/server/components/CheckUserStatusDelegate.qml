/* GCompris - CheckUserStatusDelegate.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Control {
    id: checkUserStatusDelegate
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkUserStatusDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }
    StyledCheckBox {
        anchors {
            left: parent.left
            right: countText.left
            margins: Style.margins
            verticalCenter: parent.verticalCenter
        }
        text: user_name
        checked: user_checked
        ButtonGroup.group: childGroup
        onCheckedChanged: {
            foldModel.setProperty(index, checkKey, checked);
        }
        onClicked: {
            selectionClicked(foldModel.get(index)[indexKey], checked);
            currentChecked = index;
        }
    }

    DefaultLabel {
        id: countText
        anchors.right: pupilStatus.left
        anchors.rightMargin: Style.margins
        anchors.verticalCenter: parent.verticalCenter
        text: user_received ? user_received : ""
        elide: Text.ElideNone
    }

    Rectangle {
        id: pupilStatus
        anchors.right: parent.right
        anchors.rightMargin: Style.bigMargins
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - Style.margins
        width: height
        radius: height
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.text
        color: setConnectionColor(user_status)

        StyledToolTip {
            id: styledToolTip
            text: setConnectionHelp(user_status)
        }

        Timer {
            id: showToolTipTimer
            interval: 1000
            onTriggered: styledToolTip.visible = true;
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: {
                if(containsMouse) {
                    showToolTipTimer.restart();
                } else {
                    showToolTipTimer.stop();
                    styledToolTip.visible = false;
                }
            }
        }
    }
}
