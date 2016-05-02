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
var numberOfLevel = 5
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

    setUp()
}

function setUp() {
    var levelData = items.dataset.item

    items.totalBoys = levelData.levels[items.currentSubLevel].totalBoys
    items.totalGirls = levelData.levels[items.currentSubLevel].totalGirls
    items.totalCandies = levelData.levels[items.currentSubLevel].totalCandies

    items.background.currentCandies = 0
    items.background.currentGirls = 0
    items.background.currentBoys = 0
    items.background.rest = items.totalCandies -
            Math.floor(items.totalCandies / items.totalChildren) * (items.totalBoys+items.totalGirls)
    items.background.resetCandy()

    items.acceptCandy = false

    items.instruction.text = levelData.levels[items.currentSubLevel].instruction
    items.instruction.opacity = 1

    items.nbSubLevel = levelData.levels.length

    items.listModel.clear()

    items.girlWidget.current = 0
    items.girlWidget.canDrag = true
    items.girlWidget.element.opacity = 1
    items.girlWidget.showCount = levelData.levels[items.currentSubLevel].showCount

    items.boyWidget.current = 0
    items.boyWidget.canDrag = true
    items.boyWidget.element.opacity = 1
    items.boyWidget.showCount = levelData.levels[items.currentSubLevel].showCount

    items.candyWidget.canDrag = true
    items.candyWidget.element.opacity = 1
    items.candyWidget.showCount = levelData.levels[items.currentSubLevel].showCount

    items.basketWidget.canDrag = true
    items.basketWidget.element.opacity = (levelData.levels[items.currentSubLevel].forceShowBakset === true ||
                                          items.background.rest !== 0) ? 1 : 0

}

function nextSubLevel() {
    items.currentSubLevel ++
    if (items.currentSubLevel === items.nbSubLevel) {
        nextLevel()
    }
    else
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
