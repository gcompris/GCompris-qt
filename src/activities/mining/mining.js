/* GCompris - mining.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Peter Albrecht <pa-dev@gmx.de> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/mining/resource/"

var numberOfLevel = 3
var items

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function getItem(source) {
    return {
        source: source ?
                    url + source + ".svg" :
                    "",
        rotation: Math.floor(Math.random() * 180) - 90,
        sizeFactor: 0.2 + Math.random() * 0.8,
        isTarget: source === "sparkle"
    }
}

function createLevel() {
    var miningItems = new Array()
    for(var i = 0; i < 16; i++) {
        var index = (Math.floor(Math.random() * 16) + 1)
        if(index < 5)
            miningItems[i] = getItem("stone" + (Math.floor(Math.random() * 4) + 1))
        else
            miningItems[i] = getItem("")
    }
    // Place the sparkle
    // The Grid is 4*4. The borders are harder to get so we allow them only on higher levels.
    if(items.currentLevel < 1) {
        var choices = [5, 6, 9, 10]
        miningItems[choices[(Math.floor(Math.random() * 4))]] = getItem("sparkle")
    } else {
        miningItems[(Math.floor(Math.random() * 12))] = getItem("sparkle")
    }
    items.mineModel = miningItems
    items.rainbowSound.play()
}

function resetSetup() {
    items.gotIt = false
    items.miningBg.anchors.horizontalCenterOffset = 0
    items.miningBg.anchors.verticalCenterOffset = 0
    items.miningBg.scale = items.miningBg._MIN_SCALE
}

function initLevel() {
    items.collectedNuggets = 0
    resetSetup()
    items.tuto.setState("Started")
    switch(items.currentLevel) {
        case 0:
            items.miningBg.maxSubLevel = 2
            break
        case 1:
            items.miningBg.maxSubLevel = 4
            break
        case 2:
            items.miningBg.maxSubLevel = 10
            break
    }
    createLevel()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
