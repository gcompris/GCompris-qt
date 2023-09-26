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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var questionModel
var answerModel
var selectorModel

var url = "qrc:/gcompris/src/activities/mosaic/resource/"

var numberOfLevel
var items

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.background.areaWithKeyboardFocus = items.selector
    items.selectedItem = ""
    items.nbItems = items.levels[items.currentLevel].nbOfCells
    items.questionLayoutColumns = items.levels[items.currentLevel].layout[0][0]
    items.questionLayoutRows = items.levels[items.currentLevel].layout[0][1]
    items.modelDisplayLayout = items.levels[items.currentLevel].modelDisplayLayout
    selectorModel = items.levels[items.currentLevel].images

    items.selector.model = selectorModel
    questionModel = Core.shuffle(selectorModel)
    items.question.model = questionModel

    answerModel = new Array()
    for(var i=0; i < questionModel.length; i++)
        answerModel.push("dice_0.svg")
    items.answer.model = answerModel

}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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
