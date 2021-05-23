/* GCompris - leftright.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.import QtQuick 2.9 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentHands = []
var levels = [
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png" ,
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
      "rotations": [-90]
    },
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png",
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
      "rotations": [0, 180]
    },
    { "images": [
        "main_droite_dessus_0.png",
        "main_droite_paume_0.png",
        "main_gauche_dessus_0.png",
        "main_gauche_paume_0.png" ],
        "rotations": [90]
     },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [-90]
    },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [0, 180]
    },
    { "images": [
        "poing_droit_dessus_0.png",
        "poing_droit_paume_0.png",
        "poing_gauche_dessus_0.png",
        "poing_gauche_paume_0.png" ],
        "rotations": [90]
    },
]


var currentImageId;
var currentLevel;
var items

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.currentSubLevel = 0
    initLevel()
}

function stop() {

}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentImageId = 0
    currentHands = new Array()
    var level = levels[currentLevel]
    var counter = 0
    for (var i = 0 ; i < level.images.length ; i++) {
        for (var r = 0 ; r < level.rotations.length ; r++) {
            currentHands[counter++] = {
                'image': level.images[i],
                'rotation': level.rotations[r] }
        }
    }

    items.score.numberOfSubLevels = level.images.length * level.rotations.length

    currentHands = Core.shuffle(currentHands)
    displayHand()
}

function nextLevel() {
    if(levels.length <= ++currentLevel ) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 0
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = levels.length - 1
    }
    items.score.currentSubLevel = 0
    initLevel();
}

function displayHand() {
    items.leftButton.isCorrectAnswer = isLeft()
    items.rightButton.isCorrectAnswer = isRight()
    items.imageAnimOff.start()
}

function getCurrentHandImage() {
    return "qrc:/gcompris/src/activities/leftright/resource/" +
            currentHands[currentImageId].image
}

function getCurrentHandRotation() {
    return currentHands[currentImageId].rotation
}

function displayNextHand() {
    items.score.currentSubLevel ++
    items.score.playWinAnimation();
    if(currentHands.length <= ++currentImageId ) {
        items.bonus.good("flower")
        return
    }
    displayHand()
}

function isLeft() {
    return (currentHands[currentImageId].image.indexOf("gauche") !== -1) ? true : false
}

function leftClick() {
    if(isLeft()) {
        displayNextHand()
    }
}

function isRight() {
    return (currentHands[currentImageId].image.indexOf("droit") !== -1) ? true : false
}

function rightClick() {
    if(isRight()) {
        displayNextHand()
    }
}

function leftClickPressed() {
    items.leftButton.pressed()
}

function rightClickPressed() {
    items.rightButton.pressed()
}
