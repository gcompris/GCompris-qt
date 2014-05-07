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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var images = [
            "aquarela_colors.svgz",
            "giraffe.svgz",
            "pencil.svgz",
            "mouse_on_cheese.svgz",
            "mushroom_house.svgz",
            "pencils_paper.svgz",
            "pencils.svgz",
            "white_cake.svgz",
            "die_1.svgz",
            "die_2.svgz",
            "die_3.svgz",
            "die_4.svgz",
            "die_5.svgz",
            "die_6.svgz",
            "die_7.svgz",
            "die_0.svgz",
            "digital_die0.svgz",
            "digital_die1.svgz",
            "digital_die2.svgz",
            "digital_die3.svgz",
            "digital_die4.svgz",
            "digital_die5.svgz",
            "digital_die6.svgz",
            "digital_die7.svgz"
        ]

var questionModel
var answerModel
var selectorModel

var url = "qrc:/gcompris/src/activities/mosaic/resource/"

// What is the grid layout based on the number of items
var questionLayout = {
    8:  [4, 2],
    16: [4, 4],
    24: [6, 4]
}

var selectorLayout = {
    8:  [8, 1],
    16: [8, 2],
    24: [12, 2]
}

var currentLevel = 0
var numberOfLevel = 16
var items
var selectedItem

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    if(currentLevel < 4) {
        items.nbItems = 8
        selectorModel = images.slice(currentLevel,
                                     currentLevel + items.nbItems);
    } else if(currentLevel < 8) {
        items.nbItems = 16
        selectorModel = images.slice(currentLevel - 4,
                                     currentLevel - 4 + items.nbItems);
    } else {
        items.nbItems = 24
        selectorModel = images.slice(0, items.nbItems);
    }
    items.selector.model = selectorModel

    questionModel = Core.shuffle(selectorModel)
    items.question.model = questionModel

    answerModel = new Array()
    for(var i=0; i < questionModel.length; i++)
        answerModel.push("die_0.svgz")
    items.answer.model = answerModel

    selectedItem = undefined
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

function select(selectedItem_) {
    if(selectedItem) {
        selectedItem.deselect()
    }
    selectedItem = selectedItem_
    selectedItem.select()
}

function checkAnswer() {
}

function answerSelected(index) {
    if(!selectedItem)
        return

    answerModel[index] = selectedItem.basename
    items.answer.model = answerModel

    if(answerModel.toString() === questionModel.toString()) {
        items.bonus.good("flower")
    }
}
