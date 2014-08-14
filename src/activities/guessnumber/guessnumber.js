/* GCompris - guessnumber.js
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

var currentLevel = 0
var numberOfLevel = 4
var items
var numberToGuess = 0
var currentMax

function start(items_) {
    console.log("guessnumber activity: start")
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("guessnumber activity: stop")
}

function initLevel() {
    console.log("guessnumber activity: create some content in my activity")
    items.bar.level = currentLevel + 1
    items.helico.x = 0
    items.helico.y = items.background.height/2
    items.helico.state = "horizontal"
    items.infoText.text=qsTr("")
    switch(currentLevel) {
    case 0: currentMax = 20
            numberToGuess = getRandomInt(1,currentMax)
            break;
    case 1: currentMax = 40
            numberToGuess = getRandomInt(1,currentMax)
            break;
    case 2: currentMax = 60
            numberToGuess = getRandomInt(1,currentMax)
            break;
    case 3: currentMax = 99
            numberToGuess = getRandomInt(1,currentMax)
            break;
    }
    items.textzone.text = qsTr("Guess a number between 1 and " + currentMax)
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

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function setUserAnswer(value){
    if(value==0)
        return;
    if(value>currentMax){
        items.infoText.text = qsTr("Number too high")
        return;
    }
    if(value>numberToGuess){
        items.infoText.text = qsTr("Number too high")
    }
    if(value<numberToGuess){
        items.infoText.text = qsTr("Number too low")
    }
    items.helico.state="advancing"
    if(value==numberToGuess){
        items.infoText.text = qsTr("Number found!")
        items.bonus.good("tux")
        items.helico.x = items.background.width
        items.helico.y = items.background.height/2 - items.background.height/10
    }
    else {
        var diff = Math.abs(numberToGuess-value)/currentMax
        items.helico.x = (items.background.width-items.helico.width)-diff*items.background.width
        items.helico.y = items.background.height/2 + ((numberToGuess-value)/currentMax)*(items.background.height/2) - items.helico.height/2
    }
}

var currentAnswerItem

function registerAnswerItem(item) {
    currentAnswerItem = item
    item.forceActiveFocus()
}
