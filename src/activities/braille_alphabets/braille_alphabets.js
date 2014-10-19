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
    for(var j = 0; j <4; j++ ){

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

//  current_alphabet() prints current alphabet on the console

function current_alphabet() {

    var cur_alphabet = [];
    var p=0;
    for(var i  = 0; i <= 5; i++) {
        if(items.circles.circles.itemAt(i).state == "on") {
            cur_alphabet.push(({"pos":i+1}))
            p++;
        }
    }

    for(var j=0; j<3; j++ ) {
        for(var i = 0;  i < dataset[j].length; ++i) {
            if(dataset[j][i].braille_letter.length == cur_alphabet.length) {
                var temp = [];
                temp = dataset[j][i].braille_letter
                var count1 = 0;
                for(var t = 0; t < dataset[j][i].braille_letter.length; t++) {
                    if(temp[t].pos == cur_alphabet[t].pos) {
                        count1++;
                    }
                    else {
                        break;
                    }
                }
                if(count1 == dataset[j][i].braille_letter.length) {
                    console.log(dataset[j][i].letter,"letter")
                }
           }
        }
    }
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
        items.instructions.text = ""
    } else if(currentLevel==1) {
        items.instructions.text = "Look at the Braille character map and observe how similar the first and second line are."

    } else if(currentLevel==2) {
        items.instructions.text = "Again, similar as the first line but take care, the 'W' letter was added afterwards."

    } else if(currentLevel==3) {
        items.instructions.text = "This is easy, numbers are the same as letters from A to J."

    } else {
        items.instructions.text = " "

    }
}

function getCurrentTextQuestion() {
    return dataset[currentLevel][currentQuestion].text
}

function getCurrentAlphabet() {
    return dataset[currentLevel][currentQuestion].letter
}

function getCurrentArr() {
    return dataset[currentLevel][currentQuestion].braille_letter
}
