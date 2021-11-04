/* GCompris - number_click.js
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/number_click/resource/"

var currentLevel = 0
var numberOfLevel = 10
var items

var randomNumber = 0
var lastRandomNumber = 0
var clickCount = 0

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    /*Avoiding recurrence between two levels*/
    while (lastRandomNumber === randomNumber) {
        randomNumber = Math.ceil(Math.random() * 10)
    }

    items.numericNumber.text = randomNumber
    items.numberInLetters.text = numericToLetters(randomNumber)

    clickCount = 0
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

function numericToLetters(number) {

    var result

    /*case 0 is not an option because we ceil the randomNumber
    for example : 0.1 gives 1*/
    switch(number) {    
        case 1:
            result = qsTr("ONE")
            break
        case 2:
            result = qsTr("TWO")
            break
        case 3:
            result = qsTr("THREE")
            break
        case 4:
            result = qsTr("FOUR")
            break
        case 5:
            result = qsTr("FIVE")
            break
        case 6:
            result = qsTr("SIX")
            break
        case 7:
            result = qsTr("SEVEN")
            break
        case 8:
            result = qsTr("EIGHT")
            break
        case 9:
            result = qsTr("NINE")
            break
        case 10:
            result = qsTr("TEN")
            break
        default:
            result = "Error"
            break
    }

    return result
}

function checkAnswer() {
    if (clickCount === randomNumber) {
        won()
        lastRandomNumber = randomNumber
    }
    else {
        tryAgain()
        showErrorpanel()
        clickCount = 0
    }
}

function showErrorpanel() {
    //Set position of the correct answer rectangle
    switch(randomNumber) {
        case 1:
            items.correctAnswer.anchors.horizontalCenter = items.firstbar.horizontalCenter
            break
        case 2:
            items.correctAnswer.anchors.horizontalCenter = items.secondbar.horizontalCenter
            break
        case 3:
            items.correctAnswer.anchors.horizontalCenter = items.thirdbar.horizontalCenter
            break
        case 4:
            items.correctAnswer.anchors.horizontalCenter = items.fourthbar.horizontalCenter
            break
        case 5:
            items.correctAnswer.anchors.horizontalCenter = items.fifthbar.horizontalCenter
            break
        case 6:
            items.correctAnswer.anchors.horizontalCenter = items.sixthbar.horizontalCenter
            break
        case 7:
            items.correctAnswer.anchors.horizontalCenter = items.seventhbar.horizontalCenter
            break
        case 8:
            items.correctAnswer.anchors.horizontalCenter = items.eighthbar.horizontalCenter
            break
        case 9:
            items.correctAnswer.anchors.horizontalCenter = items.ninthbar.horizontalCenter
            break
        case 10:
            items.correctAnswer.anchors.horizontalCenter = items.tenthbar.horizontalCenter
            break
    }

    //Set the possition of the wrong answer rectangle
    switch(clickCount) {
        case 1:
            items.wrongAnswer.anchors.horizontalCenter = items.firstbar.horizontalCenter
            break
        case 2:
            items.wrongAnswer.anchors.horizontalCenter = items.secondbar.horizontalCenter
            break
        case 3:
            items.wrongAnswer.anchors.horizontalCenter = items.thirdbar.horizontalCenter
            break
        case 4:
            items.wrongAnswer.anchors.horizontalCenter = items.fourthbar.horizontalCenter
            break
        case 5:
            items.wrongAnswer.anchors.horizontalCenter = items.fifthbar.horizontalCenter
            break
        case 6:
            items.wrongAnswer.anchors.horizontalCenter = items.sixthbar.horizontalCenter
            break
        case 7:
            items.wrongAnswer.anchors.horizontalCenter = items.seventhbar.horizontalCenter
            break
        case 8:
            items.wrongAnswer.anchors.horizontalCenter = items.eighthbar.horizontalCenter
            break
        case 9:
            items.wrongAnswer.anchors.horizontalCenter = items.ninthbar.horizontalCenter
            break
        case 10:
            items.wrongAnswer.anchors.horizontalCenter = items.tenthbar.horizontalCenter
            break
    }

   items.errorpanel.visible = true
}

function won() {
    items.bonus.good("flower")
}

function tryAgain() {
    items.bonus.bad("flower")
}

