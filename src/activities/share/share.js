/* GCompris - share.js
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu29@gmail.com> (initial version)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick as Quick
.import core 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var items

var savedTotalBoys
var savedTotalGirls
var savedTotalCandies
var savedPlacedInGirls
var savedPlacedInBoys
var savedCurrentCandies
var subLevelData

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    setUp()
}

function setUp() {
    items.errorRectangle.resetState()
    var levelData = items.levels
    items.numberOfLevel = items.levels.length
    subLevelData = levelData[items.currentLevel][items.score.currentSubLevel];
    // use board levels
    if (!subLevelData["randomisedInputData"]) {
        items.totalBoys = subLevelData.totalBoys
        items.totalGirls = subLevelData.totalGirls
        items.totalCandies = subLevelData.totalCandies

        items.instruction.text = subLevelData.instruction
        items.nbSubLevel = levelData[items.currentLevel].length

        items.activityBackground.currentCandies = items.totalGirls * subLevelData.placedInGirls +
                items.totalBoys * subLevelData.placedInBoys

        items.activityBackground.placedInGirls = subLevelData.placedInGirls
        items.activityBackground.placedInBoys = subLevelData.placedInBoys

        items.activityBackground.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
        items.basketWidget.element.opacity = (subLevelData.forceShowBasket === true ||
                                              items.activityBackground.rest !== 0) ? 1 : 0
        items.activityBackground.wrongMove.visible = false
    }
    else {
        // create random (guided) levels
        // get a random number between 1 and max for boys, girls and candies
        var maxBoys = subLevelData.maxBoys
        var maxGirls = subLevelData.maxGirls
        var maxCandies = subLevelData.maxCandies

        items.totalBoys = Math.floor(Math.random() * maxBoys) + 1
        items.totalGirls = Math.floor(Math.random() * maxGirls) + 1
        var sum = items.totalBoys + items.totalGirls
        // use sum * 6 as top margin (max 6 candies per rectangle, and minimum 1 per child)
        items.totalCandies = Math.floor(Math.random() * 6 * sum) + sum
        items.nbSubLevel = levelData[items.currentLevel].length
        // stay within the max margin
        if (items.totalCandies > maxCandies)
            items.totalCandies = maxCandies

        items.activityBackground.placedInGirls = 0
        items.activityBackground.placedInBoys = 0
        items.activityBackground.currentCandies = 0
        // depending on the levels configuration, add candies from start in a child rectangle
        if (subLevelData.alreadyPlaced) {
            items.activityBackground.placedInGirls = 0
            items.activityBackground.placedInBoys = 0
            items.activityBackground.currentCandies = 0
            // Max number of already placed candies depending on number of candies per children, but -1 do not place them all
            var maxPlacedCandies = Math.floor(items.totalCandies / sum) - 1;
            // Maximum 3 placed candies per child
            var placedInSum = maxPlacedCandies / sum;
            if(placedInSum < 0) {
                placedInSum = 0;
            } else if(placedInSum > 3) {
                placedInSum = 3;
            }
            for (var i = 0; i < placedInSum; i++) {
                var inBoys = Math.round(Math.random())
                if(inBoys == 1) {
                    items.activityBackground.placedInBoys += 1;
                } else {
                    items.activityBackground.placedInGirls += 1;
                }
            }
            items.activityBackground.currentCandies = items.totalGirls * items.activityBackground.placedInGirls
                + items.totalBoys * items.activityBackground.placedInBoys
        }
        //~ singular "Place %n boy "
        //~ plural "Place %n boys "
        items.instruction.text = qsTr("Place %n boy(s) ", "First part of Place %n boy(s) and %n girl(s) in the center. Then split %n pieces of candy equally between them.", items.totalBoys);

        //~ singular "and %n girl in the center. "
        //~ plural "and %n girls in the center. "
        items.instruction.text += qsTr("and %n girl(s) in the center. ", "Second part of Place %n boy(s) and %n girl(s) in the center. Then split %n pieces of candy equally between them.", items.totalGirls);

        //~ singular Then split %n candy equally between them.
        //~ plural Then split %n candies equally between them.
        items.instruction.text += qsTr("Then split %n pieces of candy equally between them.", "Third part of Place %n boy(s) and %n girl(s) in the center. Then split %n pieces of candy equally between them.", items.totalCandies - items.activityBackground.currentCandies);


        items.activityBackground.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)

        items.basketWidget.element.opacity = 1

        items.activityBackground.wrongMove.visible = false;

        saveVariables()
    }
    resetBoard()
}

function resetBoard() {
    items.activityBackground.currentGirls = 0
    items.activityBackground.currentBoys = 0
    items.activityBackground.resetCandy()

    items.acceptCandy = false
    items.instructionPanel.opacity = 1
    items.listModel.clear()

    items.girlWidget.current = 0
    items.girlWidget.canDrag = true
    items.girlWidget.element.opacity = 1

    items.boyWidget.current = 0
    items.boyWidget.canDrag = true
    items.boyWidget.element.opacity = 1

    items.candyWidget.canDrag = true
    items.candyWidget.element.opacity = 1
    if (items.totalCandies - items.activityBackground.currentCandies == 0)
        items.candyWidget.element.opacity = 0.6

    items.basketWidget.canDrag = true
    items.buttonsBlocked = false
}

function saveVariables() {
    savedTotalBoys = items.totalBoys
    savedTotalGirls = items.totalGirls
    savedTotalCandies = items.totalCandies
    savedPlacedInGirls = items.activityBackground.placedInGirls
    savedPlacedInBoys = items.activityBackground.placedInBoys
    savedCurrentCandies = items.activityBackground.currentCandies
}

function loadVariables() {
    items.totalBoys = savedTotalBoys
    items.totalGirls = savedTotalGirls
    items.totalCandies = savedTotalCandies
    items.activityBackground.placedInGirls = savedPlacedInGirls
    items.activityBackground.placedInBoys = savedPlacedInBoys
    items.activityBackground.currentCandies = savedCurrentCandies
}

function reloadRandom() {
    if (!subLevelData["randomisedInputData"]) {
        initLevel()
    }
    else {
        loadVariables()
        resetBoard()

        items.activityBackground.rest = items.totalCandies -
                Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
        items.basketWidget.element.opacity = 1
    }
}

function nextSubLevel() {
    if (items.score.currentSubLevel >= items.nbSubLevel) {
        items.bonus.good("tux")
    }
    else {
        setUp()
    }
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}
