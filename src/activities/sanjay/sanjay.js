/* GCompris - sanjay.js
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

var currentLevel = 0
var numberOfLevel = 8
var items
var animals=["bunny.svg","cat.svg","dog.svg","monkey.svg","panda-bear.svg","pig.svg","The_Whale-Fish.svg","tux_top_south.svg"]
var answers=["bunny","cat","dog","monkey","panda-bear","pig","whalefish","penguin"]
var url = "qrc:/gcompris/src/activities/sanjay/resource/"
var options

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    options=[currentLevel % animals.length,(currentLevel+1) % animals.length,(currentLevel+2) % animals.length]
    options=options.sort(function() { return .5 - Math.random();});
    items.option1.text=answers[options[0]]
    items.option2.text=answers[options[1]]
    items.option3.text=answers[options[2]]
    items.backgroundImg.source = url + animals[currentLevel % animals.length]
}


function validate(text){
    if(text===answers[currentLevel%animals.length]){
        items.respond.text="Corrrect"
        items.respond.color="green"
        items.respond.visible=true
        items.anim.running=true
        nextLevel()
//        items.respond.visible=false
    }else{
        items.respond.text="Wrong"
        items.respond.color="red"
        items.respond.visible=true
    }
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
