/* GCompris - PianoOctaveKeyboard.qml
*
* SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
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

Item {
    id: piano
    z: 3

    property alias keyRepeater: keyRepeater

    property int numberOfWhite: 7
    property int currentOctaveNb: 0
    readonly property int maxNbOctaves: whiteKeyNoteLabels.length

    property real whiteWidth: width / numberOfWhite // 23
    property real whiteHeight: height // 120
    property real blackWidth: (whiteWidth + 1) / 2 // 13
    property real blackHeight: 2 * height / 3 // 80

    property bool leftOctaveVisible: false
    property bool playPianoActivity: false //set to true to specify the offset used for keyboard controls for this activity...

    property var coloredKeyLabels: ['C', 'D', 'E', 'F', 'G', 'A', 'B']
    // When the labelsColor is inbuilt, the default color mapping will be done, else assign any color externally in the activity. Example: Reference keys in note_names are red colored and all other are white.
    property string labelsColor: "inbuilt"

    //: Translators, C, D, E, F, G, A and B are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C4 is a C note in the 4th octave.
    readonly property var whiteKeyNoteLabelsArray: [
        ["F1", qsTr("F%1").arg(1)],
        ["G1", qsTr("G%1").arg(1)],
        ["A1", qsTr("A%1").arg(1)],
        ["B1", qsTr("B%1").arg(1)],
        ["C2", qsTr("C%1").arg(2)],
        ["D2", qsTr("D%1").arg(2)],
        ["E2", qsTr("E%1").arg(2)],
        ["F2", qsTr("F%1").arg(2)],
        ["G2", qsTr("G%1").arg(2)],
        ["A2", qsTr("A%1").arg(2)],
        ["B2", qsTr("B%1").arg(2)],
        ["C3", qsTr("C%1").arg(3)],
        ["D3", qsTr("D%1").arg(3)],
        ["E3", qsTr("E%1").arg(3)],
        ["F3", qsTr("F%1").arg(3)],
        ["G3", qsTr("G%1").arg(3)],
        ["A3", qsTr("A%1").arg(3)],
        ["B3", qsTr("B%1").arg(3)],
        ["C4", qsTr("C%1").arg(4)],
        ["D4", qsTr("D%1").arg(4)],
        ["E4", qsTr("E%1").arg(4)],
        ["F4", qsTr("F%1").arg(4)],
        ["G4", qsTr("G%1").arg(4)],
        ["A4", qsTr("A%1").arg(4)],
        ["B4", qsTr("B%1").arg(4)],
        ["C5", qsTr("C%1").arg(5)],
        ["D5", qsTr("D%1").arg(5)],
        ["E5", qsTr("E%1").arg(5)],
        ["F5", qsTr("F%1").arg(5)],
        ["G5", qsTr("G%1").arg(5)],
        ["A5", qsTr("A%1").arg(5)],
        ["B5", qsTr("B%1").arg(5)],
        ["C6", qsTr("C%1").arg(6)],
        ["D6", qsTr("D%1").arg(6)],
        ["E6", qsTr("E%1").arg(6)],
        ["F6", qsTr("F%1").arg(6)]
    ]

    //: Translators, C♯, D♯, F♯, G♯, and A♯ are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, C♯4 is a C♯ note in the 4th octave.
    readonly property var blackKeySharpNoteLabelsArray: [
        ["C#3", qsTr("C♯%1").arg(3)],
        ["D#3", qsTr("D♯%1").arg(3)],
        ["F#3", qsTr("F♯%1").arg(3)],
        ["G#3", qsTr("G♯%1").arg(3)],
        ["A#3", qsTr("A♯%1").arg(3)],
        ["C#4", qsTr("C♯%1").arg(4)],
        ["D#4", qsTr("D♯%1").arg(4)],
        ["F#4", qsTr("F♯%1").arg(4)],
        ["G#4", qsTr("G♯%1").arg(4)],
        ["A#4", qsTr("A♯%1").arg(4)],
        ["C#5", qsTr("C♯%1").arg(5)],
        ["D#5", qsTr("D♯%1").arg(5)],
        ["F#5", qsTr("F♯%1").arg(5)],
        ["G#5", qsTr("G♯%1").arg(5)],
        ["A#5", qsTr("A♯%1").arg(5)],
        ["C#6", qsTr("C♯%1").arg(6)],
        ["D#6", qsTr("D♯%1").arg(6)]
    ]

    //: Translators, D♭, E♭, G♭, A♭, B♭ are the note notations in English musical notation system. The numbers in the arguments represents the octave number of the note. For instance, D♭4 is a D♭ note in the 4th octave.
    readonly property var blackKeyFlatNoteLabelsArray: [
        ["Db3", qsTr("D♭%1").arg(3)],
        ["Eb3", qsTr("E♭%1").arg(3)],
        ["Gb3", qsTr("G♭%1").arg(3)],
        ["Ab3", qsTr("A♭%1").arg(3)],
        ["Bb3", qsTr("B♭%1").arg(3)],
        ["Db4", qsTr("D♭%1").arg(4)],
        ["Eb4", qsTr("E♭%1").arg(4)],
        ["Gb4", qsTr("G♭%1").arg(4)],
        ["Ab4", qsTr("A♭%1").arg(4)],
        ["Bb4", qsTr("B♭%1").arg(4)],
        ["Db5", qsTr("D♭%1").arg(5)],
        ["Eb5", qsTr("E♭%1").arg(5)],
        ["Gb5", qsTr("G♭%1").arg(5)],
        ["Ab5", qsTr("A♭%1").arg(5)],
        ["Bb5", qsTr("B♭%1").arg(5)],
        ["Db6", qsTr("D♭%1").arg(6)],
        ["Eb6", qsTr("E♭%1").arg(6)]
    ]
    readonly property var blackKeyNoteLabels: useSharpNotation ? blackKeySharpNoteLabelsArray : blackKeyFlatNoteLabelsArray

    readonly property var keyLabelColors: { "C": "#FF0000", "D": "#FF7F00", "E": "#FFFF00", "F": "#32CD32",
                                            "G": "#6495ED", "A": "#D02090", "B": "#FF1493",
                                            "C#": "#FF6347", "D#": "#FFD700", "F#": "#20B2AA", "G#": "#8A2BE2", "A#": "#FF00FF",
                                            "Db": "#FF6347", "Eb": "#FFD700", "Gb": "#20B2AA", "Ab": "#8A2BE2", "Bb": "#FF00FF"}

    // White key notes are from C3 to G4 when the clef is bass
    property var whiteKeyNoteLabelsBass: [
        whiteKeyNoteLabelsArray.slice(11, 18),
        whiteKeyNoteLabelsArray.slice(18, 22)
    ]
    // White key notes are from G3 to C6 when the clef is treble
    property var whiteKeyNoteLabelsTreble: [
        whiteKeyNoteLabelsArray.slice(13, 18),
        whiteKeyNoteLabelsArray.slice(18, 25),
        whiteKeyNoteLabelsArray.slice(25, 32),
        whiteKeyNoteLabelsArray.slice(32, 36)
    ]
    readonly property var whiteKeyNoteLabels: background.clefType === "Treble" ? whiteKeyNoteLabelsTreble : whiteKeyNoteLabelsBass

    signal noteClicked(string note)

    property bool blackLabelsVisible: true
    property bool whiteLabelsVisible: true
    property bool blackKeysEnabled: true
    property bool whiteKeysEnabled: true
    property bool useSharpNotation: true
    property int labelSquareSize: whiteWidth - 5

    Repeater {
        id: keyRepeater
        model: whiteKeyNoteLabels.length ? whiteKeyNoteLabels[currentOctaveNb % whiteKeyNoteLabels.length].length : 0

        property int keyboardOffset: piano.numberOfWhite - whiteKeyNoteLabels[0].length

        function playKey(keyboardKey, color) {
            var keyToPress;
            if(currentOctaveNb === 0 && !piano.playPianoActivity)
                keyToPress = keyboardKey - keyRepeater.keyboardOffset;
            else
                keyToPress = keyboardKey;
            if(itemAt(keyToPress) === null)
                return
            if(color === "white")
                itemAt(keyToPress).whiteKey.keyPressed();
            else if(itemAt(keyToPress).blackKey.visible)
                itemAt(keyToPress).blackKey.keyPressed();
        }

        Item {
            width: whiteWidth
            height: whiteHeight
            x: ((currentOctaveNb === 0) ? (keyRepeater.keyboardOffset + index) : index) * whiteWidth

            property alias whiteKey: whiteKey
            property alias blackKey: blackKey

            PianoKey {
                id: whiteKey
                color: "white"
                width: whiteWidth
                height: whiteHeight
                labelSquareSize: piano.labelSquareSize
                noteColor: keyLabelColors[keyName[0][0]]
                keyName: whiteKeyNoteLabels[currentOctaveNb % whiteKeyNoteLabels.length][index]
                labelsVisible: whiteLabelsVisible
                isKeyEnabled: piano.whiteKeysEnabled
                onKeyPressed: noteClicked(keyName[0])
            }

            PianoKey {
                id: blackKey
                color: "black"
                width: blackWidth
                height: Math.min(blackHeight, whiteHeight - labelSquareSize - 10)
                x: -width / 2
                visible: {
                    if(index || leftOctaveVisible)
                        return (["D", "E", "G", "A", "B"].indexOf(whiteKeyNoteLabels[currentOctaveNb % whiteKeyNoteLabels.length][index][0][0]) != -1)
                    return false
                }
                labelSquareSize: piano.labelSquareSize - 2
                noteColor: keyName ? keyLabelColors[keyName[0].substr(0, 2)] : "black"
                keyName: {
                    for(var i = 0; i < blackKeyFlatNoteLabelsArray.length; i++) {
                        if((blackKeyFlatNoteLabelsArray[i][0][0] === whiteKey.keyName[0][0])
                           && (blackKeyFlatNoteLabelsArray[i][0][2] === whiteKey.keyName[0][1]))
                            return blackKeyNoteLabels[i]
                    }
                    return ""
                }
                labelsVisible: blackLabelsVisible
                isKeyEnabled: piano.blackKeysEnabled
                onKeyPressed: noteClicked(keyName[0])
            }
        }
    }
}
