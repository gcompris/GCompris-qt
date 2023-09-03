/* GCompris - template.js
 *
 * SPDX-FileCopyrightText: YEAR NAME <EMAIL>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 4
var items

function start(items_) {
    items = items_;
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel();
}

function stop() {
}

function initLevel() {
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
