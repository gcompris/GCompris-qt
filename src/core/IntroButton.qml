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
import core 1.0

Rectangle {
    id: button
    color: GCStyle.lightBg
    border.color: GCStyle.blueBorder
    border.width: GCStyle.midBorder
    radius: GCStyle.halfMargins

    property alias text: buttonText.text

    signal clicked

    GCText {
        id: buttonText
        width: parent.width - 2 * GCStyle.baseMargins
        height: parent.height - GCStyle.baseMargins
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
    }

    MouseArea {
        id: buttonArea
        hoverEnabled: true
        anchors.fill: parent
        onClicked: parent.clicked()
    }
    states: [
    State {
        name: "notclicked"
        PropertyChanges {
            button {
                scale: 1.0
                color: GCStyle.lightBg
            }
        }
    },
    State {
        name: "clicked"
        when: buttonArea.pressed
        PropertyChanges {
            button {
                scale: 0.9
                color: GCStyle.focusColor
            }
        }
    },
    State {
        name: "hover"
        when: buttonArea.containsMouse
        PropertyChanges {
            button {
                scale: 1.0
                color: GCStyle.focusColor
            }
        }
    }
    ]
    Behavior on scale { NumberAnimation { duration: 70 } }
}
