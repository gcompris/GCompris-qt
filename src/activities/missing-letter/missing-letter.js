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

var items
var currentLevel
var numberOfLevel = 4
var numberOfQuestions = 12
var currentQuestionNumber = 1

var questions =
        [
            // Level 1

            {
                "questionString": "c_r",
                "answerString"  : "car",
                "choiceString"  : "atr",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/car.png",
                level: 1,
                questionAsked: false
            },

            {
                "questionString": "_og",
                "answerString"  : "dog",
                "choiceString"  : "dws",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/dog.png",
                level: 1,
                questionAsked: false
            },

            {
                "questionString": "_pple",
                "answerString"  : "apple",
                "choiceString"  : "back",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/apple.png",
                level: 1,
                questionAsked: false
            },

            {
                "questionString": "bal_",
                "answerString"  : "ball",
                "choiceString"  : "hlt",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/ball.png",
                level: 1,
                questionAsked: false
            },

            // Level 2

            {
                "questionString": "be_",
                "answerString"  : "bed",
                "choiceString"  : "dfg",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/bed.png",
                level: 2,
                questionAsked: false
            },


            {
                "questionString": "_ake",
                "answerString"  : "cake",
                "choiceString"  : "lxc",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/cake.png",
                level: 2,
                questionAsked: false
            },

            {
                "questionString": "ba_",
                "answerString"  : "bag",
                "choiceString"  : "qlg",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/bag.png",
                level: 2,
                questionAsked: false
            },

            {
                "questionString": "f_sh",
                "answerString"  : "fish",
                "choiceString"  : "epi",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/fish.png",
                level: 2,
                questionAsked: false
            },

            // Level 3

            {
                "questionString": "bana_a",
                "answerString"  : "banana",
                "choiceString"  : "bakn",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/banana.png",
                level: 3,
                questionAsked: false
            },

            {
                "questionString": "bottl_",
                "answerString"  : "bottle",
                "choiceString"  : "degw",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/bottle.png",
                level: 3,
                questionAsked: false
            },

            {
                "questionString": "_ouse",
                "answerString"  : "house",
                "choiceString"  : "khpz",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/house.png",
                level: 3,
                questionAsked: false
            },

            {
                "questionString": "_lane",
                "answerString"  : "plane",
                "choiceString"  : "lmpo",
                pictureSource: "qrc:/gcompris/src/activities/missing-letter/resource/plane.png",
                level: 3,
                questionAsked: false
            }
        ]

// Returns the question number of a random question that hasnt been asked yet from the given level
function getNextRandomQuestionNumber(level)
{
    var seed = Math.floor((Math.random()*numberOfQuestions)+1);

    if( numberOfLevel >= level )
    {
        for ( var i = seed ; i < questions.length ; ++i )
        {
            if(( false === questions[i].questionAsked && level === questions[i].level) )
            {
                questions[i].questionAsked = true
                return i;
            }
        }

        for ( i = 0 ; i < seed ; ++i )
        {
            if( (false === questions[i].questionAsked && level === (questions[i].level)) )
            {
                questions[i].questionAsked = true
                return i;
            }
        }
    }

    return -1;
}

function start(items_)
{
    items = items_
    currentLevel = 0
    initLevel()
}

function stop()
{
    items.background.resetAllQuestions()
    currentLevel = 0
    items.background.nextQuestion()
    currentQuestionNumber = 1
    items.currentQuestionNumberText.text = "1/" + items.background.totalQuestionsInLevel(currentLevel+1)
}

function initLevel()
{
    items.bar.level = currentLevel + 1
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

function questionList()
{
    return questions;
}

function correctOptionPressed()
{
    items.background.nextQuestion()
    items.buttonHolderMouseArea = true
    items.bar.opacity = 1
    ++ currentQuestionNumber

    if( currentQuestionNumber > items.background.totalQuestionsInLevel(currentLevel+1) )
        currentQuestionNumber = 1

    items.currentQuestionNumberText.text = currentQuestionNumber + "/" + items.background.totalQuestionsInLevel(currentLevel+1)
}

function wrongOptionPressed()
{
    items.buttonHolderMouseArea = true
    items.bar.opacity = 1
}
