/* GCompris - ColumnHeader.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"


AbstractButton {
    id: columnHeader
    property bool hasArrow: arrow != ""
    property string arrow: ""
    property bool toolTipOnHover: false
    property alias toolTipText: styledToolTip.text

    height: Style.lineHeight

    onHoveredChanged: {
        if(!columnHeader.toolTipOnHover) {
            return;
        } else if(hovered) {
            showToolTipTimer.restart();
        } else {
            showToolTipTimer.stop();
            styledToolTip.visible = false;
        }
    }

    background: Rectangle {
        anchors.fill: columnHeader
        color: columnHeader.pressed ? Style.selectedPalette.highlight :
        (columnHeader.hovered ? Style.selectedPalette.accent : Style.selectedPalette.alternateBase)
        border.color: (columnHeader.visualFocus || columnHeader.hovered) ?
            Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: (columnHeader.visualFocus || columnHeader.hovered) ? 2 : 1
    }

    Row {
        id: contentRow
        height: parent.height
        spacing: Style.tinyMargins
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: contentText
            height: Style.textSize
            width: Math.min(implicitWidth,
                columnHeader.width - Style.bigMargins - (columnHeader.hasArrow ? arrowImage.width + contentRow.spacing : 0))
            anchors.verticalCenter: parent.verticalCenter
            text: columnHeader.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Style.textSize
            elide: Text.ElideRight
            color: (columnHeader.hovered || columnHeader.visualFocus) ?
                Style.selectedPalette.highlightedText : Style.selectedPalette.text
        }

        Image {
            id: arrowImage
            visible: columnHeader.hasArrow
            source: columnHeader.hasArrow ? "qrc:/gcompris/src/server/resource/icons/" + Style.themePrefix + "dropdownArrow.svg" : ""
            rotation: arrow === "+" ? 0 : 180
            height: Style.iconSize
            width: Style.iconSize
            sourceSize.width: Style.iconSize
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    StyledToolTip {
        id: styledToolTip
        text: columnHeader.text
    }

    Timer {
        id: showToolTipTimer
        interval: 1000
        onTriggered: styledToolTip.visible = true;
    }
}
