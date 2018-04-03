/* GCompris - railroad.js
 *
 * Copyright (C) 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   "Utkarsh Tiwari" <iamutkarshtiwari@kde.org> (Qt Quick port)
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

var currentLevel = 0
var numberOfLevel = 4
var noOfCarriages = [5, 6, 5, 6]
var rowWidth = [0.95, 0.1, 0.1, 0.1]
var solutionArray = []
var backupListModel = []
var isNewLevel = true
var resourceURL = "qrc:/gcompris/src/activities/railroad/resource/"
var numberOfSubLevels = 3
var items

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.numberOfSubLevels = numberOfSubLevels;
    items.score.currentSubLevel = 1;
    initLevel()
}

function stop() {
}

function initLevel() {
    var index = 0;
    items.mouseEnabled = true;
    items.memoryMode = false;
    items.timer.stop();
    items.animateFlow.stop(); // Stops any previous animations
    items.listModel.clear();
    if(isNewLevel) {
        // Initiates a new level
        backupListModel = [];
        solutionArray = [];
        for(var i = 0; i < currentLevel + 2; i++) {
            if(i == (currentLevel + 1)) {
                // Selects the last carriage
                do {
                    index = Math.floor(Math.random() * 9) + 1;
                } while (solutionArray.indexOf(index) != -1) // Ensures non-repeative wagons setup
            } else {
                // Selects the follow up wagons
                do {
                    index = Math.floor(Math.random() * 12) + 10;
                } while (solutionArray.indexOf(index) != -1)
            }
            solutionArray.push(index);
            
            addWagon(index, i);
        }
    } else {
        // Re-setup the same level
        for(var i = 0; i < solutionArray.length; i++) {
            addWagon(solutionArray[i], i);
        }
    }
    if(items.introMessage.visible == false && isNewLevel) {
        items.timer.start()
    }
    items.bar.level = currentLevel + 1;
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function restoreLevel() {
    backupListModel = [];
    for (var index = 0; index < items.listModel.count; index++) {
        backupListModel.push(items.listModel.get(index).id);
    }
    isNewLevel = false;
    initLevel();
}

function nextSubLevel() {
    /* Sets up the next sublevel */
    items.score.currentSubLevel ++;
    if(items.score.currentSubLevel > numberOfSubLevels) {
        nextLevel();
    } else {
        isNewLevel = true;
        initLevel();
    }
}

function isAnswer() {
    /* Checks if the top level setup equals the solutions */
    if(items.listModel.count === solutionArray.length) {
        var isSolution = true;
        for (var index = 0; index < items.listModel.count; index++) {
            if(items.listModel.get(index).id != solutionArray[index]) {
                isSolution = false;
                break;
            }
        }
        if(isSolution == true) {
            items.mouseEnabled = false; // Disables the touch
            items.bonus.good("flower");
        }
    }
}

function sum(index) {
    /* Returns the sum up till the specified index */
    var total = 0
    for (var i = 0; i < index; i++)
        total += noOfCarriages[i];
    return total;
}

function addWagon(index, dropIndex) {
    /* Appends wagons to the display area */
    items.listModel.insert(dropIndex, {"id": index});
    (items.displayList.itemAt(dropIndex)).source = resourceURL + "loco" + (index) + ".svg";
}

function getDropIndex(x) {
    var count = items.listModel.count;
    for (var index = 0; index < count; index++) {
        var xVal = items.displayList.itemAt(index).x;
        var itemWidth = items.displayList.itemAt(index).width;
        if(x < xVal && index == 0) {
            return 0;
        } else if((xVal + itemWidth + items.displayRow.spacing) <= x && index == (count - 1)) {
            return count;
        } else if(xVal <= x && x < (xVal + itemWidth + items.displayRow.spacing)) {
            return index + 1;
        }
    }
    return 0;
}
