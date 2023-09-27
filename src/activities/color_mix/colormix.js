/* GCompris - colormix.js'
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/color_mix/resource/"

var numberOfLevel = 6
var items
var maxSteps = 1

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.score.numberOfSubLevels = 6
    items.score.currentSubLevel = 1
    initLevel()
}

function stop() {}

function initLevel() {

    /* Set max steps */
    maxSteps = items.currentLevel + 1
    items.maxSteps = maxSteps

    /* Compute target color */
    items.targetColor1 = Math.floor(Math.random() * (maxSteps + 1))
    items.targetColor2 = Math.floor(Math.random() * (maxSteps + 1))
    items.targetColor3 = Math.floor(Math.random() * (maxSteps + 1))

    /* Reset current color */
    items.currentColor1 = 0
    items.currentColor2 = 0
    items.currentColor3 = 0

    /* Enable OK button */
    items.okEnabled = true
}

function getColor(i1, i2, i3) {
    return activity.modeRGB ? Qt.rgba(i1 / maxSteps, i2 / maxSteps,
                                      i3 / maxSteps,
                                      1) : Qt.rgba(1 - i3 / maxSteps,
                                                   1 - i1 / maxSteps,
                                                   1 - i2 / maxSteps, 1)
}

function nextSubLevel() {
    if (items.score.numberOfSubLevels >= ++items.score.currentSubLevel) {
        initLevel()
    } else {
        nextLevel()
    }
}

function nextLevel() {
    items.score.currentSubLevel = 1

    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel()
}

function previousLevel() {
    items.score.currentSubLevel = 1
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel()
}
