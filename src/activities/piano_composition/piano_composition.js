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
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 7
var items
var userDir = "file://" + GCompris.ApplicationInfo.getSharedWritablePath() + "/" + "piano_composition"
var userFile = userDir + "/melodies.json"
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
    var notes = items.staff2.getAllNotes()
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
}

function nextLevel() {
    items.staff2.eraseAllNotes()
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.staff2.eraseAllNotes()
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
