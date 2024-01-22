/* GCompris - adjacent_numbers.js
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

var dataset
var currentExercise
var numberExercises
var subLevelStartTiles // Start tiles for each sublevel

var expectedAnswer // The expected answer, as an array of strings
                   // through this code, the answer and question array contains strings

// Check if level data contains all the expected keys
function hasMandatoryKeys(level, levelIndex)
{
    var expectedKeys = ["title", "lowerBound", "upperBound", "step", "numberShown",
            "indicesToGuess", "numberRandomLevel", "fixedLevels", "numberPropositions"]
    var missingKeys = []
    for(const key of expectedKeys) {
        if(level[key] === undefined) {
            missingKeys.push(key)
        }
    }

    if (missingKeys.length !== 0)
    {
        console.error("Level " + levelIndex + " is malformated. The following elements are missing: " + missingKeys +
                      "\nLevel will be ignored")
        return false
    }
    return true
}

// Check the consistency of the values defined in the level structure
// returns true when the level seems valid
function validateLevel(level, levelIndex)
{
    if(!hasMandatoryKeys(level, levelIndex))
    {
        return false
    }

    var valid = true
    const lowerBound = level.lowerBound
    const upperBound = level.upperBound
    const step = level.step
    if(step === 0)
    {
        console.error("The 'step' defined in level " + levelIndex + " is 0.")
        valid = false
    }

    if (lowerBound > upperBound)
    {
        console.error("'lowerBound' is greater than 'upperBound' (" + lowerBound + " > " + upperBound + ")")
        valid = false
    }

    for(var index of level.indicesToGuess)
    {
        if(index >= level.numberShown)
        {
            console.error("Invalid indice to guess (" + index + "). Only " + level.numberShown + " tiles will be displayed")
            valid = false
        }
    }

    for(var start of level.fixedLevels)
    {
        if(start < lowerBound ||
           start > upperBound)
        {
            console.error("Invalid start value (" + start + ") for fixedLevels")
            valid = false
        }
    }

    const numberPropositions = level.numberPropositions
    if (numberPropositions <= 0)
    {
        console.error("Invalid number of propositions (" + numberPropositions + ")")
        valid = false
    }


    if(!valid)
    {
        console.error("Level " + levelIndex + " contains errors and will be ignored")
    }

    return valid
}

function start(items_) {
    items = items_

    dataset = items.levels
    dataset = dataset.filter((level,i) => validateLevel(level,i))

    numberExercises = dataset.length

    currentExercise = Core.getInitialLevel(numberExercises)
    items.score.currentSubLevel = 0

    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentExercise + 1

    items.questionTilesModel.clear();
    items.proposedTilesModel.clear();

    items.answerCompleted = false
    items.buttonsEnabled = true

    items.instruction.text = dataset[currentExercise].title

    // Sublevel setup
    if(items.score.currentSubLevel === 0) // we need to generate the sublevels
    {
        subLevelStartTiles = []
        if(items.randomSubLevels) {
            const lowerBound = dataset[currentExercise].lowerBound
            const upperBound = dataset[currentExercise].upperBound
            const step = dataset[currentExercise].step
            var possibleStartTiles = getStartTiles(lowerBound, upperBound, step)
            possibleStartTiles = Core.shuffle(possibleStartTiles)
            subLevelStartTiles = possibleStartTiles.slice(0, dataset[currentExercise].numberRandomLevel)
        }
        else
        {
            subLevelStartTiles = Array.from(dataset[currentExercise].fixedLevels)
        }
    }

    // Question tile generation
    var question = getQuestionArray(subLevelStartTiles[items.score.currentSubLevel],
                                    dataset[currentExercise].step, dataset[currentExercise].numberShown,
                                    dataset[currentExercise].indicesToGuess);
    for(const value of question)
    {
        if (value === '?') {
            items.questionTilesModel.append({
                                                "value": "?",
                                                "tileState": "NONE",
                                                "canDrop": true,
                                                "tileEdited": false
                                            })

        }
        else {
            items.questionTilesModel.append({
                                                "value": value,
                                                "tileState": "NONE",
                                                "canDrop": false,
                                                "tileEdited": true
                                            })
        }
    }

    // Generation of answer tiles
    var proposedAnswers = getCorrectAnswers(question);
    // Generate more propositions and avoid duplicates
    while (proposedAnswers.length < dataset[currentExercise].numberPropositions)
    {
        // Find number close to the starting one for the current question
        var multiplier = Math.floor(Math.random() * 15) - 5 // between -5 and 15
        var proposal = subLevelStartTiles[items.score.currentSubLevel] + dataset[currentExercise].step * multiplier
        if (proposal >= dataset[currentExercise].lowerBound)
        {
            var proposalStr = proposal.toString()
            if(!proposedAnswers.includes(proposalStr))
            {
                proposedAnswers.push(proposalStr)
            }
        }
    }

    proposedAnswers = Core.shuffle(proposedAnswers)
    for (var i = 0 ; i < proposedAnswers.length ; i++)
    {
        items.proposedTilesModel.append({
                                            "value": proposedAnswers[i],
                                        })
    }

    items.score.numberOfSubLevels = subLevelStartTiles.length
}

/// Returns an array containing the possible start tiles
/// Loop from lowerBound to upperBound using the step, to only generate valid numbers
function getStartTiles(lowerBound, upperBound, step)
{
    var tiles = []
    var n = lowerBound
    while (n <= upperBound)
    {
        tiles.push(n)
        n += step
    }
    return tiles;
}

// Returns an array containing the items that the pupil should answer (the ones missing from the question)
function getCorrectAnswers(question)
{
    var correctAnswers = []
    for(var i = 0 ; i < question.length ; i++)
    {
        if (question[i] === '?')
        {
            correctAnswers.push(expectedAnswer[i])
        }
    }
    return correctAnswers
}

function nextLevel() {
    items.score.stopWinAnimation()
    items.score.currentSubLevel = 0
    currentExercise = Core.getNextLevel(currentExercise, numberExercises)
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.score.currentSubLevel = 0
    currentExercise = Core.getPreviousLevel(currentExercise, numberExercises)
    initLevel();
}

// Produce a question, using the given start as first item, and return the answer
function getNextQuestionArray(start, step, number) {
    var question = []
    for (var i = 0 ; i < number ; i++)
    {
        question.push((start + i * step).toString())
    }
    return question
}

// Make a question out of an answer
// copy answer and put '?' in it at tileIndices positions
function hideTiles(answer, tileIndices)
{
    var question = Array.from(answer)
    for(const index of tileIndices) {
        question[index] = '?'
    }
    return question
}

// Returns an array containing the question.
// It generates the answer and modify it to form a question out of it.
// The returned array contains numbers and '?' where the pupil should complete
function getQuestionArray(startTile, step, number, indicesToGuess) {
    expectedAnswer = getNextQuestionArray(startTile,
                                          step, number)

    var question = hideTiles(expectedAnswer, indicesToGuess)
    return question;
}


function isPupilAnswerRight(pupilAnswer) {
    if(expectedAnswer.length !== pupilAnswer.length) {
        console.error("Something really bad happened. Mismatch between input and answer array sizes")
        return false
    }

    for(var i = 0; i < expectedAnswer.length; i++)
    {
        if (pupilAnswer[i] !== expectedAnswer[i]) {
            return false
        }
    }
    return true;
}

function getPupilAnswerArray() {
    var pupilAnswer = []
    for(var i = 0 ; i < items.questionTilesModel.count ; i++)
    {
        pupilAnswer.push(items.questionTilesModel.get(i).value)
    }
    return pupilAnswer
}

// Check if the answer given by the pupil is correct and display the result
function checkAnswer() {
    items.buttonsEnabled = false
    // Trigger animation to show which tiles are correct or not
    for(var i = 0 ; i < items.questionTilesModel.count ; i++)
    {
        const tileData = items.questionTilesModel.get(i)
        if (tileData.canDrop)
        {
            var state = "NONE"
            if(checkTileAnswer(i, tileData.value)) {
                state = "RIGHT"
            }
            else {
                state = "WRONG"
                items.answerCompleted = false
            }
            items.questionTilesModel.set(i, {
                                            "tileState": state,
                                        });
        }
    }

    // Check the complete answer
    if (isPupilAnswerRight(getPupilAnswerArray()))
    {
        goodAnswerFeedback()
    }
    else
    {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
    }
}

function resetTile(index)
{
    items.questionTilesModel.set(index, {
                                     "value": '?',
                                     "tileState": "NONE",
                                     "tileEdited": false,
                                 });
}

function goodAnswerFeedback() {
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/win.wav')
}

function checkTileAnswer(index, value) {
    if(value === expectedAnswer[index])
        return true
    return false
}

function updatePupilAnswer(index, newValue) {
    if(newValue === '?') {
        resetTile(index);
        return
    }

    var state = "ANSWERED"
    items.questionTilesModel.set(index, {
                                     "value": newValue,
                                     "tileState": state,
                                     "tileEdited": true,
                                 });

    var completed = isAnswerComplete()
    items.answerCompleted = completed
    if (items.immediateAnswer && completed) {
        checkAnswer()
    }
}

// True when the question is fully completed
function isAnswerComplete() {
    var completed = true
    for(var i = 0 ; i < items.questionTilesModel.count ; i++)
    {
        if(items.questionTilesModel.get(i).value === '?' ||
            !items.questionTilesModel.get(i).tileEdited)
        {
            completed = false
            break
        }
    }
    return completed
}

// A sublevel has been successfully completed. Move to the next one
// or to the next level if all sublevels are done
function nextSubLevel()
{
    if (items.score.currentSubLevel >= subLevelStartTiles.length)
    {
        items.bonus.good("smiley")
    }
    else
    {
        initLevel();
    }
}
