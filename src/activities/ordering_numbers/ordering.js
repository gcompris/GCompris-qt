/* GCompris - ordering.js
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "../../core/core.js" as Core

var numberOfLevel = 0

var items
var mode

// num[] will contain the random values
var num = []
var originalArrangement = []

// for random datasets, we have to dynamically generate values
// items.levels should be treated as read only, thus we keep a local copy
var levels = []

function start(items_, mode_) {
    items = items_
    mode = mode_
    levels = items.levels

    // For sentences mode, parse the sentences in the datasets
    if(mode === "sentences") {
        var datasets = []
        for(var level_ind in levels) {
            var sentences = levels[level_ind].sentences.split("\n")
            for(var ind in sentences) {
                var obj = {
                    values: sentences[ind].split("|")
                }
                datasets.push(obj)
            }
        }
        levels = datasets
    }

    // For defined letters in ordering_alphabets datasets, parse the string
    if(mode === "alphabets") {
        for(var level_ind in levels) {
            levels[level_ind].values = levels[level_ind].string.split("|")
        }
    }

    numberOfLevel = levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    var numbers_asc = qsTr("Drag and drop the items in ascending order.");
    var numbers_desc = qsTr("Drag and drop the items in descending order.");
    var alphabets_asc = qsTr("Drag and drop the letters in alphabetical order.");
    var alphabets_desc = qsTr("Drag and drop the letters in reverse alphabetical order.");
    var chronology = qsTr("Drag and drop the items in chronological order.");
    var sentences = qsTr("Drag and drop the words to the upper box to form a meaningful sentence.");

    var display_instruction = "";
    if(levels[items.currentLevel].instruction)
        display_instruction = levels[items.currentLevel].instruction;
    else if(mode === "sentences")
        display_instruction = sentences;
    else if(mode === "chronology")
        display_instruction = chronology;
    else if(mode === "alphabets")
        display_instruction = (levels[items.currentLevel].mode === 'ascending') ? alphabets_asc : alphabets_desc;
    else if(mode === "numbers")
        display_instruction = (levels[items.currentLevel].mode === 'ascending') ? numbers_asc : numbers_desc;

    items.instruction.text = display_instruction;
    initGrids()
}

function initGrids() {
    generateNumbers()
    items.targetListModel.clear()
    items.originListModel.clear()

    for(var i = 0;i < num.length; i++) {
        items.originListModel.append({
            "elementValue" : num[i].toString(),
            "borderColor" : "#808080"
        })
    }
}

function generateNumbers() {
    num = []
    // generate a permutation of numbers from the dataset and store it in num[]
    if(levels[items.currentLevel].random) {
        var min = (mode === "alphabets") ? 1 : levels[items.currentLevel].minNumber
        var max = (mode === "alphabets") ? levels[items.currentLevel].values.length : levels[items.currentLevel].maxNumber
        var range = max - min + 1
        var count = 0
        while(count < levels[items.currentLevel].numberOfElementsToOrder) {
            var random = min + parseInt(Math.random() * range)
            if(mode === "alphabets")
                random = levels[items.currentLevel].values[random-1]
            if(num.indexOf(random) === -1) {
                // Unique element found
                count++
                num.push(random)
            }
        }

        if(mode === "numbers")
            num.sort(function(a, b) { return a - b })
        // for sorting letters we can't rely on sort default behavior, as in some languages the correct order
        // is not the same as Unicode UTF 16 order (issue noticed with Malayalam). Using a.localeCompare(b)
        // is also not reliable. So we just sort according to the reference list in the dataset.
        else {
            num.sort(function (a, b) {
                if(levels[items.currentLevel].values.indexOf(a) > levels[items.currentLevel].values.indexOf(b)) {
                    return 1;
                }
                if(levels[items.currentLevel].values.indexOf(a) < levels[items.currentLevel].values.indexOf(b)) {
                    return -1;
                }
                return 0;
            });
        }

    }
    else {
        num = levels[items.currentLevel].values.slice();
    }
    if(levels[items.currentLevel].mode === "descending")
        num.reverse();

    originalArrangement = num.slice();
    num = Core.shuffle(num)
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel()
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel()
}

function targetColorReset() {
    if(!items.targetPlaceholder.colorResetRequired)
        return

    for(var i = 0 ; i < items.targetListModel.count; i++)
        items.targetListModel.get(i).borderColor = "#808080"

    items.targetPlaceholder.colorResetRequired = false
}

function checkOrder() {
    var success = true
    var values = originalArrangement

    for(var i = 0 ; i < items.targetListModel.count; i++) {
        if(items.targetListModel.get(i).elementValue != values[i]) {
            success = false
            items.targetListModel.get(i).borderColor = "#D94444" //red
        }
        else
            items.targetListModel.get(i).borderColor = "#62BA62" //green
    }

    items.targetPlaceholder.colorResetRequired = true

    if(success)
        items.bonus.good("lion")
    else
        items.bonus.bad("lion")
}
