/* gcompris - memory.js
 *
 * Copyright (C) 2014 JB BUTET
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/memory/resource/"

var items
var currentLevel
var numberOfLevel
var nbOfPair
var firstPictureClicked
var lastPics
var cardLeft
var cardList

function start(items_) {

    items = items_

    currentLevel = 0
    numberOfLevel = items.dataset.length

    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.containerModel.clear()
    lastPics = []
    firstPictureClicked = null
    items.tuxTurn = false

    // compute the number of cards
    var columns = items.dataset[currentLevel].columns
    var rows = items.dataset[currentLevel].rows
    var images = items.dataset[currentLevel].images
    var sounds = items.dataset[currentLevel].sounds
    var texts = items.dataset[currentLevel].texts
    items.columns = columns
    items.rows = rows
    nbOfPair = rows * columns / 2
    cardLeft = nbOfPair * 2

    // Check the provided dataset has enough data
    var maxData = Math.max(
                images ? images.length : 0,
                sounds ? sounds.length : 0,
                texts ? texts.length : 0)

    if(rows * columns > maxData) {
        console.log("ERROR: Memory dataset does not have enough data pairs at level ",
                    currentLevel + 1)
        return
    }

    // Create a list of indexes for the shuffling
    // This way we can keep the 3 lists in sync
    var shuffleIds = []
    for(var i = 0;  i < maxData; ++i) {
        shuffleIds.push(i)
    }
    Core.shuffle(shuffleIds)

    // place randomly a level-defined number of pairs
    cardList = []
    for(var ix = 0;  ix < nbOfPair; ++ix) {
        // select a random item
        for(var j = 0; j < 2; ++j) {
            cardList.push( {
                image: images ? images[shuffleIds[ix]][j] : "",
                sound: sounds ? sounds[shuffleIds[ix]][j] : "",
                text: texts ? texts[shuffleIds[ix]][j] : "",
                matchCode: ix,
                back: url + "backcard.png",
                emptyCard: url + "emptycard.png"
            } )
        }
    }

    cardList = Core.shuffle(cardList)

    // fill the model
    for(i = 0;  i < cardList.length; ++i) {
        items.containerModel.append( { pairData_: cardList[i] } )
    }

    items.tuxScore = 0
    items.playerScore = 0
}

// Return a pair of cards that have already been shown
function getShownPair() {

    for(var i = 0;  i < nbOfPair * 2; ++i) {
        var cardItem1 = items.cardRepeater.itemAt(i)
        for(var j = 0;  j < nbOfPair * 2; ++j) {
            var cardItem2 = items.cardRepeater.itemAt(j)
            if(i != j &&
                !cardItem1.isFound &&
                cardItem1.isShown &&
                !cardItem2.isFound &&
                cardItem2.isShown &&
                (cardItem1.pairData.matchCode ===
                 cardItem2.pairData.matchCode) ) {
                return [cardItem1, cardItem2]
            }
        }
    }
    return
}

// Calc randomly is Tux is a good player
// Return true if Tux should play correctly
function getRandomTuxIsGood() {
    return Math.random() * numberOfLevel < currentLevel
}

function chooseCard() {

    // Tux looks in the shown card to make his choice
    if(getRandomTuxIsGood()) {
        var shownPair = getShownPair()
        if(shownPair) {
            if(shownPair[0].isBack) {
                return shownPair[0]
            } else {
                return shownPair[1]
            }
        }
    }

    // If no pairs shown select a random card
    var listCardNonReturned = []
    for(var i = 0;  i < cardList.length; ++i) {
        if (items.cardRepeater.itemAt(i).isFound == false &&
            items.cardRepeater.itemAt(i).isBack)
            listCardNonReturned.push(items.cardRepeater.itemAt(i))
    }

    //select randomly a card in it
    return listCardNonReturned[Math.floor(Math.random() * listCardNonReturned.length)]
}

function reverseCards() {
    if(lastPics.length == 2) {
        lastPics[0].isBack = true
        lastPics[1].isBack = true
        lastPics = []
    }
}

function tuxPlay() {
    // return all previous cards
    reverseCards()

    // choose a card
    chooseCard().selected()
}

function cardClicked(cardItem) {
    if (!firstPictureClicked) { // at first click
        if (items.withTux && items.tuxTurn) {
            chooseCard().selected()
        }
        firstPictureClicked = cardItem
    } else if (firstPictureClicked.pairData.matchCode ===
               cardItem.pairData.matchCode) {
        // the 2 cards are the same
        firstPictureClicked.isBack = false // stay faced
        firstPictureClicked.isFound = true // signal for hidden state
        cardItem.isBack = false
        cardItem.isFound = true
        cardLeft = cardLeft - 2

        if (items.tuxTurn)
            items.tuxScore++
        else
            items.playerScore++


        firstPictureClicked = null

        if(cardLeft == 0) { // no more cards in the level
            if(items.withTux) {
                if (items.tuxScore < items.playerScore) {
                    youWon()
                } else {
                    youLoose()
                }
            } else {
                youWon()
            }
        } else if(items.withTux && items.tuxTurn) {
            tuxPlay()
        }

    } else {
        // pictures clicked are not the same
        if(items.withTux)
            items.tuxTurn = !items.tuxTurn

        // keep them to reverse them on next click
        lastPics = [firstPictureClicked, cardItem]
        firstPictureClicked = null

        // The user lost, it's Tux turn
        if (items.withTux && items.tuxTurn) {
            tuxPlay()
        }
    }
}

function youWon() {
    items.bonus.good("flower")
}

function youLoose(){
    items.bonus.bad("flower")
    if (items.withTux){
        initLevel()
    }
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


