/* GCompris - NavigationButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"

Item {
    id: navigationButton
    property alias iconCharacter: textIcon.text
    property alias description: textDescription.text
    property bool selected: false

    signal navigationButtonClicked()

    height: Style.bigControlSize
    width: isCollapsed ? Style.bigControlSize : buttonRow.width + Style.margins

    required property bool isCollapsed
    required property int panelWidth

    Rectangle {
        id: background
        width: navigationButton.panelWidth
        height: Style.bigControlSize
        color: navigationButton.selected ? Style.selectedPalette.highlight :
            (mouseArea.containsMouse ? Style.selectedPalette.accent : Style.selectedPalette.alternateBase)

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                navigationButton.navigationButtonClicked()
            }
        }
    }

    Row {
        id: buttonRow
        opacity: enabled ? 1 : 0.5
        width: childrenRect.width
        height: childrenRect.height
        Text {
            id: textIcon
            width: Style.bigControlSize
            height: Style.bigControlSize
            font.pixelSize: height * 0.5
            color: navigationButton.selected || mouseArea.containsMouse ?
            Style.selectedPalette.highlightedText :
            Style.selectedPalette.text
            text: "\uf11a"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        DefaultLabel {
            id: textDescription
            height: Style.bigControlSize
            horizontalAlignment: Text.AlignLeft
            color: textIcon.color
            font.pixelSize: Style.textSize
            fontSizeMode: Text.FixedSize
            text: "SET ME!!"
        }
    }
}
