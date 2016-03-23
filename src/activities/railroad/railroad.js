/* GCompris - railroad.js
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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
var numberOfLevel = 3
var items

var backgroundImage = "railroad-bg.svg"


var trainParts = [
            ["loco1.svg",100,100],
            ["loco2.svg",100,100],
            ["loco3.svg",100,100],
            ["loco4.svg",100,100],
            ["loco5.svg",100,100],
            ["loco6.svg",100,100],
            ["loco7.svg",100,100],
            ["loco8.svg",100,100],
            ["loco9.svg",100,100],
            ["wagon1.svg",100,100],
            ["wagon2.svg",100,100],
            ["wagon3.svg",100,100],
            ["wagon4.svg",100,100],
            ["wagon5.svg",100,100],
            ["wagon6.svg",100,100],
            ["wagon7.svg",100,100],
            ["wagon8.svg",100,100],
            ["wagon9.svg",100,100],
            ["wagon10.svg",100,100],
            ["wagon11.svg",100,100],
            ["wagon12.svg",100,100],
            ["wagon13.svg",100,100],

        ]


var url = "qrc:/gcompris/src/activities/railroad/resource/"

if(trainPart.visible == true){
                   locAndWagonsRepeater.visible = false
               }
 else{
         locAndWagonsRepeater.visible = true         }

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    console.log(url + trainParts[1])
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
    trainParts[0][1] = 100
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
