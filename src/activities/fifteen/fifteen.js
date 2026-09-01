/* GCompris - fifteen.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/fifteen/resource/"

var items

var rowButtonIndex = -1;
var columnButtonIndex = -1;

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.buttonsBlocked = false
    resetKeyboardSixteen()

    // Create the initial array that holds the model data sorted
    var model = []
    for(var i = 1; i < 16; i++)
        model.push(i)

    if(items.mode == "fifteen") {
        model.push(0)
        scramble(model, [3, 3], (items.currentLevel + 2))
    }
    else {
        model.push(16)
    }

    items.model.clear()
    for(i = 0; i < 16; i++) {
        items.model.append({"value": model[i]})
    }
    if(items.mode == "sixteen") {
        slide(items.currentLevel + 2)
    }
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

// We loop numberOfSlideMoves times, and one more if we went to
// the initial position
function slide(numberOfSlideMoves) {
    var count = 0
    do {
        var randomDirection = Math.floor(Math.random() * 4)
        var randomRowOrCol = Math.floor(Math.random() * 4)
        switch (randomDirection) {
        case 0:
            leftAction(randomRowOrCol)
            break;
        case 1:
            rightAction(randomRowOrCol)
            break;
        case 2:
            topAction(randomRowOrCol)
            break;
        case 3:
            bottomAction(randomRowOrCol)
            break;
        }
    } while(++count < numberOfSlideMoves || isCorrectAnswer())
}

function isCorrectAnswer() {
    for(var i = 0; i < 15; i++) {
        if(items.model.get(i).value !== i + 1) {
            return false
        }
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
    if(isCorrectAnswer()) {
        items.buttonsBlocked = true
        items.bonus.good('flower')
    }
    else {
        items.flipSound.play()
    }
}

// Specific for sixteen mode keyboard controls

function selectButton(repeater, buttonIndex) {
    items.selectedRepeater = repeater;
    items.selectedButton = items.selectedRepeater.itemAt(buttonIndex);
}

function resetKeyboardSixteen() {
    items.selectedRepeater = null;
    items.selectedButton = null;
    rowButtonIndex = -1;
    columnButtonIndex = -1;
}

function sixteenPressedKey(event) {
    switch (event.key) {
        /* Button selection */
        case Qt.Key_Right:
            if(items.selectedRepeater === null) {
                columnButtonIndex = 0;
                selectButton(items.rightArrowsRepeater, columnButtonIndex);
            } else {
                moveSelectionRight();
            }
            event.accepted = true;
            break;
        case Qt.Key_Left:
            if(items.selectedRepeater === null) {
                columnButtonIndex = 0;
                selectButton(items.leftArrowsRepeater, columnButtonIndex);
            } else {
                moveSelectionLeft();
            }
            event.accepted = true;
            break;
        case Qt.Key_Up:
            if(items.selectedRepeater === null) {
                rowButtonIndex = 0;
                selectButton(items.topArrowsRepeater, rowButtonIndex);
            } else {
                moveSelectionUp();
            }
            event.accepted = true;
            break;
        case Qt.Key_Down:
            if(items.selectedRepeater === null) {
                rowButtonIndex = 0;
                selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            } else {
                moveSelectionDown();
            }
            event.accepted = true;
            break;
        /* Selected button activation*/
        case Qt.Key_Space:
        case Qt.Key_Enter:
        case Qt.Key_Return:
            if(items.selectedButton != null) {
                items.selectedButton.clicked();
            }
            event.accepted = true;
            break;
    }
}

function moveSelectionRight() {
    switch (items.selectedRepeater) {
        case items.rightArrowsRepeater:
            selectButton(items.leftArrowsRepeater, columnButtonIndex);
            break;
        case items.leftArrowsRepeater:
            if(columnButtonIndex < 2) {
                selectButton(items.topArrowsRepeater, 0);
            } else {
                selectButton(items.bottomArrowsRepeater, 0);
            }
            rowButtonIndex = 0;
            break;
        case items.topArrowsRepeater:
            rowButtonIndex += 1;
            if(rowButtonIndex > 3) {
                rowButtonIndex = 3;
                if(columnButtonIndex == -1) {
                    columnButtonIndex = 0;
                }
                selectButton(items.rightArrowsRepeater, columnButtonIndex);
            } else {
                selectButton(items.topArrowsRepeater, rowButtonIndex);
            }
            break;
        case items.bottomArrowsRepeater:
            rowButtonIndex += 1;
            if(rowButtonIndex > 3) {
                rowButtonIndex = 3;
                if(columnButtonIndex == -1) {
                    columnButtonIndex = 3;
                }
                selectButton(items.rightArrowsRepeater, columnButtonIndex);
            } else {
                selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            }
            break;
    }
}

