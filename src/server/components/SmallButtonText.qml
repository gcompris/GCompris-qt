/* GCompris - SmallButtonText.qml
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

Button {
    id: smallButton
    text: ""
    hoverEnabled: true
    height: Style.lineHeight
    width: contentItem.implicitWidth + Style.bigMargins

    opacity: enabled ? 1 : 0.5

    property bool toolTipOnHover: false
    property alias toolTipText: styledToolTip.text

    onHoveredChanged: {
        if(!toolTipOnHover) {
            return;
        } else if(hovered) {
            showToolTipTimer.restart();
        } else {
            showToolTipTimer.stop();
            styledToolTip.visible = false;
        }
    }

    contentItem: Text {
        anchors.centerIn: smallButton
        height: Style.textSize
        text: smallButton.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Style.textSize
        elide: Text.ElideRight
        color: smallButton.hovered || smallButton.checked ?
            Style.selectedPalette.highlightedText : Style.selectedPalette.text
    }

    background: Rectangle {
        anchors.fill: parent
        anchors.margins: Style.tinyMargins
        color: smallButton.pressed || smallButton.checked ? Style.selectedPalette.highlight :
            (smallButton.enabled && smallButton.hovered ? Style.selectedPalette.accent :
            Style.selectedPalette.alternateBase)
        border.color: smallButton.enabled && (smallButton.visualFocus || smallButton.hovered) ?
            Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: smallButton.enabled && (smallButton.visualFocus || smallButton.hovered) ? 2 : 1
    }

    StyledToolTip {
        id: styledToolTip
    }

    Timer {
        id: showToolTipTimer
        interval: 1000
        onTriggered: styledToolTip.visible = true;
    }
}
