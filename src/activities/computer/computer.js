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

// number of levels

var dataset = [
            [
                {
                    desc : "A monitor or a display is an electronic visual display for computers. The monitor comprises the display device, circuitry and an enclosure.",
                    name : qsTr("Monitor"),
                    img  : url + "images/monitor_off.svg"
                },
                {
                    desc : " central processing unit (CPU) is the electronic circuitry within a computer that carries out the instructions of a computer program by performing the basic arithmetic, logical, control and input/output (I/O) operations specified by the instructions. ",
                    name : qsTr("CPU"),
                    img  : url + "images/cpu.svg"
                },
                {
                    desc : " the keyboard is used as a text entry interface to type text and numbers into a word processor, text editor or other programs.A keyboard is also used to give commands to the operating system of a computer",
                    name : qsTr("Keyboard"),
                    img  : url + "images/keyboard.svg"
                },
                {
                    desc : "In computing, a mouse is a pointing device that detects two-dimensional motion relative to a surface. This motion is typically translated into the motion of a pointer on a display, which allows for fine control of a graphical user interface.",
                    name : qsTr("Mouse"),
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
var index = 0

function start(items_,quiz_) {
    items = items_
    currentLevel = 0
    initLevel()
    count = 0
    level = 0
    quiz = quiz_
    index = 0
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
        items.proceed.visible = true
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

function nextQuestion() {
    items.answers.model = []

    var answerModel = new Array()

    for (var i = 0 ;i < dataset[level].length; i++)
    {
        answerModel.push(dataset[level][i].name)
    }

    items.img.source = dataset[level][index].img
    items.answers.model = answerModel
}

function getCorrectAnswer() {
    return dataset[level][index].name
}

function showAnswer()
{
    console.log(dataset[level][index].name)
    items.name.visible = true
    win()
}

function win () {
    items.bonus.good("flower")
    items.name.visible = false
    if(index < dataset[level].length)
    {
        index++
        nextQuestion()
    }
    else {
        nextLevel()
    }
}

function sublevel() {
    items.proceed.visible = true
}
