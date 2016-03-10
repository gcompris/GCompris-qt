/* GCompris - GianaBhateja.js
 *
 * Copyright (C) 2016 GianaBhateja <dikshabhateja18@gmail.com>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "GianaBhateja" <dikshabhateja18@gmail.com> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/GianaBhateja/resource/"
var currentLevel = 0
var numberOfLevel = 4
var items
var dataset

function start(items_) {
    items = items_
    dataset=get()
    currentLevel = 0
    initLevel()
}

function stop() {
}
/*function get()
{
    return[
               [ {
                    "image": "qrc:/gcompris/src/activities/GianaBhateja/resource/img2.svg",
                    "text": qsTr("Game is coming soon. Stay tuned... :) "),
                    },
            ]
            ]
}*/

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
