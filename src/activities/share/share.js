/* GCompris - share.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick version)
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

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var filename = "resource/board/"+ "board" + currentLevel + ".qml"
    items.dataset.source = filename
    var levelData = items.dataset.item

    setUp()
}

function setUp() {
    var levelData = items.dataset.item

    items.nBoys = levelData.levels[items.currentSubLevel].nBoys
    items.nGirls = levelData.levels[items.currentSubLevel].nGirls
    items.nCandies = levelData.levels[items.currentSubLevel].nCandies

    items.background.nCrtCandies = 0
    items.background.nCrtGirls = 0
    items.background.nCrtBoys = 0
    items.background.resetCandy()

    items.acceptCandy = false

    items.instruction.text = levelData.levels[items.currentSubLevel].instruction
    items.instruction.opacity = 1

    items.nbSubLevel = levelData.levels.length

    items.listModel1.clear()

    items.girlWidget.nCrt = 0
    items.girlWidget.canDrag = true
    items.girlWidget.element.opacity = 1

    items.boyWidget.nCrt = 0
    items.boyWidget.canDrag = true
    items.boyWidget.element.opacity = 1

    items.candyWidget.canDrag = true
    items.candyWidget.element.opacity = 1

    items.basketWidget.canDrag = true
    items.basketWidget.element.opacity = 0
}

function nextSubLevel() {
    items.currentSubLevel ++
    if (items.currentSubLevel === items.nbSubLevel) {
        nextLevel()
    }
    setUp()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
