/* GCompris - PianoKey.qml
*
* Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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

import "../../core"

Rectangle {
    id: pianoKey

    property string noteColor
    // keyName is an array of 2 elements. The 1st index has the "actual" key name, while the 2nd index has the translated one.
    property var keyName
    property real labelSquareSize
    property bool labelsVisible
    property bool isKeyEnabled: true

    signal keyPressed

    SequentialAnimation {
        id: keyPressAnimation
        NumberAnimation {
            target: pianoKey
            property: "scale"
            duration: 250
            to: 0.9
        }
        NumberAnimation {
            target: pianoKey
            property: "scale"
            duration: 250
            to: 1
        }
    }

    border.color: "black"
    Rectangle {
        width: labelSquareSize
        height: width
        anchors.bottom: pianoKey.bottom
        anchors.horizontalCenter: pianoKey.horizontalCenter
        color: ((keyName[0] != undefined) && (piano.coloredKeyLabels.indexOf(keyName[0][0]) != -1)) ? (piano.labelsColor === "inbuilt" ? noteColor : labelsColor) : "white"
        anchors.margins: 4
        border.color: "black"
        border.width: 2
        radius: 5
        visible: labelsVisible
        GCText {
            anchors.fill: parent
            text: keyName[1] != undefined ? keyName[1] : ""
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if(pianoKey.isKeyEnabled) {
                keyPressed()
                pianoKey.scale = 0.95
            }
        }
        onReleased: pianoKey.scale = 1
    }
}
