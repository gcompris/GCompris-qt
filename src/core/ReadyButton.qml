/* GCompris - ReadyButton.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
