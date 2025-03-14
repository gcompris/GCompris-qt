/* GCompris - hanoi_real.js
 *
 * Copyright (C) 2015 <Amit Tomar>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Amit Tomar <a.tomar@outlook.com> (Qt Quick hanoi tower port)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick hanoi simplified port)
 *   Timothée Giet <animtim@gmail.com> (Graphics refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var activityMode

// Specific data for simplified mode
var symbols = [
    "!", "/", "<",
    ">", "&", "~",
    "#", "{", "%",
    "|", "?", "}",
    "=", "+", "*"
]

var colors = [
    "#e41c1c", // red 0
    "#79e41c", // green 65
    "#1c8fe4", // blue 146
    "#e4bb1c", // yellow 34
    "#e41c92", // magenta 230
    "#1dc0e3", // cyan 135
    "#e3711d", // orange 18
    "#a91de3", // purple 200
    "#e44b1c", // red2 10
    "#1ce463", // green2 100
    "#1c4ce4", // blue2 160
    "#e4e01c", // yellow2 42
    "#f20ee5", // magenta2 215
    "#1de3da", // cyan2 126
    "#e4921c"  // orange2 25
]

var nbTowersLessExpectedAndResultOnes

function start(items_, activityMode_) {
    items = items_
    activityMode = activityMode_
    numberOfLevel = (activityMode == "real") ? 3 : 6
    items.currentLevel = Core.getInitialLevel(numberOfLevel)

    initLevel()
}

function stop() {
}

function initSpecificInfoForSimplified() {
    Core.shuffle(symbols);
    switch(items.currentLevel) {
    case 0:
        nbTowersLessExpectedAndResultOnes = 3;
        items.maxDiskPerTower = 5;
        break;
    case 1:
        nbTowersLessExpectedAndResultOnes = 4;
        items.maxDiskPerTower = 5;
        break;
    case 2:
        nbTowersLessExpectedAndResultOnes = 5;
        items.maxDiskPerTower = 6;
        break;
    case 3:
        nbTowersLessExpectedAndResultOnes = 6;
        items.maxDiskPerTower = 7;
        break;
    case 4:
        nbTowersLessExpectedAndResultOnes = 6;
        items.maxDiskPerTower = 8;
        break;
    case 5:
        nbTowersLessExpectedAndResultOnes = 5;
        items.maxDiskPerTower = 9;
    }
}

function initLevel() {

    items.hasWon = false
    items.numberOfTower = 0
    items.numberOfDisc = 0

    if(activityMode == "real") {
        items.numberOfTower = 3
        items.numberOfDisc = items.currentLevel + 3
    }
    else {
        initSpecificInfoForSimplified();
        items.numberOfTower = nbTowersLessExpectedAndResultOnes + 2
        items.numberOfDisc = nbTowersLessExpectedAndResultOnes * (items.maxDiskPerTower-1) + items.maxDiskPerTower
    }

    placeDiscsAtOrigin()

    if(activityMode != "real") {
        for(var i = 0 ; i < (items.numberOfDisc-items.maxDiskPerTower); ++i) {
            var index = Math.floor(Math.random() * symbols.length);
            items.discRepeater.itemAt(i).text = symbols[index];
            items.discRepeater.itemAt(i).baseColor = colors[index];
        }
        // Fill the text discs avoiding duplicates
        var currentAnswerId = items.numberOfDisc-items.maxDiskPerTower;
        var goodAnswerIndices = [];
        do {
            var id = Math.floor(Math.random() * (items.numberOfDisc-items.maxDiskPerTower));
            if(goodAnswerIndices.indexOf(id) == -1) {
                items.discRepeater.itemAt(currentAnswerId).text = items.discRepeater.itemAt(id).text;
                items.discRepeater.itemAt(currentAnswerId).baseColor = items.discRepeater.itemAt(id).baseColor;
                goodAnswerIndices.push(id);
                currentAnswerId ++;
            }
        }
        while(currentAnswerId < items.numberOfDisc);
    }

    disableNonDraggablediscs()
}

function nextLevel()
{
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel()
{
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function placeDisc(disc, towerImage)
{
    disc.towerImage = towerImage
    disc.position = getNumberOfDiscOnTower(towerImage)
    disc.parent = towerImage
}

function placeDiscsAtOrigin() {
    // Reset the model to get the initial animation
    if(items.discRepeater.model === items.numberOfDisc)
        items.discRepeater.model = 0
    items.discRepeater.model = items.numberOfDisc

    if(activityMode == "real") {
        for(var i = 0 ; i < items.numberOfDisc ; ++i) {
            placeDisc(items.discRepeater.itemAt(i), items.towerModel.itemAt(0))
            items.discRepeater.itemAt(i).baseColor = colors[i];
        }
    }
    else {
        // First fill the first towers
        for(var i = 0 ; i < (items.numberOfDisc-items.maxDiskPerTower); ++i) {
            placeDisc(items.discRepeater.itemAt(i), items.towerModel.itemAt(i%nbTowersLessExpectedAndResultOnes))
        }
        // Fill last tower
        for(var i = items.numberOfDisc-items.maxDiskPerTower ; i < items.numberOfDisc ; ++i) {
            placeDisc(items.discRepeater.itemAt(i), items.towerModel.itemAt(nbTowersLessExpectedAndResultOnes+1))
        }
    }
}

function discReleased(index)
{
    var disc = items.discRepeater.itemAt(index)

    if(activityMode == "real") {
        for(var i = 0 ; i < items.towerModel.model ; ++ i) {
            var towerItem = items.towerModel.itemAt(i);
            if(checkIfDiscOnTowerImage(disc, towerItem) &&
               getNumberOfDiscOnTower(towerItem) < items.numberOfDisc &&
               getHigherfDiscOnTower(towerItem) <= index) {
                placeDisc(disc, towerItem)
                break;
            }
        }
    }
    else {
        for(var i = 0 ; i < items.towerModel.model ; ++ i) {
            var towerItem = items.towerModel.itemAt(i);
            if(checkIfDiscOnTowerImage(disc, towerItem) &&
               getNumberOfDiscOnTower(towerItem) < items.maxDiskPerTower) {
                placeDisc(disc, towerItem)
                break;
            }
        }
    }

    disc.restoreAnchors()

    disableNonDraggablediscs()
    checkSolved()
}

function disableNonDraggablediscs()
{
    if(activityMode == "real") {
        // Only the highest (index) one is enabled
        for(var i = 0 ; i < items.numberOfDisc ; ++i) {
            var disc = items.discRepeater.itemAt(i)
            if(disc)
                disc.enabled = (getHigherfDiscOnTower(disc.towerImage) <= i)
        }
    }
    else {
        // In simplified, all the last tower discs are disabled
        // We disable all except the highest (in position) ones of each tower
        var highestOnes = [];
        for(var i = 0 ; i < items.numberOfDisc ; ++i) {
            var disc = items.discRepeater.itemAt(i)
            if(!disc)
                continue

            disc.enabled = false
            if(disc.towerImage == items.towerModel.itemAt(items.towerModel.model-1)) {
                continue;
            }
            else if(highestOnes[disc.towerImage] == undefined) {
                highestOnes[disc.towerImage] = {"pos": disc.position, "id": i}
            }
            else if(highestOnes[disc.towerImage].pos < disc.position) {
                highestOnes[disc.towerImage].pos = disc.position
                highestOnes[disc.towerImage].id = i
            }
        }

        for(var i in highestOnes) {
            items.discRepeater.itemAt(highestOnes[i].id).enabled = true
        }
    }
}

function checkIfDiscOnTowerImage(disc, towerImage)
{
    var discPosition = items.activityBackground.mapFromItem(disc, 0, 0)
    var towerPosition = items.activityBackground.mapFromItem(towerImage, 0, 0)
    return ((discPosition.x + disc.width / 2) > towerPosition.x &&
            (discPosition.x + disc.width / 2) < towerPosition.x + towerImage.width)
}

function getHigherfDiscOnTower(towerImage) {
    var higher = 0
    for(var i = 0 ; i < items.numberOfDisc ; ++i)
    {
        if(items.discRepeater.itemAt(i) && items.discRepeater.itemAt(i).towerImage === towerImage)
            higher = i
    }
    return higher
}

function getNumberOfDiscOnTower(towerImage) {
    var count = 0
    for(var i = 0 ; i < items.numberOfDisc ; ++i)
    {
        if(items.discRepeater.itemAt(i).towerImage === towerImage)
            count++
    }
    return count
}

function checkSolved() {
    if(activityMode == "real") {
        if(getNumberOfDiscOnTower(items.towerModel.itemAt(items.towerModel.model-1)) === items.numberOfDisc) {
            items.hasWon = true
            items.bonus.good("flower")
        }
    }
    else {
        // Recreate both last towers text
        var expectedTower = [];
        var actualTower = [];
        for(var i = 0 ; i < items.numberOfDisc ; ++i) {
            var disc = items.discRepeater.itemAt(i);
            if(disc.towerImage == items.towerModel.itemAt(items.towerModel.model-1)) {
                actualTower[disc.position] = disc.text
}
            else if(disc.towerImage == items.towerModel.itemAt(items.towerModel.model-2)) {
                expectedTower[disc.position] = disc.text
            }
        }

        // Don't check if not the same length
        var hasWon = (expectedTower.length == actualTower.length)
        for (var i = 0; hasWon && i < actualTower.length; ++i) {
            if (expectedTower[i] !== actualTower[i]) hasWon = false
        }
        if(hasWon) {
            items.hasWon = true
            items.bonus.good("flower")
        }
    }
}
