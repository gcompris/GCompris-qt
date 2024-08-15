/* GCompris - multiple_choice_questions.js
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items

function start(items_) {
    items = items_;
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel();
}

function stop() {
}

function createLevel() {    // Create an array of exercice
    items.answerModel.clear();
    var sublevel = items.levels[items.currentLevel].subLevels[items.currentSubLevel];
    items.instruction.text = sublevel.question;
    var numberOfAnswers = sublevel.answers.length;
    if(sublevel.shuffleAnswers) {
        Core.shuffle(sublevel.answers);
    }
    for (var i = 0; i < numberOfAnswers; i++) {
        var answer = sublevel.answers[i];
        var isCorrect = sublevel.correctAnswers.indexOf(answer) != -1;
        var correctAnswerText = sublevel.correctAnswerText ?? "";
        var wrongAnswerText = sublevel.wrongAnswerText ?? "";

        items.answerModel.append({ "content_": answer,
                                   "isSolution_": isCorrect,
                                   "mode_": sublevel.mode,
                                   "correctAnswerText_": correctAnswerText,
                                   "wrongAnswerText_": wrongAnswerText,
                                   "checked_": false });
    }
}

function initLevel() {
    items.buttonsBlocked = false;
    items.currentSubLevel = 0;
    var level = items.levels[items.currentLevel]
    items.numberOfSubLevel = level.subLevels.length;
    if (level.shuffle) {
        Core.shuffle(level.subLevels);
    }
    createLevel();
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
    items.currentSubLevel ++;
    if(items.currentSubLevel >= items.numberOfSubLevel)
        items.bonus.good("sun");
    else {
        items.buttonsBlocked = false;
        createLevel();
    }
}

function checkResult() {
    if (items.score.isWinAnimationPlaying || items.buttonsBlocked)
        return
    items.buttonsBlocked = true;
    var success = true;

    for(var i = 0; i < items.answerModel.count; i++) {
        var answer = items.answerModel.get(i)
        if(answer.checked_ != answer.isSolution_) {
            success = false;
            break;
        }
    }

    var text = success ? items.answerModel.get(0).correctAnswerText_ : items.answerModel.get(0).wrongAnswerText_
    items.feedbackArea.display(success, text);
}
