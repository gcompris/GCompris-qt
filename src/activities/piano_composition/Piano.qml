/* GCompris - Piano.qml
*
* Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"

Item {
    id: piano
    //source: "qrc:/gcompris/src/activities/playpiano/resource/piano.svg"
    //sourceSize.height: 200 * ApplicationInfo.ratio
    z: 3

    width: numberOfWhite * 23 // 23 is default width
    height: 120
    property int numberOfWhite: 8

    property var blacks: [14.33, 41.67, 82.25, 108.25, 134.75] // / 8*23
    property int whiteWidth: width / numberOfWhite // 23
    property int whiteHeight: height // 120
    property int blackWidth: (whiteWidth + 1) / 2 // 13
    property int blackHeight: 2 * height / 3 // 80

    property var whiteNotes: ["C", "D", "E", "F", "G", "A", "B", "C"]
    property var blackNotesSharp: ["C#", "D#", "F#", "G#", "A#"]
    property var blackNotesFlat: ["Db", "Eb", "Gb", "Ab", "Bb"]
    // black note labels used, can be sharp or flat
    property var blackNotes: useSharpNotation ? blackNotesSharp : blackNotesFlat

    property var colorWhiteNotes: ["#FF0000", "#FF7F00", "#FFFF00", "#32CD32",
    "#6495ED", "#D02090", "#FF1493", "#FF0000",
    "#FF7F00", "#FFFF00", "#32CD32"]
    property var colorBlackNotes: ["#FF6347", "#FFD700", "#20B2AA", "#8A2BE2",
    "#FF00FF", "#FF6347"]
    signal noteClicked(string note)

    property bool blackLabelsVisible: true
    property bool whiteLabelsVisible: true
    property bool useSharpNotation: true
    property int labelSquareSize: whiteWidth - 5

    Repeater {
        id: whiteRepeater
        model: whiteNotes.length
        Rectangle {
            id: note
            color: "white"
            border.color: "black"
            width: whiteWidth
            height: whiteHeight
            x: index * whiteWidth
            Rectangle {
                width: labelSquareSize
                height: width
                anchors.bottom: note.bottom
                anchors.horizontalCenter: note.horizontalCenter
                color: colorWhiteNotes[index]
                anchors.margins: 4
                border.color: "black"
                border.width: 2
                radius: 5
                visible: whiteLabelsVisible
                GCText {
                    anchors.fill: parent
                    text: whiteNotes[index]
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MultiPointTouchArea {
                anchors.fill: parent
                onPressed: {
                    noteClicked(index + 1);
                }
            }
        }
    }

    Repeater {
        id: blackNotesLabels
        model: blackNotes.length
        Rectangle {
            id: note
            color: "black"
            border.color: "black"
            width: blackWidth
            height: blackHeight
            x: blacks[index] * piano.width / 184
            Rectangle {
                width: height
                height: labelSquareSize
                y: parent.height - height - 5
                x: (blackWidth - labelSquareSize)/2
                color: colorBlackNotes[index]
                border.color: "black"
                border.width: 2
                radius: 5
                visible: blackLabelsVisible
                GCText {
                    anchors.fill: parent
                    text: blackNotes[index]
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MultiPointTouchArea {
                anchors.fill: parent
                onPressed: {
                    noteClicked(-index - 1);
                }
            }
        }
    }
}
