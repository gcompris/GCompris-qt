/* GCompris - louis-braille.js
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   <Srishti Sethi> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 4
var items
var dataset
var list

var url = "qrc:/gcompris/src/activities/louis-braille/resource/"

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    currentLevel = 0
    initLevel()
    list = dataset


}

function stop() {
}



function imgSelect(count) {

    switch(count) {
        case 0:
            items.img.source = dataset[0].img
            items.year.text = dataset[0].year
            items.info.text =dataset[0].text
            break
        case 1:
            items.img.source = dataset[1].img
            items.year.text = dataset[1].year
            items.info.text =dataset[1].text
            break
        case 2:
            items.img.source = dataset[2].img
            items.year.text = dataset[2].year
            items.info.text =dataset[2].text
            break
        case 3:
            items.img.source = dataset[3].img
            items.year.text = dataset[3].year
            items.info.text =dataset[3].text
            break
        case 4:
            items.img.source = dataset[4].img
            items.year.text = dataset[4].year
            items.info.text =dataset[4].text
            break
        case 5:
            items.img.source = dataset[5].img
            items.year.text = dataset[5].year
            items.info.text =dataset[5].text
            break
        case 6:
            items.img.source = dataset[6].img
            items.year.text = dataset[6].year
            items.info.text =dataset[6].text
            break
        case 7:
            items.img.source = dataset[7].img
            items.year.text = dataset[7].year
            items.info.text =dataset[7].text
            break
        case 8:
            items.img.source = dataset[8].img
            items.year.text = dataset[8].year
            items.info.text =dataset[8].text
            break
        case 9:
            items.img.source = dataset[9].img
            items.year.text = dataset[9].year
            items.info.text =dataset[9].text
            break
        case 10:
            items.img.source = dataset[10].img
            items.year.text = dataset[10].year
            items.info.text =dataset[10].text
            break
        case 11:

            break

    }

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
