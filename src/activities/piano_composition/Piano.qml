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
    z: 3

    width: numberOfWhite * 23 // 23 is default width
    height: 120

    property alias whiteKeyRepeater: whiteKeyRepeater
    property alias blackKeyRepeater: blackKeyRepeater

    property int numberOfWhite: 8
    property int currentOctaveNb: defaultOctaveNb
    readonly property int defaultOctaveNb: background.clefType === "treble" ? 1 : 0
    readonly property int maxNbOctaves: whiteNotes.length

    onDefaultOctaveNbChanged: currentOctaveNb = defaultOctaveNb

    property int whiteWidth: width / numberOfWhite // 23
    property int whiteHeight: height // 120
    property int blackWidth: (whiteWidth + 1) / 2 // 13
    property int blackHeight: 2 * height / 3 // 80

    // White key notes are from C3 to G4 when the clef is bass
    //: Translators, C, D, E, F, G, A and B are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C4 is a C note in the 4th octave.
    readonly property var whiteNotesBass: [
        [["C3", qsTr("C%1").arg(3)], ["D3", qsTr("D%1").arg(3)], ["E3", qsTr("E%1").arg(3)], ["F3", qsTr("F%1").arg(3)], ["G3", qsTr("G%1").arg(3)], ["A3", qsTr("A%1").arg(3)], ["B3", qsTr("B%1").arg(3)], ["C4", qsTr("C%1").arg(4)]],
        [["G3", qsTr("G%1").arg(3)], ["A3", qsTr("A%1").arg(3)], ["B3", qsTr("B%1").arg(3)], ["C4", qsTr("C%1").arg(4)], ["D4", qsTr("D%1").arg(4)], ["E4", qsTr("E%1").arg(4)], ["F4", qsTr("F%1").arg(4)], ["G4", qsTr("G%1").arg(4)]]
    ]
    // White key notes are from G3 to C6 when the clef is treble
    //: Translators, C, D, E, F, G, A and B are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C4 is a C note in the 4th octave.
    readonly property var whiteNotesTreble: [
        [["G3", qsTr("G%1").arg(3)], ["A3", qsTr("A%1").arg(3)], ["B3", qsTr("B%1").arg(3)], ["C4", qsTr("C%1").arg(4)], ["D4", qsTr("D%1").arg(4)], ["E4", qsTr("E%1").arg(4)], ["F4", qsTr("F%1").arg(4)], ["G4", qsTr("G%1").arg(4)]],
        [["C4", qsTr("C%1").arg(4)], ["D4", qsTr("D%1").arg(4)], ["E4", qsTr("E%1").arg(4)], ["F4", qsTr("F%1").arg(4)], ["G4", qsTr("G%1").arg(4)], ["A4", qsTr("A%1").arg(4)], ["B4", qsTr("B%1").arg(4)], ["C5", qsTr("C%1").arg(5)]],
        [["C5", qsTr("C%1").arg(5)], ["D5", qsTr("D%1").arg(5)], ["E5", qsTr("E%1").arg(5)], ["F5", qsTr("F%1").arg(5)], ["G5", qsTr("G%1").arg(5)], ["A5", qsTr("A%1").arg(5)], ["B5", qsTr("B%1").arg(5)], ["C6", qsTr("C%1").arg(6)]]
    ]
    readonly property var whiteNotes: background.clefType === "treble" ? whiteNotesTreble : whiteNotesBass

    // Sharp black key notes when the clef is bass.
    //: Translators, C#, D#, F#, G#, and A# are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C#4 is a C# note in the 4th octave.
    readonly property var blackNotesSharpBass: [
        [["C#3", qsTr("C#%1").arg(3)], ["D#3", qsTr("D#%1").arg(3)], ["F#3", qsTr("F#%1").arg(3)], ["G#3", qsTr("G#%1").arg(3)], ["A#3", qsTr("A#%1").arg(3)]],
        [["G#3", qsTr("G#%1").arg(3)], ["A#3", qsTr("A#%1").arg(3)], ["C#4", qsTr("C#%1").arg(4)], ["D#4", qsTr("D#%1").arg(4)], ["F#4", qsTr("F#%1").arg(4)]]
    ]

    // Sharp black key notes when the clef is treble
    //: Translators, C#, D#, F#, G#, and A# are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C#4 is a C# note in the 4th octave.
    readonly property var blackNotesSharpTreble: [
        [["G#3", qsTr("G#%1").arg(3)], ["A#3", qsTr("A#%1").arg(3)], ["C#4", qsTr("C#%1").arg(4)], ["D#4", qsTr("D#%1").arg(4)], ["F#4", qsTr("F#%1").arg(4)]],
        [["C#4", qsTr("C#%1").arg(4)], ["D#4", qsTr("D#%1").arg(4)], ["F#4", qsTr("F#%1").arg(4)], ["G#4", qsTr("G#%1").arg(4)], ["A#4", qsTr("A#%1").arg(4)]],
        [["C#5", qsTr("C#%1").arg(5)], ["D#5", qsTr("D#%1").arg(5)], ["F#5", qsTr("F#%1").arg(5)], ["G#5", qsTr("G#%1").arg(5)], ["A#5", qsTr("A#%1").arg(5)]]
    ]
    readonly property var blackNotesSharp: background.clefType === "treble" ? blackNotesSharpTreble : blackNotesSharpBass

    // Flat black key notes when the clef is bass.
    //: Translators, Db, Eb, Gb, Ab, Bb are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, Db4 is a Db note in the 4th octave.
    readonly property var blackNotesFlatBass: [
        [["Db3", qsTr("Db%1").arg(3)], ["Eb3", qsTr("Eb%1").arg(3)], ["Gb3", qsTr("Gb%1").arg(3)], ["Ab3", qsTr("Ab%1").arg(3)], ["Bb3", qsTr("Bb%1").arg(3)]],
        [["Ab3", qsTr("Ab%1").arg(3)], ["Bb3", qsTr("Bb%1").arg(3)], ["Db4", qsTr("Db%1").arg(4)], ["Eb4", qsTr("Eb%1").arg(4)], ["Gb4", qsTr("Gb%1").arg(4)]]
    ]

    // Flat black key notes when the clef is treble.
    //: Translators, Db, Eb, Gb, Ab, Bb are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, Db4 is a Db note in the 4th octave.
    readonly property var blackNotesFlatTreble: [
        [["Ab3", qsTr("Ab%1").arg(3)], ["Bb3", qsTr("Bb%1").arg(3)], ["Db4", qsTr("Db%1").arg(4)], ["Eb4", qsTr("Eb%1").arg(4)], ["Gb4", qsTr("Gb%1").arg(4)]],
        [["Db4", qsTr("Db%1").arg(4)], ["Eb4", qsTr("Eb%1").arg(4)], ["Gb4", qsTr("Gb%1").arg(4)], ["Ab4", qsTr("Ab%1").arg(4)], ["Bb4", qsTr("Bb%1").arg(4)]],
        [["Db5", qsTr("Db%1").arg(5)], ["Eb5", qsTr("Eb%1").arg(5)], ["Gb5", qsTr("Gb%1").arg(5)], ["Ab5", qsTr("Ab%1").arg(5)], ["Bb5", qsTr("Bb%1").arg(5)]]
    ]
    readonly property var blackNotesFlat: background.clefType === "treble" ? blackNotesFlatTreble : blackNotesFlatBass

    // Black note labels used, can be sharp or flat
    readonly property var blackNotes: useSharpNotation ? blackNotesSharp : blackNotesFlat

    // Positions of black keys when the clef is treble
    readonly property var blacksTreble: [
        [14.33, 41.67, 82.25, 108.25, 154],
        [14.33, 41.67, 82.25, 108.25, 134.75],
        [14.33, 41.67, 82.25, 108.25, 134.75]
    ]
    // Positions of black keys when the clef is bass
    readonly property var blacksBass: [
        [14.33, 41.67, 82.25, 108.25, 134.75],
        [14.33, 41.67, 82.25, 108.25, 154],
    ]
    readonly property var blacks: background.clefType === "treble" ? blacksTreble : blacksBass

    // Color of white key labels when the clef is bass
    readonly property var colorWhiteNotesBass: [
        ["#FF0000", "#FF7F00", "#FFFF00", "#32CD32", "#6495ED", "#D02090", "#FF1493", "#FF0000"],
        ["#6495ED", "#D02090", "#FF1493", "#FF0000", "#FF7F00", "#FFFF00", "#32CD32", "#6495ED"],
    ]
    // Color of white key labels when the clef is treble
    readonly property var colorWhiteNotesTreble: [
        ["#6495ED", "#D02090", "#FF1493", "#FF0000", "#FF7F00", "#FFFF00", "#32CD32", "#6495ED"],
        ["#FF0000", "#FF7F00", "#FFFF00", "#32CD32", "#6495ED", "#D02090", "#FF1493", "#FF0000"],
        ["#FF0000", "#FF7F00", "#FFFF00", "#32CD32", "#6495ED", "#D02090", "#FF1493", "#FF0000"]
    ]
    readonly property var colorWhiteNotes: background.clefType === "treble" ? colorWhiteNotesTreble : colorWhiteNotesBass

    // Color of black key labels when the clef is bass
    readonly property var colorBlackNotesBass: [
        ["#FF6347", "#FFD700", "#20B2AA", "#8A2BE2", "#FF00FF"],
        ["#8A2BE2", "#FF00FF", "#FF6347", "#FFD700", "#20B2AA"]
    ]
    // Color of black key labels when the clef is treble
    readonly property var colorBlackNotesTreble: [
        ["#8A2BE2", "#FF00FF", "#FF6347", "#FFD700", "#20B2AA"],
        ["#FF6347", "#FFD700", "#20B2AA", "#8A2BE2", "#FF00FF"],
        ["#FF6347", "#FFD700", "#20B2AA", "#8A2BE2", "#FF00FF"]
    ]
    readonly property var colorBlackNotes: background.clefType === "treble" ? colorBlackNotesTreble : colorBlackNotesBass

    signal noteClicked(string note)

    property bool blackLabelsVisible: true
    property bool whiteLabelsVisible: true
    property bool useSharpNotation: true
    property int labelSquareSize: whiteWidth - 5

    Repeater {
        id: whiteKeyRepeater
        model: whiteNotes[currentOctaveNb].length
        PianoKey {
            color: "white"
            width: whiteWidth
            height: whiteHeight
            x: index * whiteWidth
            labelSquareSize: piano.labelSquareSize
            noteColor: colorWhiteNotes[currentOctaveNb][index]
            keyName: whiteNotes[currentOctaveNb][index][1]
            labelsVisible: whiteLabelsVisible
            onKeyPressed: noteClicked(whiteNotes[currentOctaveNb][index][0])
        }
    }

    Repeater {
        id: blackKeyRepeater
        model: Object.keys(blackNotes[currentOctaveNb]).length
        PianoKey {
            color: "black"
            width: blackWidth
            height: blackHeight
            x: blacks[currentOctaveNb][index] * piano.width / 184
            labelSquareSize: piano.labelSquareSize
            noteColor: colorBlackNotes[currentOctaveNb][index]
            keyName: blackNotes[currentOctaveNb][index][1]
            labelsVisible: blackLabelsVisible
            onKeyPressed: {
                if(blackLabelsVisible)
                    noteClicked(blackNotes[currentOctaveNb][index][0])
            }
        }
    }

    function indicateKey(noteName) {
        var noteFound = false
        if(noteName[1] === "#") {
            for(var i = 0; i < blackNotesSharp.length && !noteFound; i++) {
                for(var j = 0; j < blackNotesSharp[i].length; j++) {
                    if(noteName === blackNotesSharp[i][j][0]) {
                        noteFound = true
                        useSharpNotation = true
                        currentOctaveNb = i
                        blackKeyRepeater.itemAt(j).indicateKey()
                        break
                    }
                }
            }
        }
        else if(noteName[1] === "b") {
            for(var i = 0; i < blackNotesFlat.length && !noteFound; i++) {
                for(var j = 0; j < blackNotesFlat[i].length; j++) {
                    if(noteName === blackNotesFlat[i][j][0]) {
                        noteFound = true
                        useSharpNotation = false
                        currentOctaveNb = i
                        blackKeyRepeater.itemAt(j).indicateKey()
                        break
                    }
                }
            }
        }
        else {
            for(var i = 0; i < whiteNotes.length && !noteFound; i++) {
                for(var j = 0; j < whiteNotes[i].length; j++) {
                    if(noteName === whiteNotes[i][j][0]) {
                        noteFound = true
                        currentOctaveNb = i
                        whiteKeyRepeater.itemAt(j).indicateKey()
                        break
                    }
                }
            }
        }
    }
}
