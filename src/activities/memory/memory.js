/* gcompris - memory.js
 *
 * SPDX-FileCopyrightText: 2014 JB BUTET
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/memory/resource/"

var items
var numberOfLevel
var nbOfPair
var cardLeft
var cardList

function start(items_) {

    items = items_

    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)

    initLevel()
}

function stop() {
}

function initLevel() {
    items.containerModel.clear()
    items.playQueue = []
    items.tuxTurn = false
    items.player2Turn = false
    items.selectionCount = 0
    items.blockClicks = false

    // compute the number of cards
    var columns = items.levels[items.currentLevel].columns
    var rows = items.levels[items.currentLevel].rows
    var images = items.levels[items.currentLevel].images
    var sounds = items.levels[items.currentLevel].sounds
    var texts = items.levels[items.currentLevel].texts
    var repeaterModels = items.levels[items.currentLevel].repeaterModels
    items.columns = columns
    items.rows = rows
    nbOfPair = rows * columns / 2
    cardLeft = nbOfPair * 2

    // Check the provided dataset has enough data
    var maxData = Math.max(
                images ? images.length : 0,
                sounds ? sounds.length : 0,
                texts ? texts.length : 0,
                repeaterModels ? repeaterModels.length : 0)

    if(rows * columns > maxData * 2) {
        console.log("ERROR: Memory dataset does not have enough data pairs at level ",
                    items.currentLevel + 1)
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
                repeaterModel: repeaterModels ? repeaterModels[shuffleIds[ix]][j] : "",
                matchCode: ix,
                back: url + "backcard.svg",
                emptyCard: url + "emptycard.svg"
            } )
        }
    }

    cardList = Core.shuffle(cardList)

    // fill the model
    for(i = 0;  i < cardList.length; ++i) {
        items.containerModel.append( { pairData_: cardList[i] } )
    }

    if(items.withTux || items.playerCount === 2) {
        items.player2Score.endTurn();
        items.player1Score.beginTurn();
    }
    else {
        items.player1Score.endTurn();
    }

    items.player1Score.playerScore = 0
    items.player2Score.playerScore = 0
}

// Return a pair of cards that have already been shown
function getShownPair() {
    for(var i = 0;  i < nbOfPair * 2; ++i) {
        var cardItem1 = items.grid.getItemAtIndex(i)
        for(var j = 0;  j < nbOfPair * 2; ++j) {
            var cardItem2 = items.grid.getItemAtIndex(j)
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

// Calc randomly if Tux is a good player
// Return true if Tux should play correctly
function getRandomTuxIsGood() {
    return Math.random() * numberOfLevel < items.currentLevel
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
        if (items.grid.getItemAtIndex(i).isFound == false &&
            items.grid.getItemAtIndex(i).isBack)
            listCardNonReturned.push(items.grid.getItemAtIndex(i))
    }

    //select randomly a card in it
    return listCardNonReturned[Math.floor(Math.random() * listCardNonReturned.length)]
}

function reverseCardsIfNeeded() {
    if(items.playQueue.length >= 2) {
        items.selectionCount = 0
        var item1 = items.playQueue.shift()
        var item2 = items.playQueue.shift()
        var tuxTurn = item1.tuxTurn

        if (item1.card.pairData.matchCode ===
            item2.card.pairData.matchCode) {
            // the 2 cards are the same
            item1.card.isBack = false // stay faced
            item1.card.isFound = true // signal for hidden state
            item2.card.isBack = false
            item2.card.isFound = true
            cardLeft = cardLeft - 2

            if (tuxTurn) {
                items.player2Score.playerScore++
            }
            else if(items.playerCount === 2) {
                if(items.player2Turn) {
                    items.player2Score.playerScore++
                }
                else {
                    items.player1Score.playerScore++
                }
            }
            else {
                items.player1Score.playerScore++
            }

            if(cardLeft === 0) { // no more cards in the level
                if(items.withTux) {
                    if (items.player2Score.playerScore < items.player1Score.playerScore) {
                        youWon()
                    }
                    else {
                        youLoose()
                    }
                }
                else {
                    youWon()
                }
            } else {
                if(items.withTux && items.tuxTurn) {
                    tuxPlay()
                } else {
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/win.wav')
                }
            }


        } else {
            // pictures clicked are not the same
            item1.card.isBack = true
            item2.card.isBack = true

            if(items.withTux) {
                items.tuxTurn = !items.tuxTurn
                // The user lost, it's Tux turn
                if(items.tuxTurn) {
                    items.player2Score.beginTurn()
                    items.player1Score.endTurn()
                    tuxPlay()
                }
                else {
                    items.player1Score.beginTurn()
                    items.player2Score.endTurn()
                }
            }

            if(items.playerCount === 2) {
                items.player2Turn = !items.player2Turn
                if(items.player2Turn) {
                    items.player2Score.beginTurn()
                    items.player1Score.endTurn()
                }
                else {
                    items.player1Score.beginTurn()
                    items.player2Score.endTurn()
                }
            }
        }
    }
}

function tuxPlay() {
    // choose a card
    chooseCard().selected()
}


function youWon() {
    items.blockClicks = true
    items.bonus.good("flower")
}

function youLoose() {
    items.blockClicks = true
    items.bonus.bad("flower")
}

function repeatCurrentLevel() {
    if (items.withTux) {
        initLevel()
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function dumpPlayQueue() {
    for(var i in items.playQueue)
        console.log(items.playQueue[i].card, items.playQueue[i].tuxTurn)
}

// Return true is we have enough to make a pair
function addPlayQueue(card) {
    items.playQueue.push({'card': card, 'tuxTurn': items.tuxTurn})
    return items.playQueue.length >= 2
}
