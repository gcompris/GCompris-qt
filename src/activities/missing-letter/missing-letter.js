/* GCompris - missing-letter.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   "Pascal Georges" <pascal.georgis1.free.fr> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
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
.import GCompris 1.0 as GCompris //for ApplicationInfo

var url = "qrc:/gcompris/src/activities/missing-letter/resource/"

var questionsStatic =
        [
            [
                // Level 1
                {
                    questionString: "c_r",
                    answerString  : "car",
                    choiceString  : "atr",
                    pictureSource : url + "car.png",
                },
                {
                    questionString: "_og",
                    answerString  : "dog",
                    choiceString  : "dws",
                    pictureSource : url + "dog.png",
                },
                {
                    questionString: "_pple",
                    answerString  : "apple",
                    choiceString  : "back",
                    pictureSource : url + "apple.png",
                },

                {
                    questionString: "bal_",
                    answerString  : "ball",
                    choiceString  : "hlt",
                    pictureSource : url + "ball.png",
                }
            ],
            [
                // Level 2
                {
                    questionString: "be_",
                    answerString  : "bed",
                    choiceString  : "dfg",
                    pictureSource : url + "bed.png",
                },
                {
                    questionString: "_ake",
                    answerString  : "cake",
                    choiceString  : "lxc",
                    pictureSource : url + "cake.png",
                },
                {
                    questionString: "ba_",
                    answerString  : "bag",
                    choiceString  : "qlg",
                    pictureSource : url + "bag.png",
                },
                {
                    questionString: "f_sh",
                    answerString  : "fish",
                    choiceString  : "epi",
                    pictureSource : url + "fish.png",
                }
            ],
            [
                // Level 3
                {
                    questionString: "bana_a",
                    answerString  : "banana",
                    choiceString  : "bakn",
                    pictureSource : url + "banana.png",
                },
                {
                    questionString: "bottl_",
                    answerString  : "bottle",
                    choiceString  : "degw",
                    pictureSource : url + "bottle.png",
                },
                {
                    questionString: "_ouse",
                    answerString  : "house",
                    choiceString  : "khpz",
                    pictureSource : url + "house.png",
                },
                {
                    questionString: "_lane",
                    answerString  : "plane",
                    choiceString  : "lmpo",
                    pictureSource : url + "plane.png",
                }
            ]
        ]

var items
var currentLevel
var numberOfLevel
var currentQuestionNumber

var questions
var dataset

function start(items_)
{
    items = items_
    currentLevel = 0
    questions = questionsStatic
    createLastLevel()
    numberOfLevel = questions.length
    initLevel()
}

function stop()
{
}

function initLevel()
{
    items.bar.level = currentLevel + 1
    dataset = Core.shuffle(questions[currentLevel])
    currentQuestionNumber = 0
    nextQuestion()
    items.currentQuestionNumberText.text = "1/" + dataset.length
}

function nextLevel()
{
    if(numberOfLevel <= ++currentLevel )
    {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel()
{
    if(--currentLevel < 0)
    {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function correctOptionPressed()
{
    nextQuestion()

    if( currentQuestionNumber > dataset.length )
        currentQuestionNumber = 0

    items.currentQuestionNumberText.text =
            currentQuestionNumber + "/" + dataset.length
}

function wrongOptionPressed()
{
    items.bar.opacity = 1
}

function getCorrectAnswer()
{
    var question = dataset[currentQuestionNumber]
    var currentQuestion = question.questionString
    var i = 0
    for(  ; i < currentQuestion.length ; ++i )
    {
        if( "_" == currentQuestion.charAt(i)  )
        {
            break;
        }
    }

    return question.answerString.charAt(i)
}

// Take appropriate action based on the character being pressed
function answerPressed(character)
{
    if( character === getCorrectAnswer() )
    {
        items.bonus.good("flower")
        return true
    }
    else
    {
        items.bonus.bad("flower")
    }
    return false
}

function showAnswer()
{
    var question = dataset[currentQuestionNumber]
    items.questionText.text = question.answerString
    items.questionText.state = "answer"
}

// Reset the screen values for next question
function nextQuestion()
{
    items.questionText.state = "question"
    items.answers.model = []

    if(++currentQuestionNumber >= dataset.length) {
        nextLevel()
        return
    }

    var question = dataset[currentQuestionNumber]

    var choice = question.choiceString

    var answersModel = new Array()
    for(var i = 0 ; i < choice.length ; ++i)
        answersModel.push(choice.charAt(i))
    items.answers.model = answersModel

    items.questionText.text = question.questionString
    items.questionImage.source = question.pictureSource
}

// Add a new level which contains all the questions given in the
// questions list, combined together.
function createLastLevel()
{
    var lastData = []
    for(var level = 0 ; level < questions.length ; ++level)
        for(var i = 0 ; i < questions.length ; ++i)
            lastData.push(questions[level][i])

    questions.push(lastData)

}

function playLetter(letter) {
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter)))
}
