/* GCompris - left_right_click.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "../../core/core.js" as Core

var items;
var numberOfLevel = 3;
var animalCountForBonus = 0;
var cardsToDisplay;
// different number of cards to display per level
var levelDifficulty = [5, 7, 10]
var imgSrc = [
    "qrc:/gcompris/src/activities/left_right_click/resource/fish.svg",
    "qrc:/gcompris/src/activities/left_right_click/resource/monkey.svg"
]
var Position = {
    left: 0,
    right: 1
}

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel()
}

function stop() {
}

function initLevel() {
    items.animalListModel.clear();
    var animalArray = new Array();
    cardsToDisplay = levelDifficulty[items.currentLevel];
    items.animalCount = (cardsToDisplay / 2) * 3;
    var animalCardLeft = {
        "animalIdentifier": Position.left,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": false,
        "imageSource": imgSrc[0]
    }
    var animalCardRight = {
        "animalIdentifier": Position.right,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": false,
        "imageSource": imgSrc[1]
    }
    // this is invisible card so giving any value won't be of any use.
    var animalCardInvisible = {
        "animalIdentifier": Position.right,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": true,
        "imageSource": imgSrc[1]
    }
    for(var i = 0; i < Math.floor(cardsToDisplay/2); i++) {
        // with every iteration we insert 3 types of cards, invisible card to create a random spacing between the other two cards.
        animalArray.push(animalCardRight);
        animalArray.push(animalCardLeft);
        animalArray.push(animalCardInvisible);
    }
    // more right cards on level 1 than left cards.
    if(items.currentLevel === 0) {
        animalArray.push(animalCardLeft);
    }
    // more left cards on level 2 than right cards.
    else if(items.currentLevel === 1) {
        animalArray.push(animalCardRight);
    }
    Core.shuffle(animalArray);
    for(var i = 0; i < animalArray.length; i++) {
        items.animalListModel.append(animalArray[i]);
    }
    animalCountForBonus = 0;
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function incrementCounter() {
    animalCountForBonus++;
    if(animalCountForBonus % cardsToDisplay === 0) {
        items.bonus.good("lion");
    }
}

function playWrongClickSound() {
    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/crash.wav')
}
