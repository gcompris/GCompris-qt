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
var oldRandomNumber = 0
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

    /*Avoiding the recurrence between two levels*/
    while (oldRandomNumber === randomNumber) {
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

    /*case 0 must not be an option because we ceil the randomNumber
    for example : 0.1 become 1*/
    switch(number) {    
        case 0:
            result = qsTr("ZERO")
            break
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
        oldRandomNumber = randomNumber
    }
    else {
        tryAgain()
        clickCount = 0
    }
}

function won() {
    items.bonus.good("flower")
}

function tryAgain() {
    items.bonus.bad("flower")
}
