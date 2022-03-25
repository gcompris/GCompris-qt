/* GCompris - IntroButton.qml
 *
 * SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * A generic QML button for intro/tutorial in GCompris.
 * Can probably be used at some other places.
 */

import QtQuick 2.12

Rectangle {
    id: button
    color: "#d8ffffff"
    border.color: "#2a2a2a"
    border.width: 3
    radius: 8

    property alias text: buttonText.text

    signal clicked

    GCText {
        id: buttonText
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
    states: [
    State {
        name: "notclicked"
        PropertyChanges {
            target: button
            scale: 1.0
        }
    },
    State {
        name: "clicked"
        when: buttonArea.pressed
        PropertyChanges {
            target: button
            scale: 0.9
        }
    },
    State {
        name: "hover"
        when: buttonArea.containsMouse
        PropertyChanges {
            target: button
            scale: 1.1
        }
    }
    ]
    Behavior on scale { NumberAnimation { duration: 70 } }
}
