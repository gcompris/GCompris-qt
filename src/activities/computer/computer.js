/* GCompris - computer.js
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick)
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
.import GCompris 1.0 as GCompris //for Applicationdataset
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/computer/resource/"

var dataset = [
            [
                {
                    desc : qsTr("A monitor or a display is an electronic visual display for computers. The monitor comprises the display device, circuitry and an enclosure."),
                    name : "Monitor",
                    id   : "monitor",
                    img  : url + "images/monitor.svg"
                },
                {
                    desc : qsTr(" central processing unit (CPU) is the electronic circuitry within a computer that carries out the instructions of a computer program by performing the basic arithmetic, logical, control and input/output (I/O) operations specified by the instructions. "),
                    name : "Central Processing Unit",
                    id   :"cpu",
                    img  : url + "images/cpu.svg"
                },
                {
                    desc : qsTr(" the keyboard is used as a text entry interface to type text and numbers into a word processor, text editor or other programs.A keyboard is also used to give commands to the operating system of a computer"),
                    name : "Keyboard",
                    id   :"keyboard",
                    img  : url + "images/keyboard.svg"
                },
                {
                    desc : qsTr("In computing, a mouse is a pointing device that detects two-dimensional motion relative to a surface. This motion is typically translated into the motion of a pointer on a display, which allows for fine control of a graphical user interface."),
                    name : "Mouse",
                    id   :"mouse",
                    img  : url + "images/mouse.svg"
                }
            ]
        ]

var currentLevel = 0
var numberOfLevel = 0
var items
var count = 0
var level = 0
var quiz

function start(items_,quiz_) {
    items = items_
    currentLevel = 0
    initLevel()
    count = 0
    level = 0
    quiz = quiz_
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
}

function previous() {
    display()
    if(count == 0)
        count = dataset[level].length - 1
    else
        count--
}

function next() {
    display()
    if( count == dataset[level].length - 1) {
        count = 0
    } else {
        count++
    }
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

function display() {
    items.img.source = dataset[level][count].img
    items.name.text = dataset[level][count].name
    items.info.text = dataset[level][count].desc
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

    var choice = question.choiceString

    var answersModel = new Array()
    for(var i = 0 ; i < choice.length ; ++i)
        answersModel.push(choice.charAt(i))
    items.answers.model = answersModel

    items.questionText.text = dataset[level][count].name
    items.questionImage.source = dataset[level][count].img
}

