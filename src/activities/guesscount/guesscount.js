/* GCompris - guesscount.js
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
var url = "qrc:/gcompris/src/activities/guesscount/resource/"
var currentLevel = 0
var numberOfLevel = 4
var items
var images = [
            ["plus.svg","+"],
            ["minus.svg","-"],
            ["div.svg","/"],
            ["multiply.svg","*"],
             ]
var dataset=[
            {
                'level': 1,
                "data": {
                    "questions":"3",
                    "numbers":[
                        [[1,2],3],
                        [[2,3],6],
                        [[9,4],5]
                    ]

                }
            }
        ]

function start(items_) {
    items = items_
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


function decidekeys(index){
var keys=[]
    if(index==1)
        keys=["operator"]
    else
        keys=["number"]
   return keys
}
