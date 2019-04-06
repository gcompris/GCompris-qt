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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo

var iceBlocksLayout = [[0, 0],[1, 0],[2, 0],[3, 0],[4, 0],
                       [4, 1],[4, 2],[4, 3],[4, 4],[3, 4],
                       [2, 4],[1, 4],[0, 4],[0, 3],[0, 2],
                       [0, 1]]

var backgrounds = [
            "baleine.svg",
            "phoque.svg",
            "ourspolaire.svg",
            "morse.svg",
            "elephant_mer.svg",
            "epaulard.svg",
            "narval.svg"
        ]

var tuxIceBlockNumber = 0
var tuxIceBlockNumberGoal = 0
var tuxIsMoving = false;
var placeFishToReachBool = false

var level = null;

var fishes = [
            "Benzfish.svg",
            "blue-fish.svg",
            "drunken_duck_cartoon_globefish_kugelfisch.svg",
            "Fish02.svg",
            "molumen_Codfish.svg",
            "mystica_Aquarium_fish_-_Amphiprion_percula.svg",
            "pepinux_Pez_dorado.svg",
            "The_Whale-Fish.svg",
            "Benzfish.svg",
            "blue-fish.svg",
            "drunken_duck_cartoon_globefish_kugelfisch.svg",
            "Fish02.svg"
        ]

var numberOfFish
var fishIndex = -1

var currentLevel = 0
var numberOfLevel = 0
var items

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.levels.length
    initLevel()
}

function stop() {
    fishIndex = -1
}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.chooseDiceBar.value1 = 0
    items.chooseDiceBar.value2 = 0
    items.chooseDiceBar.valueMax = items.levels[currentLevel].maxNumber
    numberOfFish = items.levels[currentLevel].numberOfFish

    fishIndex = 0
    tuxIceBlockNumber = 0
    items.tux.init()

    calculateNextPlaceFishToReach()
    placeFishToReach()
    moveTuxToIceBlock()
    items.backgroundImg.source = items.resourceUrl + backgrounds[currentLevel % backgrounds.length]
    items.clockPosition = 4
}

function moveTux() {
    calculateTuxIceBlockNextPos()

    if (tuxIceBlockNumberGoal > fishIndex)
    {
        items.clockPosition--
        if (items.clockPosition === 0) {
            lost()
            return
        }
    }
    else if (items.chooseDiceBar.value1 != 0 || items.chooseDiceBar.value2 != 0 ) {
        moveTuxToNextIceBlock()
    }
}

function moveTuxToNextIceBlock() {
    tuxIsMoving = false
    tuxIceBlockNumber++
    tuxIceBlockNumber = tuxIceBlockNumber % iceBlocksLayout.length

    if (tuxIceBlockNumber > 0 && tuxIceBlockNumber <= 4)
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
            items.clockPosition++
            return
        }

        items.audioEffects.play('qrc:/gcompris/src/activities/gnumch-equality/resource/eat.wav')
        calculateNextPlaceFishToReach()
        placeFishToReachBool = true
        return
    }

    items.audioEffects.play(items.resourceUrl + 'icy_walk.wav')
    //if tux reaches its position + dice number before reaching the fish, calculation was wrong
    if (tuxIceBlockNumber == tuxIceBlockNumberGoal) {
        items.clockPosition--
        if (items.clockPosition === 0) {
            lost()
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
                                  (items.levels[currentLevel].maxNumber * 2 -
                                   items.levels[currentLevel].minNumber + 1)) +
                items.levels[currentLevel].minNumber
    } while((previousFishIndex === newFishIndex) || (newFishIndex >= iceBlocksLayout.length))
    previousFishIndex = newFishIndex

    fishIndex = tuxIceBlockNumber + newFishIndex
}

function placeFishToReach() {
    // placeFishToReach can be called when the opacity is 0.
    // In this case, this does not trigger the onOpacityChanged of the fish Image (meaning the fish will not be displayed) so we directly set the opacity to 1.
    if(items.fishToReach.opacity == 0)
        items.fishToReach.opacity = 1
    else
        items.fishToReach.opacity = 0

    items.fishToReach.nextSource = items.resourceUrl + fishes[fishIndex % fishes.length]
    items.fishToReach.nextX = iceBlocksLayout[fishIndex % iceBlocksLayout.length][0] *
            items.background.width / 5 +
            (items.background.width / 5 - items.tux.width) / 2
    items.fishToReach.nextY = iceBlocksLayout[fishIndex % iceBlocksLayout.length][1] *
            (items.background.height - items.background.height/5) / 5 +
            (items.background.height / 5 - items.tux.height) / 2
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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
    items.bonus.bad("tux")
}

function won() {
    items.bonus.good("flower")
}
