/* GCompris - brm.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

var currentLevel
var numberOfLevel
var items
var dataset

var currentQuestion

function start(items_, dataset_) {
    items = items_
    dataset=dataset_.get()
    currentLevel = 0
    numberOfLevel = dataset.length
    initLevel()

}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.containerModel.clear()
    currentQuestion = 0
    //dataset[currentLevel] = Core.shuffle(dataset[currentLevel])

    for(var i = 0;  i < dataset[currentLevel].length; ++i) {
        items.containerModel.append(dataset[currentLevel][i])
    }

    // Shuffle again not to ask the question in the model order
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])
    initQuestion()

    if(currentLevel==0){
        items.instructions.text=""
    }
    else if(currentLevel==1){
        items.instructions.text="Look at the Braille character map and observe how similar the first and second line are."

    }
    else if(currentLevel==2){
        items.instructions.text="Again, similar as the first line but take care, the 'W' letter was added afterwards."

    }
    else if(currentLevel==3){
        items.instructions.text="This is easy, numbers are the same as letters from A to J."

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

function initQuestion() {
    // We just set the opacity to 0, the questionItem will then grab
    // the new question by itself
    items.questionItem.opacity = 0

}

function nextQuestion() {
    if(dataset[currentLevel].length <= ++currentQuestion ) {
        items.bonus.good("flower")
    } else {
        initQuestion()
    }
}

function instruction_text(){
    console.log (getCurrentLevel(),"dg");
    if(currentLevel==0){
        items.instructions.text=""
    }
    else if(currentLevel==1){
        items.instructions.text="Look at the Braille character map and observe how similar the first and second line are."

    }
    else if(currentLevel==2){
        items.instructions.text="Again, similar as the first line but take care, the 'W' letter was added afterwards."

    }
    else if(currentLevel==3){
        items.instructions.text="This is easy, numbers are the same as letters from A to J."

    }
}

function getCurrentTextQuestion() {
    return dataset[currentLevel][currentQuestion].text
}

function getCurrentStateOne() {
    return dataset[currentLevel][currentQuestion].one
}

function getCurrentStateTwo() {
    return dataset[currentLevel][currentQuestion].two
}

function getCurrentStateThree() {
    return dataset[currentLevel][currentQuestion].three
}

function getCurrentStateFour() {
    return dataset[currentLevel][currentQuestion].four
}

function getCurrentStateFive() {
    return dataset[currentLevel][currentQuestion].five
}

function getCurrentStateSix() {
    return dataset[currentLevel][currentQuestion].six
}
function getCurrentAlphabet() {
    return dataset[currentLevel][currentQuestion].letter
}

function getCurrentLevel() {
    return currentLevel
}
