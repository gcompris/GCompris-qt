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
import QtQuick 2.6
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
        id: whiteKeyRepeater
        model: whiteNotes.length
        PianoKey {
            color: "white"
            width: whiteWidth
            height: whiteHeight
            x: index * whiteWidth
            labelSquareSize: piano.labelSquareSize
            noteColor: colorWhiteNotes[index]
            keyName: whiteNotes[index]
            labelsVisible: whiteLabelsVisible
            onKeyPressed: noteClicked(index + 1)
        }
    }

    Repeater {
        id: blackKeyRepeater
        model: blackNotes.length
        PianoKey {
            color: "black"
            width: blackWidth
            height: blackHeight
            x: blacks[index] * piano.width / 184
            labelSquareSize: piano.labelSquareSize
            noteColor: colorBlackNotes[index]
            keyName: blackNotes[index]
            labelsVisible: blackLabelsVisible
            onKeyPressed: noteClicked(-index - 1)
        }
    }
}
