/* GCompris - explore_farm_animals.js
 *
 * Copyright (C) 2015 Djalil Mesli <djalilmesli@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Djalil Mesli <djalilmesli@gmail.com> (Qt Quick port)
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
.import QtQml 2.0 as QML
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/explore_farm_animals/explore.js" as Dataset
var currentLevel = 0
var numberOfLevel = 3
var items
var dataset
var i
var comp = 0
var clicked= [0,0,0,0,0,0,0,0,0];
function start(items_,var_) {
    items = items_
    dataset=var_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
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

function getLevel() {
    return currentLevel
}

function getHeight(){
    return items.background.height
}

function getWidth(){
    return items.background.width
}

function isComplete(i){
    clicked[i]=1;
    var j=0;
        for (j; j<=8;j++ ){
            if (clicked[j] != 1 )
                return 0;
                             }
        return 1;
}
