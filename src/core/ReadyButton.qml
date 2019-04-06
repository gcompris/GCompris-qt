/* GCompris - ReadyButton.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

Rectangle {
    id: iAmReady

    /**
     * type: var
     * Existing themes for the button.
     * A theme is composed of:
     *   The button's border color
     *   The text color
     */
    property var themes: {
        "dark": {
            borderColor: "#373737",
            fillColor: "#FFFFFF",
            textColor: "#373737"
        },
        "light": {
            borderColor: "white",
            fillColor: "#373737",
            textColor: "white"
        }
    }

    /**
     * type: string
     * Defines the theme of the ReadyButton - dark or light.
     *
     * Default theme is dark.
     */
    property string theme: "dark"

    /**
     * Emitted when the ReadyButton is clicked
     */
    signal clicked

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    border.color: themes[theme].borderColor
    visible: true
    radius: 10
    smooth: true
    border.width: 4
    width: iAmReadyText.width + 50 * ApplicationInfo.ratio
    height: iAmReadyText.height + 50 * ApplicationInfo.ratio
    color: themes[theme].fillColor

    GCText {
        id: iAmReadyText
        color: themes[theme].textColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        fontSize: mediumSize
        text: qsTr("I am Ready")
        visible: iAmReady.visible
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            iAmReady.visible = false
            iAmReady.clicked()
        }
    }

    states: [
        State {
            name: "notClicked"
            PropertyChanges {
                target: iAmReady
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: iAmReady
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: iAmReady
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
