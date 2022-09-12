/* GCompris - fractions_create.js
 *
 * Copyright (C) 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-FileCopyrightText: Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var numberOfLevel;
var levels;
var items;

var previousQuestion = {"numerator": -1, "denominator": -1};

function start(items_) {
    items = items_;
    currentLevel = 0;
    levels = items.levels;
    numberOfLevel = levels.length;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.currentSubLevel = 1;

    items.numberOfSubLevels = levels[currentLevel].length;

    Core.shuffle(levels[currentLevel]);

    initSubLevel();
}

function initSubLevel() {
    var currentSubLevel = levels[currentLevel][items.currentSubLevel-1];
    items.chartType = currentSubLevel.chartType;

    items.fixedNumerator = currentSubLevel.fixedNumerator ? currentSubLevel.fixedNumerator : false;
    items.fixedDenominator = currentSubLevel.fixedDenominator ? currentSubLevel.fixedDenominator : false;

    if(currentSubLevel.random) {
        var minDenominator = 2;
        var minNumerator = 1;
        var maxDenominator = 12;
        var randomDenominator;
        var randomNumerator;
        var maxFractions = currentSubLevel.maxFractions;
        // Make sure we don't have twice the same question in a row
        do {
            randomDenominator = Math.floor(Math.random() * (maxDenominator - minDenominator) + minDenominator);
            // We allow twice the denominator to have 2 pie, but no more to ensure it's still readable on small screens
            randomNumerator = Math.floor(Math.random() * (maxFractions * randomDenominator - minNumerator) + minNumerator);
        }
        while((previousQuestion.numerator == randomNumerator) && (previousQuestion.denominator == randomDenominator));
            
        items.denominatorValue = (items.mode === "findFraction" && !items.fixedDenominator) ? 0 : randomDenominator;
        items.denominatorToFind = randomDenominator;
        items.numeratorValue = (items.mode === "findFraction" && items.fixedNumerator) ? randomNumerator : 0;
        items.numeratorToFind = randomNumerator;
    }
    else {
        items.denominatorValue = (items.mode === "findFraction" && !items.fixedDenominator) ? 0 : currentSubLevel.denominator;
        items.denominatorToFind = currentSubLevel.denominator;
        items.numeratorValue = (items.mode === "findFraction" && items.fixedNumerator) ? currentSubLevel.numerator : 0;
        items.numeratorToFind = currentSubLevel.numerator;
    }

    previousQuestion.numerator = items.numeratorToFind;
    previousQuestion.denominator = items.denominatorToFind;

    if(items.mode === "findFraction") {
        items.instructionText = qsTr("Find the represented fraction.");
    }
    else {
        items.instructionText = currentSubLevel.instruction;
    }

    items.chartItem.initLevel();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    initLevel();
}

function nextSubLevel() {
    items.currentSubLevel ++;
    if (items.currentSubLevel === items.numberOfSubLevels+1) {
        nextLevel();
    }
    else {
        initSubLevel();
    }
}


function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    initLevel();
}
