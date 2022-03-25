/* GCompris - dataset_01.qml
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

QtObject {
    property var levels: [
        {
            "clef": "Treble",
            "sequence": ["C4", "G4"]
        },
        {
            "clef": "Bass",
            "sequence": ["C3", "F3"]
        },
        {
            "clef": "Treble",
            "sequence": ["B3", "D4", "F4", "A4"]
        },
        {
            "clef": "Bass",
            "sequence": ["B2", "D3","E3", "G3"]
        },
        {
            "clef": "Treble",
            "sequence": ["C5", "G5"]
        },
        {
            "clef": "Bass",
            "sequence": ["C2", "F2"]
        },
        {
            "clef": "Treble",
            "sequence": ["B4", "D5", "F5", "A5"]
        },
        {
            "clef": "Bass",
            "sequence": ["B1", "D2","E2", "G2"]
        },
        {
            "clef": "Treble",
            "sequence": ["E4", "E5"]
        },
        {
            "clef": "Bass",
            "sequence": ["B3", "D4"]
        },
        {
            "clef": "Treble",
            "sequence": ["G3", "C6"]
        },
        {
            "clef": "Bass",
            "sequence": ["A2", "A3", "C4", "E4"]
        },
        {
            "clef": "Treble",
            "sequence": ["F3", "A3"]
        },
        {
            "clef": "Bass",
            "sequence": ["G4", "A4"]
        },
        {
            "clef": "Treble",
            "sequence": ["B5", "D5"]
        },
        {
            "clef": "Bass",
            "sequence": ["B4"]
        },
        {
            "clef": "Treble",
            "sequence": ["D3", "E3"]
        },
        {
            "clef": "Bass",
            "sequence": ["F1", "G1", "A1"]
        }
    ]
    property string objective: qsTr("This activity will teach you to read notes from F1 in bass clef up to D6 in treble clef.<br>On each level you will learn new notes and practice the ones you have already learned.<br>Reference notes are colored in red and will help you to read the notes placed around them.")
    property var referenceNotes: {
        "Treble": ["C", "G"],
        "Bass": ["F", "C"]
    }
}
