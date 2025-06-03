/* GCompris - server.js
 *
 * Copyright (C) 2023
 * Authors:
 *   Bruno Anselme <be.root@gfree.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/**
 * @file
 * Contains commonly used javascript methods.
 * @ingroup components
 *
 * FIXME: how to include this file in kgenapidox's output?
 */
.pragma library
.import QtQml as Qml
.import core 1.0 as GCompris

var aboutToQuit = false;
/**
 * Central function for quitting GCompris.
 *
 * Should be used everywhere instead of Qt.quit()
 * Call Qt.quit() itself upon confirmation.
 *
 * @param parent QML parent object used for the dynamic dialog.
 */
function quit(parent)
{
    if (aboutToQuit)  // don't execute concurrently
        return;
    aboutToQuit = true;
    Qt.quit();
}

function shortActivityName(str) {
    return str.replace(/\/.*/, "")
}

// Copy, should be removed from core.js
function getPasswordImages() {
    return [ "apple", "banana", "cherries", "lemon", "orange", "pear", "pineapple", "plum" ]
}

/**
 * Shuffle the array @p o and returns it.
 *
 * @param o Array to shuffle.
 * @returns A shuffled array.
 */
// Copy from core.js
function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

function debug_model(model) {
    for (var i = 0; i < model.count; i++) {
        console.warn(JSON.stringify(model.get(i)))
    }
}
