/* GCompris - reversecount.js
 *
 * Copyright (C) 2014 Emmanuel Charruau
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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

var tuxIceBlockNumber = 0
var tuxIceBlockNumberGoal = 0
var tuxIsMoving = false;
var debugtmp = ""
var debuginttmp = 0
var clockPos
var placeFishToReachBool = false
var onWithChangingBool = false
var onHeightChangingBool = false

var level = null;


var dices = [
            "dice0.svgz",
            "dice1.svgz",
            "dice2.svgz",
            "dice3.svgz",
            "dice4.svgz",
            "dice5.svgz",
            "dice6.svgz",
            "dice7.svgz",
            "dice8.svgz",
            "dice9.svgz"
        ]



var fishes = [
            "Anonymous_bofish.svgz",
            "Benzfish.svgz",
            "blue-fish.svgz",
            "drunken_duck_cartoon_globefish_kugelfisch.svgz",
            "Fish02.svgz",
            "fish-1.svgz",
            "fish-carib.svgz",
            "Gloss_Fish_1.svgz",
            "Gloss_Fish_2.svgz",
            "molumen_Codfish.svgz",
            "mystica_Aquarium_fish_-_Amphiprion_percula.svgz",
            "mystica_Aquarium_fish_-_Cirrhilabrus_jordani.svgz",
            "mystica_Aquarium_fish_-_Xiphophorus_maculatus.svgz",
            "pepinux_Pez_dorado.svgz",
            "The_Whale-Fish.svgz",
            "Anonymous_bofish.svgz",
            "Benzfish.svgz",
            "blue-fish.svgz",
            "drunken_duck_cartoon_globefish_kugelfisch.svgz",
            "Fish02.svgz",
            "fish-1.svgz",
            "fish-carib.svgz",
        ]

var clocks = [
            "clock1.png",  //not very elegant but it allows to have an index corresponding to the clock level
            "clock1.png",
            "clock2.png",
            "clock3.png",
            "clock4.png",
            "clock5.png",
            "clock6.png",
            "clock7.png",
            "clock8.png",
            "clock9.png",
            "clock10.png"
        ]

var levels = [
            {
                "sublevels" : 6,
                "questions" : [
                    2,
                    3
                ]
            },
            {
                "sublevels" : 6,
                "questions" : [
                    2,
                    3,
                    6,
                    8,
                    12,
                    16,
                    22
                ]
            },
            {
                "sublevels" : 6,
                "questions" : [
                    7,
                    10,
                    15,
                    21,
                    22,
                    31
                ]
            },
            {
                "sublevels" : "6",
                "questions" : [
                    10,
                    21,
                    25,
                    28,
                    34,
                    40
                ]
            },
            {
                "sublevels" : 6,
                "questions" : [
                    13,
                    19,
                    31,
                    42,
                    51,
                    56
                ]
            }

        ]

var fishesPos = new Array();
var fishPos = 0

var currentDice1Index = 0
var currentDice2Index = 0
var fishIndex = 0

var currentLevel = 0
var currentSubLevel = 0
var numberOfLevel = 4
var items

var url = "qrc:/gcompris/src/activities/reversecount/resource/"


function start(items_) {
    items = items_
    currentLevel = 0
    currentSubLevel = 0
    initLevel()
}


function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.tux.rotation = -90

    currentDice1Index = 0
    currentDice2Index = 0

    level = levels[currentLevel];
    fishesPos = level.questions


    items.chooseDiceBar.currentDice1ImageName = dices[currentDice1Index]
    items.chooseDiceBar.currentDice2ImageName = dices[currentDice2Index]

    fishIndex = 0
    clockPos = 4
    placeFishToReach(fishesPos[0])
    setClock()
    tuxIceBlockNumber = 0
    moveTuxToIceBlock()
}


function moveTux() {
    calculateTuxIceBlockNextPos()

    if (tuxIceBlockNumberGoal > fishesPos[fishIndex])
    {
        clockPos--
        setClock()
        if (clockPos == 1) {
            lost()
            initLevel()
            return
        }
    }
    else {
        if (currentDice1Index != 0 || currentDice2Index != 0 ) {
            moveTuxToNextIceBlock()
        }
    }
}


function moveTuxToNextIceBlock() {
    tuxIsMoving = false;
    tuxIceBlockNumber++
    tuxIceBlockNumber = tuxIceBlockNumber % 16

    if (tuxIceBlockNumber >= 0 && tuxIceBlockNumber <= 4)
        items.tux.rotation = -90
    else if (tuxIceBlockNumber >= 5 && tuxIceBlockNumber <= 8)
        items.tux.rotation = 0
    else if (tuxIceBlockNumber >= 9 && tuxIceBlockNumber <= 12)
        items.tux.rotation = 90
    else if (tuxIceBlockNumber >= 13 && tuxIceBlockNumber <= 15)
        items.tux.rotation = 180

    moveTuxToIceBlock()

    fishPos = fishesPos[fishIndex] % 16
    //if tux reaches its position + dice number
    if (tuxIceBlockNumber == fishPos) {
        tuxIsMoving = false;

        //if last fish reached
        if (fishIndex + 1 === level.questions.length) {
            won()
            items.tux.showParticles()
            clockPos++
            setClock()
            return
        }

        fishIndex++
        placeFishToReachBool = true
        return
    }

    //if tux reaches its position + dice number before reaching the fish, calculation was wrong
    if (tuxIceBlockNumber == tuxIceBlockNumberGoal) {
        clockPos--
        setClock()
        if (clockPos == 1) {
            lost()
            initLevel()
            return
        }
        tuxIsMoving = false;
        return
    }
}


function moveTuxToIceBlock() {
    items.tux.x = (iceBlocksLayout[tuxIceBlockNumber][0] * items.background.width / 5).toFixed()
    items.tux.y = iceBlocksLayout[tuxIceBlockNumber][1] * (items.background.height - items.background.height/5) / 5
    tuxIsMoving = true;
}



function tuxRunningChanged() {

    if (onWithChangingBool && tuxIsMoving) {
        tuxIsMoving = false
        return
    }

    if (onWithChangingBool && !tuxIsMoving) {
        onWithChangingBool = false
        onHeightChangingBool = false
        return
    }

    if (onHeightChangingBool && tuxIsMoving) {
        tuxIsMoving = false
        return
    }

    if (onHeightChangingBool && !tuxIsMoving) {
        onWithChangingBool = false
        onHeightChangingBool = false
        return
    }

    if (tuxIsMoving) {
        if (currentDice1Index != 0 || currentDice2Index != 0)
            moveTuxToNextIceBlock()
        return;
    }

    if (!tuxIsMoving) {

        if (placeFishToReachBool == true) {
            placeFishToReach(fishesPos[fishIndex])
            placeFishToReachBool = false
        }
    }
}


function calculateTuxIceBlockNextPos() {
    tuxIceBlockNumberGoal = tuxIceBlockNumber + currentDice1Index + currentDice2Index
    tuxIceBlockNumberGoal = tuxIceBlockNumberGoal % 16
}


function placeFishToReach(fishIndex) {
   fishIndex = fishIndex % 16

   items.fishToReach.source = url + fishes[fishIndex]
   items.fishToReach.x = iceBlocksLayout[fishIndex][0] * items.background.width / 5
   items.fishToReach.y = iceBlocksLayout[fishIndex][1] * (items.background.height - items.background.height/5) / 5
}



function setClock() {
    debugtmp = url + clocks[clockPos]
    items.clock.source = url + clocks[clockPos]
}


function nextDice1() {
    currentDice1Index++;
    if (currentDice1Index > 8)
        currentDice1Index = 0;
    items.chooseDiceBar.currentDice1ImageName = dices[currentDice1Index]
}

function previousDice1() {
    currentDice1Index--;
    if (currentDice1Index < 0)
        currentDice1Index = 8;
    items.chooseDiceBar.currentDice1ImageName = dices[currentDice1Index]
}


function nextDice2() {
    currentDice2Index++;
    if (currentDice2Index > 8)
        currentDice2Index = 0;
    items.chooseDiceBar.currentDice2ImageName = dices[currentDice2Index]
}

function previousDice2() {
    currentDice2Index--;
    if (currentDice2Index < 0)
        currentDice2Index = 8;
    items.chooseDiceBar.currentDice2ImageName = dices[currentDice2Index]
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

