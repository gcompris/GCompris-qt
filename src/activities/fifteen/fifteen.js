/* GCompris - fifteen.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/fifteen/resource/"

var numberOfLevel = 13
var items

var palette = [
    "#D40000",
    "#FF0000",
    "#FF5555",
    "#FFAAAA",
    "#FFD5D5",
    "#FF6600",
    "#FFB380",
    "#D4AA00",
    "#FFCC00",
    "#FFE680",
    "#88AA00",
    "#AAD400",
    "#CCFF00",
    "#66FF00",
    "#7FFF2A",
    "#55FFDD"
]

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {

    // Create the initial array that holds the model data sorted
    var model = []
    for(var i = 1; i < 16; i++)
        model.push(i)
    model.push(0)

    scramble(model, [3, 3], (items.currentLevel + 2))

    items.model.clear()
    for(i = 0; i < 16; i++)
        items.model.append(
                    {"value": model[i],
                    "fcolor": palette[model[i]]}
                    )

}

function countBadPlaced(model) {
    var badPlaced = 0
    for(var i = 0; i < 15; i++) {
        if(model[i] !== i + 1)
            badPlaced++
    }
    return badPlaced
}

function swap(model, spot1, spot2) {
    var old = model[spot1[0] + spot1[1] * 4]
    model[spot1[0] + spot1[1] * 4] = model[spot2[0] + spot2[1] * 4]
    model[spot2[0] + spot2[1] * 4] = old
}

function getRandomMove(model, emptySpot) {
    var possibleMoves = []
    if(emptySpot[0] > 0)
        possibleMoves.push([emptySpot[0] - 1, emptySpot[1]])
    if(emptySpot[0] < 3)
        possibleMoves.push([emptySpot[0] + 1, emptySpot[1]])
    if(emptySpot[1] > 0)
        possibleMoves.push([emptySpot[0], emptySpot[1] - 1])
    if(emptySpot[1] < 3)
        possibleMoves.push([emptySpot[0], emptySpot[1] + 1])

    return Core.shuffle(possibleMoves)[0]
}

function scrambleOne(model, emptySpot) {
    var nextSpot = getRandomMove(model, emptySpot)
    swap(model, emptySpot, nextSpot)
    return nextSpot
}

// We loop until the scramble created the requested
// numberOfExpectedBadPlaced items
function scramble(model, emptySpot, numberOfExpectedBadPlaced) {
    do {
        emptySpot = scrambleOne(model, emptySpot)
    } while(countBadPlaced(model) < numberOfExpectedBadPlaced)
}

function checkAnswer() {
    for(var i = 0; i < 15; i++)
        if(items.model.get(i).value !== i + 1) {
            return false
        }

    return true
}

function onClick(value) {
    // Find the value in the model
    var done = false
    for(var x = 0; x < 4 && !done; x++)
        for(var y = 0; y < 4 && !done; y++)
            if(items.model.get(x + y * 4).value === value) {
                // Find a free spot
                if(x > 0 && items.model.get((x - 1) + y * 4).value === 0) {
                    items.model.move(x + y * 4, (x - 1) + y * 4, 1)
                    done = true
                } else if(x < 3 && items.model.get((x + 1) + y * 4).value === 0) {
                    items.model.move(x + y * 4, (x + 1) + y * 4, 1)
                    done = true
                } else if(y > 0 && items.model.get(x + (y - 1) * 4).value === 0) {
                    items.model.move(x + y * 4, x + (y - 1) * 4, 1)
                    items.model.move(x + 1 + (y - 1) * 4, x + y * 4, 1)
                    done = true
                } else if(y < 3 && items.model.get(x + (y + 1) * 4).value === 0) {
                    items.model.move(x + (y + 1) * 4, x + y * 4, 1)
                    items.model.move(x + 1 + y * 4, x + (y + 1) * 4, 1)
                    done = true
                }
            }
}

// Return the index in the model of the empty spot
function getEmptySpot()
{
    for(var i=0; i < items.model.count; i++) {
        if(items.model.get(i).value === 0)
            return i
    }
}

function processPressedKey(event) {
    var emptySpot = getEmptySpot()

    /* Move the player */
    switch (event.key) {
    case Qt.Key_Right:
        if(emptySpot % 4 != 0) {
            items.model.move(emptySpot - 1, emptySpot, 1)
            event.accepted = true
        }
        break
    case Qt.Key_Left:
        if(emptySpot % 4 != 3) {
            items.model.move(emptySpot + 1, emptySpot, 1)
            event.accepted = true
        }
        break
    case Qt.Key_Up:
        if(emptySpot < items.model.count - 4) {
            items.model.move(emptySpot + 4, emptySpot, 1)
            items.model.move(emptySpot + 1, emptySpot + 4, 1)
            event.accepted = true
        }
        break
    case Qt.Key_Down:
        if(emptySpot >= 4) {
            items.model.move(emptySpot, emptySpot - 4, 1)
            items.model.move(emptySpot - 3, emptySpot, 1)
            event.accepted = true
        }
        break
    }

    /* Check if success */
    if(checkAnswer())
        items.bonus.good('flower')
    else if(event.accepted)
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/flip.wav")

}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
