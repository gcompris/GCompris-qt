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

import "."
import "../singletons"

Item {
    property alias iconCharacter: textIcon.text
    property alias description: textDescription.text
    property color hoverColour: Style.colorHover
    property bool selected: false

    signal navigationButtonClicked()

    width: parent.width
    height: Style.heightNavigationButton

    Rectangle {
        id: background
        anchors.fill: parent
        color: enabled ? selected ? Style.colorBackground : Style.colorNavigationBarBackground : Style.colorNavigationBarBackgroundDisabled

        Row {
            Text {
                id: textIcon
                width: Style.widthNavigationButtonIcon
                height: Style.heightNavigationButtonIcon
                font.pixelSize: Style.pixelSizeNavigationBarIcon

                color: Style.colorNavigationBarFont
                text: "\uf11a"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                id: textDescription
                width: Style.widthNavigationButtonDescription
                height: Style.heightNavigationButtonDescription
                color: Style.colorNavigationBarFont
                text: "SET ME!!"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Style.pixelSizeNavigationBarText
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: if (!selected) background.state = "hover"
            onExited: background.state = ""
            onClicked: {
                background.state = ""
                navigationButtonClicked()
            }
        }

        states: [
            State {
                name: "hover"
                PropertyChanges {
                    target: background
                    color: hoverColour
                }
            }
        ]
    }
}
