/* GCompris - target.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/target/resource/"

var levels
var items

var levelData

var centerColor = "#ee7f7f"
var outterColors = [
    "#eebf7f",
    "#e0ee7f",
    "#7fee8f",
    "#7fcbee",
    "#b8c8f6"
]
var circleColors = []

function start(items_) {
    items = items_
    levels = items.levels
    items.numberOfLevel = levels.length
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);

    initLevel()
}

function stop() {
}

function initLevel() {
    levelData = levels[items.currentLevel]
    items.score.currentSubLevel = 0;
    items.numberOfSubLevel = levelData.subLevels;
    initSubLevel();
}

function initSubLevel() {
    items.errorRectangle.resetState()
    items.targetModel.clear()
    items.arrowFlying = false
    var circleStepSize = 50
    var biggestCircleIndex = levelData.circleValues.length - 1
    spreadColors()
    for(var i = biggestCircleIndex;  i >= 0 ; --i) {
        var currentCircle = {
            size: circleStepSize * (i + 1),
            circleColor: circleColors[i],
            score: levelData.circleValues[i]
        }
        items.targetModel.append(currentCircle)
    }
    items.targetSize = (biggestCircleIndex + 1) * circleStepSize
    // Reset the arrows first
    items.nbArrow = levelData.arrows
    items.currentArrow = 0
    items.arrowRepeater.init(items.nbArrow)
    items.targetItem.start()
    items.userEntry.text = ""
    items.inputLocked = false
}

// Algo to spread circle colors as needed, with extra repeat from the border when needed
function spreadColors() {
    circleColors = [centerColor];
    var numberOfColors = outterColors.length;
    var numberOfCircles = levelData.circleValues.length - 1; // Center circle color is never repeated
    if(numberOfCircles <= numberOfColors) {
        for(var i = 0; i < numberOfCircles; i++) {
            circleColors.push(outterColors[i]);
        }
    } else {
         var baseSpread = Math.floor(numberOfCircles / numberOfColors);
         var extraSpread = baseSpread + 1;
         var numberExtraSpread = numberOfCircles % numberOfColors;
         var numberBaseSpread = numberOfColors - numberExtraSpread;
         var colorId = 0;
         for(var i = 0; i < numberBaseSpread; i++) {
             for(var j = 0; j < baseSpread; j ++) {
                 circleColors.push(outterColors[colorId]);
            }
            colorId++;
         }
         for(var i = 0; i < numberExtraSpread; i++) {
             for(var j = 0; j < extraSpread; j ++) {
                 circleColors.push(outterColors[colorId]);
             }
             colorId++;
         }
    }
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.numberOfSubLevel) {
        items.bonus.good("flower");
    } else {
        initSubLevel();
    }
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.score.currentSubLevel = 0;
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.score.currentSubLevel = 0;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function checkAnswer() {
    items.inputLocked = true;
    if(items.targetItem.scoreTotal.toString() === items.userEntry.text) {
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
    }
    else {
        items.errorRectangle.startAnimation()
        items.badAnswerSound.play()
    }
}
