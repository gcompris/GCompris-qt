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
    items.buttonsBlocked = false
    items.activityBackground.areaWithKeyboardFocus = items.selector
    items.selectedItem = ""
    items.nbItems = items.levels[items.currentLevel].nbOfCells
    items.questionLayoutColumns = items.levels[items.currentLevel].layout[0][0]
    items.questionLayoutRows = items.levels[items.currentLevel].layout[0][1]
    items.modelDisplayLayout = items.levels[items.currentLevel].modelDisplayLayout
    selectorModel = items.levels[items.currentLevel].images

    items.selector.model = selectorModel
    questionModel = Core.shuffle(selectorModel)
    items.question.model = questionModel

    items.answerModel.clear()
    for(var i=0; i < questionModel.length; i++) {
        items.answerModel.append({ "imgUrl": "dice_0.svg" })
    }
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

    items.brushSound.play()
    items.answerModel.set(index, { "imgUrl": items.selectedItem })

    for(var i=0; i < questionModel.length; i++) {
        if(items.answerModel.get(i).imgUrl != questionModel[i]) {
            return
        }
    }
    items.buttonsBlocked = true
    items.bonus.good("flower")
}
