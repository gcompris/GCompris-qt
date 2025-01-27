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
import GCompris 1.0

Rectangle {
    id: button
    color: "#F2F2F2"
    border.color: "#87A6DD"
    border.width: 3 * ApplicationInfo.ratio
    radius: 5 * ApplicationInfo.ratio

    property alias text: buttonText.text

    signal clicked

    GCText {
        id: buttonText
        width: parent.width - 20 * ApplicationInfo.ratio
        height: parent.height - 10 * ApplicationInfo.ratio
        anchors.centerIn: parent
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
            button {
                scale: 1.0
            }
        }
    },
    State {
        name: "clicked"
        when: buttonArea.pressed
        PropertyChanges {
            button {
                scale: 0.9
            }
        }
    },
    State {
        name: "hover"
        when: buttonArea.containsMouse
        PropertyChanges {
            button {
                scale: 1.1
            }
        }
    }
    ]
    Behavior on scale { NumberAnimation { duration: 70 } }
}
