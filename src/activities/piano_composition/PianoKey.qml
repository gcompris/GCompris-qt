/* GCompris - PianoKey.qml
*
* SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
