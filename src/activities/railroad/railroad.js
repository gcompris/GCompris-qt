/* GCompris - railroad.js
 *
 * Copyright (C) 2016 Irshaad Ali <irshaadali14@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Irshaad Ali <irshaadali14@gmail.com> (Qt Quick port)
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
            ["loco1.svg"],
            ["loco2.svg"],
            ["loco3.svg"],
            ["loco4.svg"],
            ["loco5.svg"],
            ["loco6.svg"],
            ["loco7.svg"],
            ["loco8.svg"],
            ["loco9.svg"],
            ["wagon1.svg"],
            ["wagon2.svg"],
            ["wagon3.svg"],
            ["wagon4.svg"],
            ["wagon5.svg"],
            ["wagon6.svg"],
            ["wagon7.svg"],
            ["wagon8.svg"],
            ["wagon9.svg"],
            ["wagon10.svg"],
            ["wagon11.svg"],
            ["wagon12.svg"],
            ["wagon13.svg"],

        ]


var url = "qrc:/gcompris/src/activities/railroad/resource/"



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
