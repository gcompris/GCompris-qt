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
import "piano_composition.js" as Activity

Item {
    id: multipleStaff

    property int nbStaves
    property string clef
    property int distanceBetweenStaff: multipleStaff.height / 4

    property int currentStaff: 0

    property int nbMaxNotesPerStaff: 6

    // Stores the note number which is to be replaced.
    property int noteToReplace: -1
    property bool noteIsColored
    property bool isMetronomeDisplayed: false

    property alias flickableStaves: flickableStaves
    property real flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 2

    signal noteClicked(string noteName, string noteType, int noteIndex)
    signal pushToUndoStack(int noteIndex, string oldNoteName, string oldNoteType)
    signal notePlayed(string noteName)

    ListModel {
        id: notesModel
    }

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
            anchors.topMargin: flickableTopMargin
            Repeater {
                id: staves
                model: nbStaves
                Staff {
                    id: staff
                    clef: multipleStaff.clef
                    height: multipleStaff.height / 5
                    width: multipleStaff.width - 5
                    lastPartition: index == (nbStaves - 1)
                    isMetronomeDisplayed: multipleStaff.isMetronomeDisplayed
                }
            }
        }

        property real newNoteWidth: (multipleStaff.width - 15 - staves.itemAt(0).clefImageWidth) / 10
        Repeater {
            id: notesRepeater
            model: notesModel
            Note {
                noteName: noteName_
                noteType: noteType_
                highlightWhenPlayed: highlightWhenPlayed
                noteIsColored: multipleStaff.noteIsColored
                width: flickableStaves.newNoteWidth
                height: multipleStaff.height / 5

                readonly property int currentStaffNb: index / nbMaxNotesPerStaff

                x: staves.itemAt(0).clefImageWidth + ((index % nbMaxNotesPerStaff) * flickableStaves.newNoteWidth)

                noteDetails: Activity.getNoteDetails(noteName, noteType)

                MouseArea {
                    id: noteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: multipleStaff.noteClicked(noteName, noteType, index)
                }

                function highlightNote() {
                    highlightTimer.start()
                }

                y: {
                    if(noteDetails === undefined || staves.itemAt(currentStaffNb) == undefined)
                        return 0

                    var verticalDistanceBetweenLines = staves.itemAt(0).verticalDistanceBetweenLines
                    var shift =  -verticalDistanceBetweenLines / 2
                    var relativePosition = noteDetails.positionOnStaff
                    var imageY = flickableTopMargin + staves.itemAt(currentStaffNb).y + 2 * verticalDistanceBetweenLines

                    if(rotation === 180) {
                        return imageY - (4 - relativePosition) * verticalDistanceBetweenLines + shift
                    }

                    return imageY - (6 - relativePosition) * verticalDistanceBetweenLines + shift
                }
            }
        }
    }

    function calculateTimerDuration(noteType) {
        noteType = noteType.toLowerCase()
        if(noteType === "whole")
            return 2000
        else if(noteType === "half")
            return 1500
        else if(noteType === "quarter")
            return 1000
        else
            return 812.5
    }

    function addNote(noteName, noteType, highlightWhenPlayed, playAudio, isReplacing) {
        var duration
        if(noteType === "Rest")
            duration = calculateTimerDuration(noteName)
        else
            duration = calculateTimerDuration(noteType)

        if(!isReplacing) {
            pushToUndoStack(notesModel.count, "none", "none", noteName, noteType)
            notesModel.append({"noteName_": noteName, "noteType_": noteType, "mDuration": duration,
                             "highlightWhenPlayed": highlightWhenPlayed})
        }
        else {
            var oldNoteDetails = notesModel.get(noteToReplace)
            pushToUndoStack(noteToReplace, oldNoteDetails.noteName_, oldNoteDetails.noteType_)
            notesModel.set(noteToReplace, { "noteName_": noteName, "noteType_": noteType, "mDuration": duration })
        }

        if(notesModel.count > nbMaxNotesPerStaff * nbStaves) {
            var melody = getAllNotes()
            nbStaves++
            flickableStaves.flick(0, - nbStaves * multipleStaff.height)
            currentStaff = 0
            loadFromData(melody)
        }

        if(playAudio)
            playNoteAudio(noteName, noteType)
    }

    function replaceNote(noteName, noteType) {
        if(noteToReplace != -1) {
            addNote(noteName, noteType, false, true, true)
        }
        noteToReplace = -1
    }

    function eraseNote(noteIndex) {
        var noteLength = notesModel.get(noteIndex).mDuration
        var restName
        if(noteLength === 2000)
            restName = "whole"
        else if(noteLength === 1500)
            restName = "half"
        else if(noteLength === 1000)
            restName = "quarter"
        else
            restName = "eighth"

        var oldNoteDetails = notesModel.get(noteIndex)
        pushToUndoStack(noteIndex, oldNoteDetails.noteName_, oldNoteDetails.noteType_)
        notesModel.set(noteIndex, { "noteName_": restName, "noteType_": "Rest" })
    }

    function eraseAllNotes() {
        notesModel.clear()
        noteToReplace = -1
    }

    function undoChange(undoNoteDetails) {
        if(undoNoteDetails.oldNoteName_ === "none")
            notesModel.remove(undoNoteDetails.noteIndex_)
        else {
            noteToReplace = undoNoteDetails.noteIndex_
            replaceNote(undoNoteDetails.oldNoteName_, undoNoteDetails.oldNoteType_)
        }
        noteToReplace = -1
    }

    function playNoteAudio(noteName, noteType) {
        if(noteType != "Rest") {
            var audioPitchType
            // We should find a corresponding b type enharmonic notation for # type note to play the audio.
            if(noteName[1] === "#") {
                var blackKeysFlat
                var blackKeysSharp
                blackKeysFlat = piano.blackNotesFlat
                blackKeysSharp = piano.blackNotesSharp

                var foundNote = false
                for(var i = 0; (i < blackKeysSharp.length) && !foundNote; i++) {
                    for(var j = 0; j < blackKeysSharp[i].length; j++) {
                        if(blackKeysSharp[i][j][0] === noteName) {
                            noteName = blackKeysFlat[i][j][0]
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
            console.log(noteToPlay)
            items.audioEffects.play(noteToPlay)
        }
    }

    function getAllNotes() {
        var melody = "" + multipleStaff.clef
        for(var i = 0; i < notesModel.count; i ++)
            melody +=  " " + notesModel.get(i).noteName_ + notesModel.get(i).noteType_
        return melody
    }

    function loadFromData(data) {
        eraseAllNotes()
        var melody = data.split(" ")
        background.clefType = melody[0]
        for(var i = 1 ; i < melody.length ; ++ i) {
            var noteLength = melody[i].length
            var noteName = melody[i][0]
            var noteType
            if(melody[i].substring(noteLength - 4, noteLength) === "Rest") {
                noteName = melody[i].substring(0, noteLength - 4)
                noteType = "Rest"
            }
            else if(melody[i][1] === "#" || melody[i][1] === "b") {
                noteType = melody[i].substring(3, melody[i].length)
                noteName += melody[i][1] + melody[i][2];
            }
            else {
                noteType = melody[i].substring(2, melody[i].length)
                noteName += melody[i][1]
            }

            addNote(noteName, noteType, false, false, false)
        }
    }

    function play() {
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
        property int currentNote: 0
        onRunningChanged: {
            if(!running && notesModel.get(currentNote) !== undefined) {
                var currentType = notesModel.get(currentNote).noteType_
                var note = notesModel.get(currentNote).noteName_

                playNoteAudio(note, currentType)

                if(currentType != "Rest")
                    multipleStaff.notePlayed(note)

                musicTimer.interval = notesModel.get(currentNote).mDuration
                notesRepeater.itemAt(currentNote).highlightNote()
                currentNote ++
                /*
                if(currentNote > nbMaxNotesPerStaff) {
                    if(currentPlayedStaff < nbStaves && currentNote < notesModel.count) {
                        staves.itemAt(currentPlayedStaff).showMetronome = isMetronomeDisplayed
                        staves.itemAt(currentPlayedStaff).playNote(currentNote)
                    }
                }
                **/
                musicTimer.start()
            }
        }
    }
}
