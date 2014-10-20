/* GCompris - braille_alphabets.js
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/braille_alphabets/resource/"

var currentLevel
var numberOfLevel
var items
var dataset

var currentQuestion

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    currentLevel = 0
    numberOfLevel = dataset.length

    items.mapContainerModel.clear()
    for(var j = 0; j < 4; j++ ){
        for(var i = 0;  i < dataset[j].length; ++i) {
            if(dataset[j][i].letter != "1") {
                items.mapContainerModel.append( dataset[j][i] )
            }
            else {
                break;
            }
        }
    }

    for(var j = 3; j <5; j++ ) {
        for(var i = 0;  i < dataset[j].length; ++i) {
            items.mapContainerModel2.append( dataset[j][i] )
        }
    }
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.containerModel.clear()
    currentQuestion = 0

    for(var i = 0;  i < dataset[currentLevel].length; ++i) {
        items.containerModel.append(dataset[currentLevel][i])
    }
    items.playableChar.isLetter = dataset[currentLevel][0].letter >= "A" && dataset[currentLevel][0].letter <= "Z"
    items.playableChar.brailleChar = ""
    items.playableChar.updateDotsFromBrailleChar()

    // Shuffle again not to ask the question in the model order
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])
    initQuestion()

    instruction_text();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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

function instruction_text() {

    if(currentLevel==0) {
        items.instructions = ""
    } else if(currentLevel === 1) {
        items.instructions = qsTr("Look at the Braille character map and observe how similar the first and second line are.")

    } else if(currentLevel === 2) {
        items.instructions = qsTr("Again, similar as the first line but take care, the 'W' letter was added afterwards.")

    } else if(currentLevel === 3) {
        items.instructions = qsTr("This is easy, numbers are the same as letters from A to J.")

    } else {
        items.instructions = ""

    }
}

function getCurrentTextQuestion() {
    return dataset[currentLevel][currentQuestion].text
}

function getCurrentLetter() {
    return dataset[currentLevel][currentQuestion].letter
}

