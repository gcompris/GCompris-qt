/* GCompris - lightsoff.js
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
var levels
var currentLevel = 0
var numberOfLevel
var items
var table
var soluc
var showSoluce = false
var size = 5

var url = "qrc:/gcompris/src/activities/lightsoff/resource/"

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.levels.length
    initLevel()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1

    /* Is it a static or dynamic level ? */
    if (items.levels[currentLevel].dynamic) {
        /* Dynamic */
        size = items.levels[currentLevel].size
        table = new Array(size * size)
        soluc = new Array(size * size)
        for (var i = 0; i < size * size; ++i) {
            table[i] = 0
            soluc[i] = 0
        }

        for (var j = 0; j < currentLevel; ++j) {
            switchLightNoCheck(Math.floor(size * size * Math.random()))
        }
    } else {
        /* Static */
        size = items.levels[currentLevel].size
        table = items.levels[currentLevel].level.slice(0)
        soluc = items.levels[currentLevel].solution.slice(0)
    }
    showSoluce = false
    items.modelTable.clear()
    items.nbCell = size
    refreshModel()
    checkResult()
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}

function switchLightNoCheck(index) {
    /* Switch the selected item */
    table[index] = 1 - table[index]

    /* Switch the soluce */
    soluc[index] = 1 - soluc[index]

    /* Switch neighbor left */
    if (index % size !== 0)
        table[index - 1] = 1 - table[index - 1]

    /* Switch neighbor right */
    if (index % size !== size - 1)
        table[index + 1] = 1 - table[index + 1]

    /* Switch neighbor up */
    if (index > size - 1)
        table[index - size] = 1 - table[index - size]

    /* Switch neighbor down */
    if (index < size * size -size)
        table[index + size] = 1 - table[index + size]
}

function refreshModel() {
    for (var i = 0; i < size * size; ++i) {
        items.modelTable.set(i, { 'lighton': table[i],  'soluce': showSoluce ? soluc[i] : 0})
    }
}

function switchLight(index) {
    /* Switch the selected item */
    switchLightNoCheck(index)

    /* Refresh the lights */
    refreshModel()

    /* Check the result */
    checkResult()
}

function checkResult() {
    /* Check the result */
    var nb = 0
    table.forEach(function (entry) {
        nb += entry
    })

    if (nb === 0) {
        items.blockClicks = true
        items.bonus.good("tux")
    }

    /* Check the soluce */
    items.nbCelToWin = nb
}

function solve() {
    showSoluce = !showSoluce

    /* Refresh the lights */
    refreshModel()
}

function windowPressed(index) {
    audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
    switchLight(index)
}
