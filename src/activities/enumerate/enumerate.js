/* GCompris - enumarate.js
*
* Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/enumerate/resource/"
var url2 = "qrc:/gcompris/src/activities/algorithm/resource/"
var items
var currentLevel = 0
var numberOfLevel = 9
var itemIcons = [
            url2 + "apple.svg",
            url2 + "banana.svg",
            url2 + "cherries.svg",
            url + "grapes.svg",
            url2 + "lemon.svg",
            url2 + "orange.svg",
            url + "peach.svg",
            url2 + "pear.svg",
            url2 + "plum.svg",
            url + "strawberry.svg",
            url + "watermelon.svg",
        ]
var numberOfTypes = itemIcons.length
var userAnswers = new Array()
var answerToFind = new Array()


// We keep a globalZ across all items. It is increased on each
// item selection to put it on top
var globalZ = 0

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    cleanUp()
}

function initLevel() {
    items.bar.level = currentLevel + 1
    cleanUp()

    var numberOfItemType
    var numberOfItemMax

    switch(currentLevel)
    {
    case 0:
        numberOfItemType = 1;
        numberOfItemMax  = 5;
        break;
    case 1:
        numberOfItemType = 2;
        numberOfItemMax  = 5;
        break;
    case 2:
        numberOfItemType = 3;
        numberOfItemMax  = 4;
        break;
    case 3:
        numberOfItemType = 3;
        numberOfItemMax  = 5;
        break;
    case 4:
        numberOfItemType = 4;
        numberOfItemMax  = 5;
        break;
    case 5:
        numberOfItemType = 4;
        numberOfItemMax  = 6;
        break;
    case 6:
        numberOfItemType = 5;
        numberOfItemMax  = 5;
        break;
    case 7:
        numberOfItemType = 4;
        numberOfItemMax  = 6;
        break;
    case 8:
        numberOfItemType = 3;
        numberOfItemMax  = 8;
        break;
    default:
        numberOfItemType = 2;
        numberOfItemMax  = 9;
    }

    itemIcons = Core.shuffle(itemIcons)
    var enumItems = new Array()
    var types = new Array()

    for(var type = 0; type < numberOfItemType; type++) {
        var nbItems = getRandomInt(1, numberOfItemMax)
        for(var j = 0; j < nbItems; j++) {
            enumItems.push(itemIcons[type])
        }
        answerToFind[itemIcons[type]] = nbItems
        types.push(itemIcons[type])
    }
    items.answerColumnModel = types
    items.itemListModel = enumItems
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

function cleanUp() {
    userAnswers = new Array()
    answerToFind = new Array()
}

function setUserAnswer(imgPath, userValue) {
    userAnswers[imgPath] = userValue
    checkAnswers()
    return userAnswers[imgPath] === answerToFind[imgPath]
}

function checkAnswers() {
    for (var key in answerToFind) {
        if(userAnswers[key] !== answerToFind[key]) {
            return;
        }
    }
    items.bonus.good("smiley")
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

var currentAnswerItem

function registerAnswerItem(item) {
    currentAnswerItem = item
    item.forceActiveFocus()
}
