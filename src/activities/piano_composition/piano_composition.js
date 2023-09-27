/* GCompris - piano_composition.js
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
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

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
        "text": qsTr("Now you can load music and also save your compositions.")
    }
]

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
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
            qsTr("Melody saved to your file (%1)")
            .arg(userFile),
            "", null, "", null, null);
    }
}

function stop() {
    items.multipleStaff.stopAudios()
}

function initLevel() {
    items.multipleStaff.bpmValue = 120

    if(items.currentLevel === 1) {
        items.background.clefType = "Bass"
        items.piano.currentOctaveNb = 0
    }
    else {
        items.background.clefType = "Treble"
        items.piano.currentOctaveNb = 1
    }

    items.multipleStaff.initClefs(items.background.clefType)

    if(items.currentLevel === 3)
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel()
}

function previousLevel() {
    items.multipleStaff.eraseAllNotes()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel()
}
