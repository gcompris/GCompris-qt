/* GCompris - mosaic.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Clement coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Bruno.coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var images = [
            "aquarela_colors.svg",
            "giraffe.svg",
            "pencil.svg",
            "mouse_on_cheese.svg",
            "mushroom_house.svg",
            "pencils_paper.svg",
            "pencils.svg",
            "white_cake.svg",
            "die_1.svg",
            "die_2.svg",
            "die_3.svg",
            "die_4.svg",
            "die_5.svg",
            "die_6.svg",
            "die_7.svg",
            "die_0.svg",
            "digital_die0.svg",
            "digital_die1.svg",
            "digital_die2.svg",
            "digital_die3.svg",
            "digital_die4.svg",
            "digital_die5.svg",
            "digital_die6.svg",
            "digital_die7.svg"
        ]

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
    items.nbItems = items.levels[currentLevel].nbItems
    items.selectorLayoutColumns = items.levels[currentLevel].selectorLayout[items.nbItems][0]
    items.selectorLayoutRows = items.levels[currentLevel].selectorLayout[items.nbItems][1]
    items.questionLayoutColumns = items.levels[currentLevel].questionLayout[items.nbItems][0]
    items.questionLayoutRows = items.levels[currentLevel].questionLayout[items.nbItems][1]
    selectorModel = images.slice(currentLevel,
                                     currentLevel + items.nbItems);
    items.selector.model = selectorModel

    questionModel = Core.shuffle(selectorModel)
    items.question.model = questionModel

    answerModel = new Array()
    for(var i=0; i < questionModel.length; i++)
        answerModel.push("die_0.svg")
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
