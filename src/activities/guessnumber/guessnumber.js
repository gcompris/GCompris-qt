/* GCompris - guessnumber.js
 *
 * Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Clement Coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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

var currentLevel = 0
var numberOfLevel
var items
var numberToGuess = 0

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    numberOfLevel = items.levels.length
    items.bar.level = currentLevel + 1
    items.currentMax = items.levels[currentLevel].maxNumber
    items.helico.init()
    items.helico.state = "horizontal"
    items.infoText.text = ""
    items.numpad.resetText()
    numberToGuess = getRandomInt(1, items.levels[currentLevel].maxNumber)
    items.textArea.text = items.levels[currentLevel].objective
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
    if(value === 0)
        return;
    if(value > items.levels[currentLevel].maxNumber){
        items.infoText.text = qsTr("Number too high")
        return;
    }
    if(value > numberToGuess){
        items.infoText.text = qsTr("Number too high")
    }
    if(value < numberToGuess){
        items.infoText.text = qsTr("Number too low")
    }
    items.helico.state = "advancing"
    if(value === numberToGuess) {
        items.infoText.text = qsTr("Number found!")
        items.bonus.good("tux")
        items.helico.x = items.background.width
        items.helico.y = items.background.height / 2 - items.helico.height / 2
    } else {
        var diff = Math.abs(numberToGuess-value) / items.levels[currentLevel].maxNumber
        items.helico.x = (items.background.width-items.helico.width) - diff * items.background.width
        items.helico.y = items.background.height / 2 +
                ((numberToGuess-value) / items.levels[currentLevel].maxNumber) * (items.background.height/2) - items.helico.height / 2
    }
}
