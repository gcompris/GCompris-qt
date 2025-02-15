/* GCompris - share.js
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import core 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
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
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
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
    numberOfLevel = items.levels.length
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
        // use sum * 6 as top margin (max 6 candies per rectangle)
        items.totalCandies = Math.floor(Math.random() * (5 * sum + 1)) + sum
        items.nbSubLevel = levelData[items.currentLevel].length
        // stay within the max margin
        if (items.totalCandies > maxCandies)
            items.totalCandies = maxCandies

        // depending on the levels configuration, add candies from start in a child rectangle
        if (subLevelData.alreadyPlaced === false) {
            items.activityBackground.placedInGirls = 0
            items.activityBackground.placedInBoys = 0
            items.activityBackground.currentCandies = 0
        }
        else {
            items.activityBackground.currentCandies = items.totalCandies * 2
            // Place randomly between 0 and 3 candies for each child
            while (items.activityBackground.currentCandies > items.totalCandies / 3) {
                items.activityBackground.placedInGirls = Math.floor(Math.random() * 3)
                items.activityBackground.placedInBoys = Math.floor(Math.random() * 3)
                items.activityBackground.currentCandies = items.totalGirls * items.activityBackground.placedInGirls
                        + items.totalBoys * items.activityBackground.placedInBoys
            }
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}