function moveSelectionLeft() {
    switch (items.selectedRepeater) {
        case items.leftArrowsRepeater:
            selectButton(items.rightArrowsRepeater, columnButtonIndex);
            break;
        case items.rightArrowsRepeater:
            if(columnButtonIndex < 2) {
                selectButton(items.topArrowsRepeater, 3);
            } else {
                selectButton(items.bottomArrowsRepeater, 3);
            }
            rowButtonIndex = 3;
            break;
        case items.topArrowsRepeater:
            rowButtonIndex -= 1;
            if(rowButtonIndex < 0) {
                rowButtonIndex = 0;
                if(columnButtonIndex == -1) {
                    columnButtonIndex = 0;
                }
                selectButton(items.leftArrowsRepeater, columnButtonIndex);
            } else {
                selectButton(items.topArrowsRepeater, rowButtonIndex);
            }
            break;
        case items.bottomArrowsRepeater:
            rowButtonIndex -= 1;
            if(rowButtonIndex < 0) {
                rowButtonIndex = 0;
                if(columnButtonIndex == -1) {
                    columnButtonIndex = 3;
                }
                selectButton(items.leftArrowsRepeater, columnButtonIndex);
            } else {
                selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            }
            break;
    }
}

function moveSelectionUp() {
    switch (items.selectedRepeater) {
        case items.topArrowsRepeater:
            selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            break;
        case items.bottomArrowsRepeater:
            if(columnButtonIndex < 2) {
                selectButton(items.leftArrowsRepeater, 3);
            } else {
                selectButton(items.rightArrowsRepeater, 3);
            }
            columnButtonIndex = 3;
            break;
        case items.leftArrowsRepeater:
            columnButtonIndex -= 1;
            if(columnButtonIndex < 0) {
                columnButtonIndex = 0;
                if(rowButtonIndex == -1) {
                    rowButtonIndex = 0;
                }
                selectButton(items.topArrowsRepeater, rowButtonIndex);
            } else {
                selectButton(items.leftArrowsRepeater, columnButtonIndex);
            }
            break;
        case items.rightArrowsRepeater:
            columnButtonIndex -= 1;
            if(columnButtonIndex < 0) {
                columnButtonIndex = 0;
                if(rowButtonIndex == -1) {
                    rowButtonIndex = 3;
                }
                selectButton(items.topArrowsRepeater, rowButtonIndex);
            } else {
                selectButton(items.rightArrowsRepeater, columnButtonIndex);
            }
            break;
    }
}

function moveSelectionDown() {
    switch (items.selectedRepeater) {
        case items.bottomArrowsRepeater:
            selectButton(items.topArrowsRepeater, rowButtonIndex);
            break;
        case items.topArrowsRepeater:
            if(columnButtonIndex < 2) {
                selectButton(items.leftArrowsRepeater, 0);
            } else {
                selectButton(items.rightArrowsRepeater, 0);
            }
            columnButtonIndex = 0;
            break;
        case items.leftArrowsRepeater:
            columnButtonIndex += 1;
            if(columnButtonIndex > 3) {
                columnButtonIndex = 3;
                if(rowButtonIndex == -1) {
                    rowButtonIndex = 0;
                }
                selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            } else {
                selectButton(items.leftArrowsRepeater, columnButtonIndex);
            }
            break;
        case items.rightArrowsRepeater:
            columnButtonIndex += 1;
            if(columnButtonIndex > 3) {
                columnButtonIndex = 3;
                if(rowButtonIndex == -1) {
                    rowButtonIndex = 3;
                }
                selectButton(items.bottomArrowsRepeater, rowButtonIndex);
            } else {
                selectButton(items.rightArrowsRepeater, columnButtonIndex);
            }
            break;
    }
}

// end of specific for sixteen mode keyboard controls


function leftAction(index) {
    var indices = []
    var values = []
    for (var i = 0; i < 4; ++ i) {
        indices.push(i + index * 4);
        values.push(items.model.get(i + index * 4).value);
    }
    for (var i = 0; i < 4; ++ i) {
        items.model.setProperty(indices[i], "value", values[(i+1)%4])
    }
}

function rightAction(index) {
    var indices = []
    var values = []
    for (var i = 0; i < 4; ++ i) {
        indices.push(i + index * 4);
        values.push(items.model.get(i + index * 4).value);
    }
    for (var i = 0; i < 4; ++ i) {
        items.model.setProperty(indices[i], "value", values[(i-1+4)%4])
    }
}

function topAction(index) {
    var indices = []
    var values = []
    for (var i = 0; i < 4; ++ i) {
        indices.push(i * 4 + index);
        values.push(items.model.get(i * 4 + index).value);
    }
    for (var i = 0; i < 4; ++ i) {
        items.model.setProperty(indices[i], "value", values[(i+1)%4])
    }
}

function bottomAction(index) {
    var indices = []
    var values = []
    for (var i = 0; i < 4; ++ i) {
        indices.push(i * 4 + index);
        values.push(items.model.get(i * 4 + index).value);
    }
    for (var i = 0; i < 4; ++ i) {
        items.model.setProperty(indices[i], "value", values[(i-1+4)%4])
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}
