/* GCompris - template.js
 *
 * SPDX-FileCopyrightText: YEAR NAME <EMAIL>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

function start(items_) {
    items = items_;
    // Make sure items.numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel();
}

function stop() {
}

function initLevel() {
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}
