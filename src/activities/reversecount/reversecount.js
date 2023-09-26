/* GCompris - reversecount.js
 *
 * SPDX-FileCopyrightText: 2014 Emmanuel Charruau
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var iceBlocksLayout = [[0, 0],[1, 0],[2, 0],[3, 0],[4, 0],
                       [4, 1],[4, 2],[4, 3],[4, 4],[3, 4],
                       [2, 4],[1, 4],[0, 4],[0, 3],[0, 2],
                       [0, 1]]

var tuxIceBlockNumber = 0
var tuxIceBlockNumberGoal = 0
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

var numberOfLevel = 0
var items

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    fishIndex = -1
}

function initLevel() {
    items.tuxIsMoving = false
    items.tuxCanMove = true
    items.chooseDiceBar.value1 = 0
    items.chooseDiceBar.value2 = 0
    items.chooseDiceBar.valueMax = items.levels[items.currentLevel].maxNumber
    numberOfFish = items.levels[items.currentLevel].numberOfFish

    fishIndex = 0
    tuxIceBlockNumber = 0
    items.tux.init()

    calculateNextPlaceFishToReach()
    placeFishToReach()
    moveTuxToIceBlock()
    items.clockPosition = 4
}

function moveTux(numberOfMovesToDo) {
    calculateTuxIceBlockNextPos(numberOfMovesToDo)

    if(items.chooseDiceBar.value1 === 0 && items.chooseDiceBar.value2 === 0) {
        return
    }
    else if (tuxIceBlockNumberGoal != fishIndex) {
        items.clockPosition--
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/darken.wav")
        if (items.clockPosition === 0) {
            lost()
            return
        }
    }
    else {
        items.tuxCanMove = false
        moveTuxToNextIceBlock()
    }
}

function moveTuxToNextIceBlock() {
    items.tuxIsMoving = false
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
        items.tuxIsMoving = false;

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
        items.tuxIsMoving = false;
        return
    }
    items.tuxIsMoving = true
}

function moveTuxToIceBlock() {
    items.tux.x = iceBlocksLayout[tuxIceBlockNumber % iceBlocksLayout.length][0] *
            items.widthBase + (items.widthBase - items.tux.width) / 2
    items.tux.y = iceBlocksLayout[tuxIceBlockNumber % iceBlocksLayout.length][1] *
            items.heightBase + (items.heightBase - items.tux.height) / 2
}

function tuxRunningChanged() {
    if (items.tuxIsMoving) {
        moveTuxToNextIceBlock()
    } else {
        if (placeFishToReachBool == true) {
            placeFishToReach(fishIndex)
            placeFishToReachBool = false
        }
    }
}

function calculateTuxIceBlockNextPos(numberOfMovesToDo) {
    tuxIceBlockNumberGoal = (tuxIceBlockNumber + numberOfMovesToDo) % iceBlocksLayout.length
    // Increase Tux's speed depending on the number of blocks to move
    items.tux.duration = 1000 - numberOfMovesToDo * 40
}

var previousFishIndex = 0
function calculateNextPlaceFishToReach() {
    var index, newFishIndex
    do {
        index = Math.floor(Math.random() * (items.levels[items.currentLevel].values.length))
        newFishIndex = items.levels[items.currentLevel].values[index]
    } while(items.levels[items.currentLevel].values.length > 2 &&     /* Allow repetition for array size 2 */
        ((newFishIndex === previousFishIndex) || (newFishIndex >= iceBlocksLayout.length)))
    previousFishIndex = newFishIndex

    fishIndex = (tuxIceBlockNumber + newFishIndex) % iceBlocksLayout.length
}

function placeFishToReach() {
    // placeFishToReach can be called when the opacity is 0.
    // In this case, this does not trigger the onOpacityChanged of the fish Image (meaning the fish will not be displayed) so we directly set the opacity to 1.
    if(items.fishToReach.opacity == 0)
        items.fishToReach.opacity = 1
    else
        items.fishToReach.opacity = 0

    items.fishToReach.nextX = iceBlocksLayout[fishIndex % iceBlocksLayout.length][0] *
            items.widthBase + (items.widthBase - items.fishToReach.width) / 2
    items.fishToReach.nextY = iceBlocksLayout[fishIndex % iceBlocksLayout.length][1] *
            items.heightBase + (items.heightBase - items.fishToReach.height) / 2
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function lost() {
    items.bonus.bad("tux")
}

function won() {
    items.bonus.good("flower")
}
