/* GCompris - mosaic.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Clement coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Bruno.coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.9 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var questionModel
var answerModel
var selectorModel

var url = "qrc:/gcompris/src/activities/mosaic/resource/"

var currentLevel = 0
var numberOfLevel
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
    numberOfLevel = items.levels.length
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.background.areaWithKeyboardFocus = items.selector
    items.selectedItem = ""
    items.nbItems = items.levels[currentLevel].nbOfCells
    items.questionLayoutColumns = items.levels[currentLevel].layout[0][0]
    items.questionLayoutRows = items.levels[currentLevel].layout[0][1]
    items.modelDisplayLayout = items.levels[currentLevel].modelDisplayLayout
    selectorModel = items.levels[currentLevel].images

    items.selector.model = selectorModel
    questionModel = Core.shuffle(selectorModel)
    items.question.model = questionModel

    answerModel = new Array()
    for(var i=0; i < questionModel.length; i++)
        answerModel.push("dice_0.svg")
    items.answer.model = answerModel

}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function answerSelected(index) {
    if(!items.selectedItem)
        return

    items.audioEffects.play("qrc:/gcompris/src/activities/redraw/resource/brush.wav")
    answerModel[index] = items.selectedItem
    items.answer.model = answerModel

    if(answerModel.toString() === questionModel.toString()) {
        items.bonus.good("flower")
    }
}
