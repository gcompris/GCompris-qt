/* GCompris - MultipleStaff.qml
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
    id: multipleStaff

    property int nbStaves
    property string clef
    property int distanceBetweenStaff: multipleStaff.height / 4

    property int currentStaff: 0

    property int nbMaxNotesPerStaff: 6

    property int firstNoteX: width / 5
    property bool noteIsColored
    property bool isMetronomeDisplayed: false

    property alias flickableStaves: flickableStaves

    signal noteClicked(string noteName, string noteLength)

    Flickable {
        id: flickableStaves
        flickableDirection: Flickable.VerticalFlick
        contentWidth: staffColumn.width
        contentHeight: staffColumn.height + 1.5 * distanceBetweenStaff
        anchors.fill: parent
        clip: true
        Column {
            id: staffColumn
            spacing: distanceBetweenStaff
            anchors.top: parent.top
            anchors.topMargin: multipleStaff.height / 14 + distanceBetweenStaff / 2
            Repeater {
                id: staves
                model: nbStaves
                Staff {
                    id: staff
                    clef: multipleStaff.clef
                    height: multipleStaff.height / 5
                    width: multipleStaff.width - 5
                    lastPartition: index == (nbStaves - 1)
                    nbMaxNotesPerStaff: multipleStaff.nbMaxNotesPerStaff
                    noteIsColored: multipleStaff.noteIsColored
                    isMetronomeDisplayed: multipleStaff.isMetronomeDisplayed
                    firstNoteX: multipleStaff.firstNoteX
                }
            }
        }
    }

    function addNote(noteName, noteType, highlightWhenPlayed, playAudio) {
        if(staves.itemAt(currentStaff).notes.count > nbMaxNotesPerStaff) {
            if(currentStaff + 1 >= nbStaves) {
                var melody = getAllNotes()
                nbStaves++
                flickableStaves.flick(0, - nbStaves * multipleStaff.height)
                currentStaff = 0
                loadFromData(melody)
            }
            currentStaff++
        }

        staves.itemAt(currentStaff).addNote(noteName, noteType, highlightWhenPlayed)
        if(playAudio)
            playNoteAudio(noteName, noteType)
    }

    function playNoteAudio(noteName, noteLength) {
        var audioPitchType
        // We should find a corresponding b type enharmonic notation for # type note to play the audio.
        if(noteName[1] === "#") {
            var pianoBlackKeysFlat
            var pianoBlackKeysSharp
            if(background.clefType === "treble") {
                pianoBlackKeysFlat = piano.blackNotesFlatTreble
                pianoBlackKeysSharp = piano.blackNotesSharpTreble
            }
            else {
                pianoBlackKeysFlat = piano.blackNotesFlatBass
                pianoBlackKeysSharp = piano.blackNotesSharpBass
            }

            var foundNote = false
            for(var i = 0; (i < pianoBlackKeysSharp.length) && !foundNote; i++) {
                for(var j = 0; j < pianoBlackKeysSharp[i].length; j++) {
                    if(pianoBlackKeysSharp[i][j][0] === noteName) {
                        noteName = pianoBlackKeysFlat[i][j][0]
                        foundNote = true
                        break
                    }
                }
            }

            audioPitchType = parseInt(noteName[2])
        }
        else if(noteName[1] === "b")
            audioPitchType = parseInt(noteName[2])
        else
            audioPitchType = parseInt(noteName[1])

        if(audioPitchType > 3)
            audioPitchType = "treble"
        else
            audioPitchType = "bass"
        var noteToPlay = "qrc:/gcompris/src/activities/piano_composition/resource/" + audioPitchType + "_pitches/" + noteName + ".wav"
        items.audioEffects.play(noteToPlay)
    }

    function getAllNotes() {
        var melody = "" + multipleStaff.clef
        for(var i = 0; i < nbStaves; i ++) {
            var staveNotes = staves.itemAt(i).notes
            for(var j = 0; j < staveNotes.count; j++) {
                melody +=  " " + staveNotes.get(j).noteName_ + staveNotes.get(j).noteType_
            }
        }
        return melody
    }

    function loadFromData(data) {
        eraseAllNotes()
        var melody = data.split(" ");
        multipleStaff.clef = melody[0];
        for(var i = 1 ; i < melody.length ; ++ i) {
            var noteLength = melody[i].length;
            var noteName = melody[i][0]
            var noteType
            if(melody[i][1] === "#" || melody[i][1] === "b") {
                noteType = melody[i].substring(3, melody[i].length)
                noteName += melody[i][1] + melody[i][2];
            }
            else {
                noteType = melody[i].substring(2, melody[i].length)
                noteName += melody[i][1]
            }

            addNote(noteName, noteType, false, false)
        }
    }

    function eraseAllNotes() {
        for(var v = 0 ; v <= currentStaff ; ++ v)
            staves.itemAt(v).eraseAllNotes();
        currentStaff = 0;
    }

    function play() {
        musicTimer.currentPlayedStaff = 0
        musicTimer.currentNote = 0
        musicTimer.interval = 500
        for(var v = 1 ; v < currentStaff ; ++ v)
            staves.itemAt(v).showMetronome = false
        // Only display metronome if we want to
        staves.itemAt(0).showMetronome = isMetronomeDisplayed

        musicTimer.start()
    }

    Timer {
        id: musicTimer
        property int currentPlayedStaff: 0
        property int currentNote: 0
        onRunningChanged: {
            if(!running && staves.itemAt(currentPlayedStaff) != undefined && staves.itemAt(currentPlayedStaff).notes.get(currentNote) !== undefined) {
                var currentType = staves.itemAt(currentPlayedStaff).notes.get(currentNote).noteType_
                var note = staves.itemAt(currentPlayedStaff).notes.get(currentNote).noteName_

                playNoteAudio(note, currentType)

                if(currentNote == 0) {
                    staves.itemAt(currentPlayedStaff).initMetronome();
                }
                musicTimer.interval = staves.itemAt(currentPlayedStaff).notes.get(currentNote).mDuration
                staves.itemAt(currentPlayedStaff).notesRepeater.itemAt(currentNote).highlightNote()
                currentNote ++
                if(currentNote > nbMaxNotesPerStaff) {
                    currentNote = 0
                    currentPlayedStaff ++
                    if(currentPlayedStaff < nbStaves && currentNote < staves.itemAt(currentPlayedStaff).notes.count) {
                        staves.itemAt(currentPlayedStaff).showMetronome = isMetronomeDisplayed
                        if(currentPlayedStaff > 0)
                            staves.itemAt(currentPlayedStaff - 1).showMetronome = false
                        staves.itemAt(currentPlayedStaff).playNote(currentNote)
                    }
                }
                musicTimer.start()
            }
        }
    }
}
