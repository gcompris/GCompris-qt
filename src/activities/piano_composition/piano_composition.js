/* GCompris - piano_composition.js
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
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/piano_composition/NoteNotations.js" as NoteNotations

var currentLevel = 0
var numberOfLevel = 7
var items
var notesDetails = NoteNotations.get()
var userDir = "file://" + GCompris.ApplicationInfo.getSharedWritablePath() + "/" + "piano_composition"
var userFile = userDir + "/melodies.json"
var undoStack = []
var undidChange = false
var instructions = [{
        "text": qsTr("This is the treble cleff staff for high pitched notes")
    },
    {
        "text": qsTr("This is the bass cleff staff for low pitched notes")
    },
    {
        "text": qsTr("Click on the note symbols to write different length notes such as quarter notes, half notes and whole notes")
    },
    {
        "text": qsTr("The black keys are sharp and flat keys, have a # sign.")
    },
    {
        "text": qsTr("Each black key has two names: flat and sharp. Flat notes have b sign")
    },
    {
        "text": qsTr("Now you can load music")

    },
    {
        "text": qsTr("Now you can compose your own music")
    }
]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function saveMelody() {
    var notes = items.multipleStaff.getAllNotes()
    if (!items.file.exists(userDir)) {
        if (!items.file.mkpath(userDir))
            console.error("Could not create directory " + userDir);
        else
            console.debug("Created directory " + userDir);
    }

    var data = items.file.read(userFile)
    if (!items.file.append(JSON.stringify(notes), userFile)) {
        Core.showMessageDialog(items.background,
            qsTr("Error saving melody to your file (%1)")
            .arg(userFile),
            "", null, "", null, null);
    } else {
        Core.showMessageDialog(items.background,
            qsTr("Saved melody to your file (%1)")
            .arg(userFile),
            "", null, "", null, null);
    }
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.piano.currentOctaveNb = items.piano.defaultOctaveNb
    items.multipleStaff.nbStaves = 2
    items.background.staffMode = "add"
    items.multipleStaff.noteToReplace.noteNumber = -1
    items.multipleStaff.noteToReplace.staffNumber = -1
    items.staffModesOptions.currentIndex = 0
    undoStack = []
}

function pushToStack(noteIndex, staffIndex, oldNoteName, oldNoteType, newNoteName, newNoteType) {
    undoStack.push({"noteIndex_": noteIndex, "staffIndex_": staffIndex,
                    "oldNoteName_": oldNoteName, "oldNoteType_": oldNoteType})
    // Maintain most recent 5 changes. Remove older ones (stack behaves as queue here).
    if(undoStack.length > 5)
        undoStack.shift()
}

function undoChange() {
    if(undoStack.length > 0) {
        var undoNoteDetails = undoStack[undoStack.length - 1]
        undoStack.pop()
        if(undoNoteDetails.noteName_ != "none")
            undidChange = true
        items.multipleStaff.undoChange(undoNoteDetails)
    }
}

function getNoteDetails(noteName, noteType) {
    var clef = items.background.clefType === 'treble' ? "Treble" : "Bass"
    var noteNotation
    if(noteType === "Rest")
        noteNotation = noteName + noteType
    else
        noteNotation = clef + noteName
    console.log(noteNotation)
    for(var i = 0; i < notesDetails.length; i++) {
        if(noteNotation === notesDetails[i].noteName) {
            return notesDetails[i]
        }
    }
}

function nextLevel() {
    items.multipleStaff.eraseAllNotes()
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    items.multipleStaff.eraseAllNotes()
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}
