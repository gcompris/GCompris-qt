/* GCompris - solar_system.js
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
.import QtQuick 2.6 as Quick
.import "Dataset.js" as Dataset
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 4
var items
var dataset

function start(items_) {
    items = items_
    currentLevel = 0
    dataset= Dataset.get()
    for(var i = 0;  i < dataset.length; ++i) {
        items.containerModel.append({
                "clipImg": dataset[i].clipImg,
                "bodyName": dataset[i].bodyName
        });
    }
    items.solarSystemVisible = true
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.score.currentSubLevel = 1
    items.score.numberOfSubLevels = 5
}

function showQuestionScreen(index) {
    items.solarSystemVisible = false
    items.quizScreenVisible = true
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
