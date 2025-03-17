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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentHands = []
var levels = [
    { "images": [
        "main_droite_dessus_0.webp",
        "main_droite_paume_0.webp" ,
        "main_gauche_dessus_0.webp",
        "main_gauche_paume_0.webp" ],
      "rotations": [-90]
    },
    { "images": [
        "main_droite_dessus_0.webp",
        "main_droite_paume_0.webp",
        "main_gauche_dessus_0.webp",
        "main_gauche_paume_0.webp" ],
      "rotations": [0, 180]
    },
    { "images": [
        "main_droite_dessus_0.webp",
        "main_droite_paume_0.webp",
        "main_gauche_dessus_0.webp",
        "main_gauche_paume_0.webp" ],
        "rotations": [90]
     },
    { "images": [
        "poing_droit_dessus_0.webp",
        "poing_droit_paume_0.webp",
        "poing_gauche_dessus_0.webp",
        "poing_gauche_paume_0.webp" ],
        "rotations": [-90]
    },
    { "images": [
        "poing_droit_dessus_0.webp",
        "poing_droit_paume_0.webp",
        "poing_gauche_dessus_0.webp",
        "poing_gauche_paume_0.webp" ],
        "rotations": [0, 180]
    },
    { "images": [
        "poing_droit_dessus_0.webp",
        "poing_droit_paume_0.webp",
        "poing_gauche_dessus_0.webp",
        "poing_gauche_paume_0.webp" ],
        "rotations": [90]
    },
]


var items

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(levels.length)
    initLevel()
}

function stop() {

}

function initLevel() {
    items.score.currentSubLevel = 0
    currentHands = new Array()
    var level = levels[items.currentLevel]
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
    items.score.stopWinAnimation()
    items.currentLevel = Core.getNextLevel(items.currentLevel, levels.length);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, levels.length);
    initLevel();
}

function displayHand() {
    items.leftButton.isCorrectAnswer = isLeft()
    items.rightButton.isCorrectAnswer = isRight()
    items.imageAnimOff.start()
    items.buttonsBlocked = false
}

function getCurrentHandImage() {
    return "qrc:/gcompris/src/activities/leftright/resource/" +
            currentHands[items.score.currentSubLevel].image
}

function getCurrentHandRotation() {
    return currentHands[items.score.currentSubLevel].rotation
}

function displayNextHand() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("flower")
        return
    }
    displayHand()
}

function isLeft() {
    return (currentHands[items.score.currentSubLevel].image.indexOf("gauche") !== -1) ? true : false
}


function isRight() {
    return (currentHands[items.score.currentSubLevel].image.indexOf("droit") !== -1) ? true : false
}


function goodAnswerPressed() {
    items.score.currentSubLevel++;
    items.score.playWinAnimation();
}
