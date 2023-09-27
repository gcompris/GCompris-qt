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

var url = "qrc:/gcompris/src/activities/hanoi_real/resource/"

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
var nbMaxItemsByTower

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
        nbMaxItemsByTower = 5;
        break;
    case 1:
        nbTowersLessExpectedAndResultOnes = 4;
        nbMaxItemsByTower = 5;
        break;
    case 2:
        nbTowersLessExpectedAndResultOnes = 5;
        nbMaxItemsByTower = 6;
        break;
    case 3:
        nbTowersLessExpectedAndResultOnes = 6;
        nbMaxItemsByTower = 7;
        break;
    case 4:
        nbTowersLessExpectedAndResultOnes = 6;
        nbMaxItemsByTower = 8;
        break;
    case 5:
        nbTowersLessExpectedAndResultOnes = 5;
        nbMaxItemsByTower = 9;
    }
}

function initLevel() {

    items.hasWon = false

    if(activityMode == "real") {
        items.numberOfDisc = items.currentLevel + 3
        items.discRepeater.model = items.numberOfDisc
        items.towerModel.model = 3
    }
    else {
        initSpecificInfoForSimplified();
        items.towerModel.model = nbTowersLessExpectedAndResultOnes + 2

        items.numberOfDisc = nbTowersLessExpectedAndResultOnes * (nbMaxItemsByTower-1) + nbMaxItemsByTower
        items.discRepeater.model = items.numberOfDisc
    }

    placeDiscsAtOrigin()

    if(activityMode != "real") {
        for(var i = 0 ; i < (items.numberOfDisc-nbMaxItemsByTower); ++i) {
            var index = Math.floor(Math.random() * symbols.length);
            items.discRepeater.itemAt(i).text = symbols[index];
            items.discRepeater.itemAt(i).baseColor = colors[index];
        }
        // Fill the text discs avoiding duplicates
        var currentAnswerId = items.numberOfDisc-nbMaxItemsByTower;
        var goodAnswerIndices = [];
        do {
            var id = Math.floor(Math.random() * (items.numberOfDisc-nbMaxItemsByTower));
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
    setDiscY(disc, towerImage);
}

function setDiscY(disc, towerImage)
{
    //  -(towerImage.height * 0.12) because we need to remove the base of the tower
    // dependent of the image!
    disc.y = towerImage.y + towerImage.height - disc.position * disc.height - (towerImage.height * 0.12)
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
        for(var i = 0 ; i < (items.numberOfDisc-nbMaxItemsByTower); ++i) {
            placeDisc(items.discRepeater.itemAt(i), items.towerModel.itemAt(i%nbTowersLessExpectedAndResultOnes))
        }
        // Fill last tower
        for(var i = items.numberOfDisc-nbMaxItemsByTower ; i < items.numberOfDisc ; ++i) {
            placeDisc(items.discRepeater.itemAt(i), items.towerModel.itemAt(nbTowersLessExpectedAndResultOnes+1))
        }
    }
}

function discReleased(index)
{
    var disc = items.discRepeater.itemAt(index)
    var isCorrect = false;

    if(activityMode == "real") {
        for(var i = 0 ; i < items.towerModel.model ; ++ i) {
            var towerItem = items.towerModel.itemAt(i);
            if(checkIfDiscOnTowerImage(disc, towerItem) &&
               getNumberOfDiscOnTower(towerItem) < items.numberOfDisc &&
               getHigherfDiscOnTower(towerItem) <= index) {
                placeDisc(disc, towerItem)
                isCorrect = true
                break;
            }
        }
    }
    else {
        for(var i = 0 ; i < items.towerModel.model ; ++ i) {
            var towerItem = items.towerModel.itemAt(i);
            if(checkIfDiscOnTowerImage(disc, towerItem) &&
               getNumberOfDiscOnTower(towerItem) < nbMaxItemsByTower) {
                placeDisc(disc, towerItem)
                isCorrect = true
                break;
            }
        }
    }

    if(!isCorrect) {
        // Cancel the drop
        setDiscY(disc, disc.towerImage)
    }

    disableNonDraggablediscs()
    checkSolved()
}

function sceneSizeChanged()
{
    if(!items)
        return

    for(var i = 0 ; i < items.numberOfDisc ; ++i) {
        var disc = items.discRepeater.itemAt(i)
        if(!disc || !disc.towerImage)
            continue
        setDiscY(disc, disc.towerImage)
    }

    disableNonDraggablediscs()
}

function disableNonDraggablediscs()
{
    if(activityMode == "real") {
        // Only the highest (index) one is enabled
        for(var i = 0 ; i < items.numberOfDisc ; ++i) {
            var disc = items.discRepeater.itemAt(i)
            if(disc)
                disc.mouseEnabled = (getHigherfDiscOnTower(disc.towerImage) <= i)
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

            disc.mouseEnabled = false
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
            items.discRepeater.itemAt(highestOnes[i].id).mouseEnabled = true
        }
    }
}

function checkIfDiscOnTowerImage(disc, towerImage)
{
    var discPosition = items.background.mapFromItem(disc, 0, 0)
    var towerPosition = items.background.mapFromItem(towerImage, 0, 0)
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

function getDiscWidth(index)
{
    if(activityMode == "real") {
        if( 0 === index ) return items.towerModel.itemAt(0).width * 1.6
        else if ( 1 === index ) return items.towerModel.itemAt(0).width * 1.3
        else if ( 2 === index ) return items.towerModel.itemAt(0).width * 1
        else if ( 3 === index ) return items.towerModel.itemAt(0).width * 0.7
        else return items.towerModel.itemAt(0).width * 0.5
    }
    else {
        return items.towerModel.itemAt(0).width
    }
}
