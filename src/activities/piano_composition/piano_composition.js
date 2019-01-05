/* GCompris - piano_composition.js
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
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
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 7
var items
var userDir = "file://" + GCompris.ApplicationSettings.userDataPath + "/" + "piano_composition"
var userFile = userDir + "/melodies.json"
var undoStack = []
var instructions = [{
        "text": qsTr("This is the treble clef staff for high pitched notes.")
    },
    {
        "text": qsTr("This is the bass clef staff for low pitched notes.")
    },
    {
        "text": qsTr("The black keys are sharp and flat keys. Sharp notes have a ♯ sign.")
    },
    {
        "text": qsTr("Each black key has two names: flat and sharp. Flat notes have ♭ sign.")
    },
    {
        "text": qsTr("Click on the note symbol to write different length notes such as whole notes, half notes, quarter notes and eighth notes.")
    },
    {
        "text": qsTr("Rests are equivalent to notes during which silence is maintained. Click on the rest symbol to select the rest length and then click on the add button to enter it to the staff.")
    },
    {
        "text": qsTr("Now you can load music and also save your composed one.")
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

    if(items.file.exists(userFile))
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

function stop() {
    items.multipleStaff.stopAudios()
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.multipleStaff.bpmValue = 120

    if(items.bar.level === 2) {
        items.background.clefType = "Bass"
        items.piano.currentOctaveNb = 0
    }
    else {
        items.background.clefType = "Treble"
        items.piano.currentOctaveNb = 1
    }

    items.multipleStaff.initClefs(items.background.clefType)

    if(items.bar.level === 4)
        items.piano.useSharpNotation = false
    else
        items.piano.useSharpNotation = true

    items.multipleStaff.nbStaves = 2
    items.optionsRow.noteOptionsIndex = 2
    items.background.currentType = "Quarter"
    items.lyricsArea.resetLyricsArea()
    undoStack = []
}

function pushToStack(data) {
    undoStack.push(data)
    // Maintain most recent 5 changes. Remove older ones (stack behaves as queue here).
    if(undoStack.length > 5)
        undoStack.shift()
}

function undoChange() {
    if(undoStack.length > 0) {
        var undoState = undoStack[undoStack.length - 1]
        undoStack.pop()
        items.multipleStaff.redraw(undoState)
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
