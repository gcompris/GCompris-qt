/* GCompris - reversecount.js
 *
 * Copyright (C) 2014 Emmanuel Charruau
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
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
.import GCompris 1.0 as GCompris //for ApplicationInfo

var iceBlocksLayout = [[0, 0],[1, 0],[2, 0],[3, 0],[4, 0],
                       [4, 1],[4, 2],[4, 3],[4, 4],[3, 4],
                       [2, 4],[1, 4],[0, 4],[0, 3],[0, 2],
                       [0, 1]]

var backgrounds = [
            "baleine.svgz",
            "phoque.svgz",
            "ourspolaire.svgz",
            "morse.svgz",
            "elephant_mer.svgz",
            "epaulard.svgz",
            "narval.svgz"
        ]

var tuxIceBlockNumber = 0
var tuxIceBlockNumberGoal = 0
var tuxIsMoving = false;
var debuginttmp = 0
var clockPos
var placeFishToReachBool = false

var level = null;

var fishes = [
            "Benzfish.svgz",
            "blue-fish.svgz",
            "drunken_duck_cartoon_globefish_kugelfisch.svgz",
            "Fish02.svgz",
            "molumen_Codfish.svgz",
            "mystica_Aquarium_fish_-_Amphiprion_percula.svgz",
            "pepinux_Pez_dorado.svgz",
            "The_Whale-Fish.svgz",
            "Benzfish.svgz",
            "blue-fish.svgz",
            "drunken_duck_cartoon_globefish_kugelfisch.svgz",
            "Fish02.svgz"
        ]


var levels = [
            {
                "maxNumber": 1, /* Max number on each domino side */
                "minNumber": 1,
                "numberOfFish": 3
            },
            {
                "maxNumber": 2,
                "minNumber": 1,
                "numberOfFish": 4
            },
            {
                "maxNumber": 3,
                "minNumber": 1,
                "numberOfFish": 5
            },
            {
                "maxNumber": 4,
                "minNumber": 1,
                "numberOfFish": 5
            },
            {
                "maxNumber": 5,
                "minNumber": 2,
                "numberOfFish": 5
            },
            {
                "maxNumber": 6,
                "minNumber": 3,
                "numberOfFish": 5
            },
            {
                "maxNumber": 7,
                "minNumber": 4,
                "numberOfFish": 5
            },
            {
                "maxNumber": 8,
                "minNumber": 4,
                "numberOfFish": 5
            },
            {
                "maxNumber": 9,
                "minNumber": 5,
                "numberOfFish": 5
            },

        ]

var numberOfFish
var fishIndex = -1

var currentLevel = 0
var numberOfLevel = levels.length
var items

var url = "qrc:/gcompris/src/activities/reversecount/resource/"


function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}


function stop() {
    fishIndex = -1
}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.chooseDiceBar.value1 = 0
    items.chooseDiceBar.value2 = 0
    items.chooseDiceBar.valueMax = levels[currentLevel].maxNumber
    numberOfFish = levels[currentLevel].numberOfFish

    fishIndex = 0
    clockPos = 4
    setClock()
    tuxIceBlockNumber = 0
    items.tux.init()

    calculateNextPlaceFishToReach()
    placeFishToReach()
    items.backgroundImg.source = url + backgrounds[currentLevel % backgrounds.length]
}


function moveTux() {
    calculateTuxIceBlockNextPos()

    if (tuxIceBlockNumberGoal > fishIndex)
    {
        clockPos--
        setClock()
        if (clockPos === 0) {
            lost()
            initLevel()
            return
        }
    }
    else if (items.chooseDiceBar.value1 != 0 || items.chooseDiceBar.value2 != 0 ) {
        moveTuxToNextIceBlock()
    }
}


function moveTuxToNextIceBlock() {
    tuxIsMoving = false;
    tuxIceBlockNumber++
    tuxIceBlockNumber = tuxIceBlockNumber % iceBlocksLayout.length

    if (tuxIceBlockNumber >= 0 && tuxIceBlockNumber <= 4)
        items.tux.rotation = -90
    else if (tuxIceBlockNumber >= 5 && tuxIceBlockNumber <= 8)
        items.tux.rotation = 0
    else if (tuxIceBlockNumber >= 9 && tuxIceBlockNumber <= 12)
        items.tux.rotation = 90
    else if (tuxIceBlockNumber >= 13 && tuxIceBlockNumber <= 15)
        items.tux.rotation = 180

    moveTuxToIceBlock()

    var fishPos = fishIndex % iceBlocksLayout.length
    //if tux reaches its position + dice number
    if (tuxIceBlockNumber == fishPos) {
        tuxIsMoving = false;

        // if last fish reached
        if (--numberOfFish == 0) {
            won()
            items.fishToReach.showParticles()
            clockPos++
            setClock()
            return
        }

        calculateNextPlaceFishToReach()
        placeFishToReachBool = true
        return
    }

    //if tux reaches its position + dice number before reaching the fish, calculation was wrong
    if (tuxIceBlockNumber == tuxIceBlockNumberGoal) {
        clockPos--
        setClock()
        if (clockPos === 0) {
            lost()
            initLevel()
            return
        }
        tuxIsMoving = false;
        return
    }
    tuxIsMoving = true
}


function moveTuxToIceBlock() {
    items.tux.x = iceBlocksLayout[tuxIceBlockNumber % iceBlocksLayout.length][0] *
            items.background.width / 5 +
            (items.background.width / 5 - items.tux.width) / 2
    items.tux.y = iceBlocksLayout[tuxIceBlockNumber % iceBlocksLayout.length][1] *
            (items.background.height - items.background.height/5) / 5 +
            (items.background.height / 5 - items.tux.height) / 2
}



function tuxRunningChanged() {

    if (tuxIsMoving) {
        moveTuxToNextIceBlock()
    } else {
        if (placeFishToReachBool == true) {
            placeFishToReach(fishIndex)
            placeFishToReachBool = false
        }
    }
}


function calculateTuxIceBlockNextPos() {
    tuxIceBlockNumberGoal = tuxIceBlockNumber +
            items.chooseDiceBar.value1 + items.chooseDiceBar.value2
    // Increase Tux's speed depending on the number of blocks to move
    items.tux.duration = 1000 -
            (items.chooseDiceBar.value1 + items.chooseDiceBar.value2) * 40
}

var previousFishIndex = 0
function calculateNextPlaceFishToReach() {
    var newFishIndex
    do {
        newFishIndex = Math.floor(Math.random() *
                                  (levels[currentLevel].maxNumber * 2 -
                                   levels[currentLevel].minNumber + 1)) +
                levels[currentLevel].minNumber
    } while((previousFishIndex === newFishIndex) || (newFishIndex >= iceBlocksLayout.length))
    previousFishIndex = newFishIndex

    fishIndex = tuxIceBlockNumber + newFishIndex
}

function placeFishToReach() {
    items.fishToReach.source = url + fishes[fishIndex % fishes.length]
    items.fishToReach.x = iceBlocksLayout[fishIndex % iceBlocksLayout.length][0] *
            items.background.width / 5 +
            (items.background.width / 5 - items.tux.width) / 2
    items.fishToReach.y = iceBlocksLayout[fishIndex % iceBlocksLayout.length][1] *
            (items.background.height - items.background.height/5) / 5 +
            (items.background.height / 5 - items.tux.height) / 2
}



function setClock() {
    items.clock.source = url + "flower" + clockPos + ".svgz"
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

function lost() {
    items.bonus.bad("flower")
}

function won() {
    items.bonus.good("flower")
}

