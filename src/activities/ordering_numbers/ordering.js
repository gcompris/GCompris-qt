/* GCompris - ordering.js
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "../../core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 0

var items
var mode

// num[] will contain the random values
var num = []
var originalArrangement = []

function start(items_, mode_) {
    items = items_
    mode = mode_
    
    // For sentences mode, parse the sentences in the datasets
    if(mode === "sentences") {
        var datasets = []
        for(var level in items.levels) {
            var sentences = items.levels[level].sentences.split("\n")
            for(var ind in sentences) {
                var obj = {
                    values: sentences[ind].split("|") 
                }
                datasets.push(obj)
            }
        }
        items.levels = datasets
    }
    
    // For defined letters in ordering_alphabets datasets, parse the string
    if(mode === "alphabets") {
        for(var level in items.levels) {
            items.levels[level].values = items.levels[level].string.split("|")
        }
    }
    
    currentLevel = 0
    numberOfLevel = items.levels.length
    initLevel()
}

function stop() {
}

function initLevel() {
    var numbers_asc = qsTr("Drag and drop the items in correct position in ascending order.");
    var numbers_desc = qsTr("Drag and drop the items in correct position in descending order.");
    var alphabets_asc = qsTr("Drag and drop the letters in correct position in ascending order.");
    var alphabets_desc = qsTr("Drag and drop the letters in correct position in descending order.");
    var chronology = qsTr("Drag and drop the items in correct position in chronological order.");
    var sentences = qsTr("Drag and drop the words to the upper box to form a meaningful sentence.");
    
    var display_instruction = "";
    if(items.levels[currentLevel].instruction)
        display_instruction = items.levels[currentLevel].instruction;
    else if(mode === "sentences")
        display_instruction = sentences;
    else if(mode === "chronology")
        display_instruction = chronology;
    else if(mode === "alphabets")
        display_instruction = (items.levels[currentLevel].mode === 'ascending') ? alphabets_asc : alphabets_desc;
    else if(mode === "numbers")
        display_instruction = (items.levels[currentLevel].mode === 'ascending') ? numbers_asc : numbers_desc;
    
    items.instruction.text = display_instruction;
    items.bar.level = currentLevel + 1
    initGrids()
}

function resetGrid() {
    var count = items.targetListModel.count
    var i = 0
    for(i=0; i<count; ++i)
        items.targetListModel.remove(0)

    count = items.originListModel.count
    for(i=0; i<count; ++i)
        items.originListModel.remove(0)
}

function initGrids() {
    generateNumbers()
    resetGrid()

    for(var i = 0;i < num.length; i++) {
        items.originListModel.append({
            "elementValue" : num[i].toString(),
            "borderColor" : "black"
        })
    }
}

function generateNumbers() {
    num = []
    // generate a permutation of numbers from the dataset and store it in num[]
    if(items.levels[currentLevel].random) {
        var min = (mode === "alphabets") ? 1 : items.levels[currentLevel].minNumber
        var max = (mode === "alphabets") ? items.levels[currentLevel].values.length : items.levels[currentLevel].maxNumber
        var range = max - min + 1
        var count = 0
        while(count < items.levels[currentLevel].numberOfElementsToOrder) {
            var random = min + parseInt(Math.random() * range)
            if(mode === "alphabets")
                random = items.levels[currentLevel].values[random-1]
            if(num.indexOf(random) === -1) {
                // Unique element found
                count++
                num.push(random)
            }
        }

        if(mode === "numbers")
            num.sort(function(a, b) { return a - b })
        else
            num.sort()

    }
    else
        num = [...items.levels[currentLevel].values]
    
    if(items.levels[currentLevel].mode === "descending")
        num.reverse()

    originalArrangement = [...num]
    num = Core.shuffle(num)
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}

function targetColorReset() {
    if(!items.targetPlaceholder.colorResetRequired)
        return

    for(var i = 0 ; i < items.targetListModel.count; i++)
        items.targetListModel.get(i).borderColor = "black"

    items.targetPlaceholder.colorResetRequired = false
}

function checkOrder() {
    var success = true
    var values = originalArrangement
        
    for(var i = 0 ; i < items.targetListModel.count; i++) {
        if(items.targetListModel.get(i).elementValue != values[i]) {
            success = false
            items.targetListModel.get(i).borderColor = "red"
        }
        else
            items.targetListModel.get(i).borderColor = "green"
    }
    
    items.targetPlaceholder.colorResetRequired = true
    
    if(success)
        items.bonus.good("lion")
    else
        items.bonus.bad("lion")
}
