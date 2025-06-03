/* GCompris - NavigationButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../singletons"

Item {
    id: navigationButton
    property alias iconCharacter: textIcon.text
    property alias description: textDescription.text
    property bool selected: false

    signal navigationButtonClicked()

    height: Style.bigControlSize
    width: parent.width

    Rectangle {
        id: background
        anchors.fill: parent
        color: navigationButton.selected ? Style.selectedPalette.highlight :
            (mouseArea.containsMouse ? Style.selectedPalette.accent : Style.selectedPalette.alternateBase)

        Row {
            opacity: enabled ? 1 : 0.5
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
                width: background.width - Style.bigControlSize
                height: Style.bigControlSize
                horizontalAlignment: Text.AlignLeft
                color: textIcon.color
                font.pixelSize: Style.textSize
                fontSizeMode: Text.FixedSize
                text: "SET ME!!"
            }
        }

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
}
