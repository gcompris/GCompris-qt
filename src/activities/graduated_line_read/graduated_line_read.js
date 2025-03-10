/* GCompris - graduated_line_read.js
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import core 1.0 as GCompris // for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var activityMode
var maxSolutionSize = 0
var mapToPad = {}       // Maps keyboard charcodes to numPad's indexes to animate graphics from computer's numpad
var exercices = []

function randInt(max) { return Math.floor(Math.random() * max) }

function longInt(val) {     // Format number to string (avoid exponential notation)
    val = Number(val)
    var str = ""
    while (val !== 0) {
        var remainder = val % 10
        str = String(remainder) + str
        val = Math.floor(val / 10)
    }
    if (str === "") str = "0"
    return str
}

function createExercice(idx, rules, s) {
    var nbSeg = 2
    var step = rules.steps[s]
    var maxOffset = 0
    if (rules.fitLimits) {
        nbSeg = Math.floor((rules.range[1] - rules.range[0]) / step) + 1
    } else {
        nbSeg = 1 + rules.segments[0] + randInt(1 + rules.segments[1] - rules.segments[0])
        maxOffset = rules.range[1] - (nbSeg * step)
        while (maxOffset < 0) {             // if data is not valid, reduce the number of segment
            nbSeg--
            maxOffset =  rules.range[1] - (nbSeg * step)
        }
        maxOffset = rules.range[1] - ((nbSeg - 1) * step)
    }
    if (rules.fitLimits) {
        idx = 1 + (idx % (nbSeg - 2))
    } else {
        idx = randInt(nbSeg - 2) + 1
    }
    var start = rules.range[0] + randInt(maxOffset)
    return {
        "solution": idx,
        "step": step,
        "nbSeg": nbSeg,
        "start": start,
        "rangeMin": rules.range[0],
        "rangeMax": rules.range[1]
    }
}

function createLevel() {    // Create an array of exercice
    exercices = []
    var levelRules = items.levels[items.currentLevel].rules
    for(var s = 0; s < levelRules.steps.length; s++) {
        var nbTicks = Math.floor((levelRules.range[1] - levelRules.range[0]) / levelRules.steps[s]) -1
        for(var i = 0; i < nbTicks; i++) {
            var exo = createExercice(i, levelRules, s)
            exercices.push(exo)
        }
    }
}

function buildRuler() {     // Read from exercices with currentSubLevel index
    items.solutionGrad = 0
    items.rulerModel.clear()
    if (items.currentSubLevel % exercices.length === 0) // if first time or all exercices already done
        Core.shuffle(exercices)                         //    shuffle exercices before restarting
    var exo = exercices[items.currentSubLevel % exercices.length]
    var start = exo.start
    var thickStep = Math.floor(exo.rangeMax / 10)
    if (thickStep < 10)
        thickStep = 10
    var i = 0
    for (i = 0; i < exo.nbSeg; i++) {           // Create rulerModel
        var thick = items.segmentThickness
        if (start % thickStep === 0)
            thick = 2 * items.segmentThickness
        if ((i === 0) || (i === exo.nbSeg - 1))
            thick = 3 * items.segmentThickness
        items.rulerModel.append({ "value_": start
                                , "thickness_": thick })
        start += exo.step
    }
    maxSolutionSize = start.toString().length
    var min = (items.orientation === Qt.LeftToRight) ? 0 : items.rulerModel.count -1
    var max = (items.orientation === Qt.LeftToRight) ? items.rulerModel.count -1 : 0
    items.leftLimit.text = longInt(items.rulerModel.get(min).value_)
    items.rightLimit.text = longInt(items.rulerModel.get(max).value_)

    items.solutionGrad = exo.solution
    items.answer = items.rulerModel.get(items.solutionGrad).value_.toString()
    if (activityMode === "number2tick")   // Choose an other starting tick
        items.solutionGrad = randInt(exo.nbSeg - 2) + 1
}

function createRuler() {
    var levelRules = items.levels[items.currentLevel].rules
    items.numberOfSubLevel = levelRules.nbOfQuestions
    buildRuler()
    var title = items.levels[items.currentLevel].title
    if (!levelRules.fitLimits)
        title = title.substr(0, title.length - 1) + " " + qsTr("(variable boundaries)") + title.substr(title.length - 1)
}

function moveLeft() {
    if (items.score.isWinAnimationPlaying || items.buttonsBlocked)
        return
    if (items.solutionGrad > 1) {
        items.clickSound.play()
        items.solutionGrad--
    }
}

function moveRight() {
    if (items.score.isWinAnimationPlaying || items.buttonsBlocked)
        return
    if (items.solutionGrad < items.rulerModel.count - 2) {
        items.clickSound.play()
        items.solutionGrad++
    }
}

function checkResult() {
    if (items.score.isWinAnimationPlaying || items.buttonsBlocked)
        return
    items.buttonsBlocked = true;
    var success = false;
    switch (activityMode) {
    case "tick2number":
        success = (items.cursor.children[items.solutionGrad].textValue === items.answer);
        break
    case "number2tick":
        success = (items.rulerModel.get(items.solutionGrad).value_.toString() === items.answer);
        if (success)
            items.cursor.children[items.solutionGrad].textValue = items.answer;
        break
    }
    if (success) {
        items.goodAnswerSound.play();
        items.currentSubLevel ++;
        items.score.playWinAnimation();
    } else {
        items.badAnswerSound.play();
        items.buttonsBlocked = true;
        items.errorRectangle.startAnimation();
    }
}

function start(items_, activityMode_) {
    items = items_;
    activityMode = activityMode_
    items.orientation = (Core.isLeftToRightLocale(GCompris.ApplicationSettings.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
//    items.orientation = Qt.RightToLeft  // Force RightToLeft here
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel();
}

function stop() {
}

function initLevel() {
    items.errorRectangle.resetState();
    items.buttonsBlocked = false;
    items.currentSubLevel = 0;
    createLevel();
    createRuler();
 }

function nextLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextSubLevel() {
    if(items.currentSubLevel >= items.numberOfSubLevel)
        items.bonus.good("sun");
    else {
        items.buttonsBlocked = false;
        createRuler(); // initLevel();
    }
}

function previousSubLevel() {
    if( --items.currentSubLevel < 0)
        previousLevel();
    else {
        items.buttonsBlocked = false;
        createRuler(); // initLevel();
    }
}

function handleKeys(key) {
    if (items.score.isWinAnimationPlaying || items.buttonsBlocked)
        return
    if (items.orientation === Qt.RightToLeft) {
        switch (key) {
        case Qt.Key_Left:
            key = Qt.Key_Right
            break
        case Qt.Key_Right:
            key = Qt.Key_Left
            break
        }
    }
    switch (key) {
    case Qt.Key_Space:
    case Qt.Key_Return:
    case Qt.Key_Enter:
        if (activityMode === "tick2number") {
            if (items.cursor.children[items.solutionGrad].textValue !== "")
                checkResult()
        } else {
            checkResult()
        }

        break
    case Qt.Key_Left:
        if (activityMode === "number2tick")
            moveLeft()
        break
    case Qt.Key_Right:
        if (activityMode === "number2tick")
            moveRight()
        break
    case Qt.Key_0:
    case Qt.Key_1:
    case Qt.Key_2:
    case Qt.Key_3:
    case Qt.Key_4:
    case Qt.Key_5:
    case Qt.Key_6:
    case Qt.Key_7:
    case Qt.Key_8:
    case Qt.Key_9:
        if (activityMode === "number2tick")
            return
        if (items.cursor.children[items.solutionGrad].textValue.length < maxSolutionSize) {
            items.cursor.children[items.solutionGrad].textValue += key - '0'.charCodeAt(0)
            items.numPad.currentIndex = mapToPad[key]
            items.numPad.currentItem.state = "pressed"
        } else {
            items.smudgeSound.play()
        }

        break
    case Qt.Key_Backspace:
        if (activityMode === "number2tick")
            return
        items.cursor.children[items.solutionGrad].textValue = items.cursor.children[items.solutionGrad].textValue.slice(0, -1)
        items.numPad.currentIndex = mapToPad[key]
        items.numPad.currentItem.state = "pressed"
        break
    case Qt.Key_Delete:
        if (activityMode === "number2tick")
            return
        items.cursor.children[items.solutionGrad].textValue = ""
        items.numPad.currentIndex = mapToPad[key]
        items.numPad.currentItem.state = "pressed"
        break
    }
}

function handleEvents(event) {
    handleKeys(event.key)
}
