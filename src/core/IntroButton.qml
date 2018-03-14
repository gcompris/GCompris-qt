/* GCompris - IntroButton.qml
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

/*
 * A generic QML button for intro/tutorial in GCompris.
 * Can probably be used at some other places.
 */

import QtQuick 2.6

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
