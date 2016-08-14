/* GCompris - share.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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

var currentLevel = 0
var numberOfLevel = 10
var items

var savedTotalBoys
var savedTotalGirls
var savedTotalCandies
var savedPlacedInGrils
var savedPlacedInBoys
var savedCurrentCandies

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var filename = "resource/board/"+ "board" + currentLevel + ".qml"
    items.dataset.source = filename

    setUp()
}

function setUp() {
    var levelData = items.dataset.item

    // use board levels
    if (currentLevel < 7) {
        items.totalBoys = levelData.levels[items.currentSubLevel].totalBoys
        items.totalGirls = levelData.levels[items.currentSubLevel].totalGirls
        items.totalCandies = levelData.levels[items.currentSubLevel].totalCandies

        items.instruction.text = levelData.levels[items.currentSubLevel].instruction
        items.nbSubLevel = levelData.levels.length


        items.background.currentCandies = items.totalGirls * levelData.levels[items.currentSubLevel].placedInGirls +
                items.totalBoys * levelData.levels[items.currentSubLevel].placedInBoys

        items.background.placedInGirls = levelData.levels[items.currentSubLevel].placedInGirls
        items.background.placedInBoys = levelData.levels[items.currentSubLevel].placedInBoys
        items.background.showCount = levelData.levels[items.currentSubLevel].showCount


        items.background.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
        items.basketWidget.element.opacity = (levelData.levels[items.currentSubLevel].forceShowBakset === true ||
                                              items.background.rest !== 0) ? 1 : 0

    // create random (guided) levels
    } else {
        // get a random number between 1 and max for boys, girls and candies
        var maxBoys = levelData.levels[0].maxBoys
        var maxGirls = levelData.levels[0].maxGirls
        var maxCandies = levelData.levels[0].maxCandies

        items.totalBoys = Math.floor(Math.random() * maxBoys) + 1
        items.totalGirls = Math.floor(Math.random() * maxGirls) + 1
        var sum = items.totalBoys + items.totalGirls
        // use sum * 4 as top margin (max 4 candies per rectangle)
        items.totalCandies = Math.floor(Math.random() * (4 * sum - sum + 1)) + sum

        // stay within the max margin
        if (items.totalCandies > maxCandies)
            items.totalCandies = maxCandies

        // grammer correction depending the number of children: 1 (singular) or more (plural)
        var boys
        var girls

        if (items.totalBoys > 1)
            boys = "boys"
        else boys = "boy"

        if (items.totalGirls > 1)
            girls = "girls"
        else girls = "girl"

        items.instruction.text = qsTr("Place " + items.totalBoys + " " + boys + " and " +
                 items.totalGirls + " " + girls + " in the center, then equally split " +
                 items.totalCandies + " candies between them.")

        items.background.showCount = false
        items.nbSubLevel = 5

        // depending on the levels configuration, add candies from start in a child rectangle
        if (levelData.levels[0].alreadyPlaced == false) {
            items.background.placedInGirls = 0
            items.background.placedInBoys = 0
            items.background.currentCandies = 0
        } else {
            items.background.currentCandies = items.totalCandies * 2
            while (items.background.currentCandies > items.totalCandies / 3) {
                items.background.placedInGirls = Math.floor(Math.random() * 3) + 0
                items.background.placedInBoys = Math.floor(Math.random() * 3) + 0
                items.background.currentCandies = items.totalGirls * items.background.placedInGirls
                        + items.totalBoys * items.background.placedInBoys
            }
            // update the total number of candies with the candies already added
            items.totalCandies += items.background.currentCandies
        }

        items.background.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
        items.basketWidget.element.opacity = 1

        saveVariables()
    }

        items.background.currentGirls = 0
        items.background.currentBoys = 0
        items.background.resetCandy()
        items.background.finished = false

        items.acceptCandy = false
        items.instruction.opacity = 1
        items.listModel.clear()

        items.girlWidget.current = 0
        items.girlWidget.canDrag = true
        items.girlWidget.element.opacity = 1

        items.boyWidget.current = 0
        items.boyWidget.canDrag = true
        items.boyWidget.element.opacity = 1

        items.candyWidget.canDrag = true
        items.candyWidget.element.opacity = 1
        if (items.totalCandies - items.background.currentCandies == 0)
            items.candyWidget.element.opacity = 0.6

        items.basketWidget.canDrag = true
}

function saveVariables() {
    savedTotalBoys = items.totalBoys
    savedTotalGirls = items.totalGirls
    savedTotalCandies = items.totalCandies
    savedPlacedInGrils = items.background.placedInGirls
    savedPlacedInBoys = items.background.placedInBoys
    savedCurrentCandies = items.background.currentCandies
}

function loadVariables() {
    items.totalBoys = savedTotalBoys
    items.totalGirls = savedTotalGirls
    items.totalCandies = savedTotalCandies
    items.background.placedInGirls = savedPlacedInGrils
    items.background.placedInBoys = savedPlacedInBoys
    items.background.currentCandies = savedCurrentCandies
}

function reloadRandom() {
    if (currentLevel < 7) {
        initLevel()
    } else {
        loadVariables()

        items.background.currentGirls = 0
        items.background.currentBoys = 0
        items.background.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
        items.background.resetCandy()
        items.background.showCount = false
        items.acceptCandy = false

        items.instruction.opacity = 1
        items.listModel.clear()

        items.girlWidget.current = 0
        items.girlWidget.canDrag = true
        items.girlWidget.element.opacity = 1

        items.boyWidget.current = 0
        items.boyWidget.canDrag = true
        items.boyWidget.element.opacity = 1

        items.candyWidget.canDrag = true
        items.candyWidget.element.opacity = 1
        if (items.totalCandies - items.background.currentCandies == 0)
            items.candyWidget.element.opacity = 0.6

        items.basketWidget.canDrag = true
        items.basketWidget.element.opacity = 1
    }
}

function nextSubLevel() {
    items.currentSubLevel ++
    if (items.currentSubLevel === items.nbSubLevel) {
        nextLevel()
    }
    else
        setUp()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.currentSubLevel = 0;
    initLevel();
}
