.pragma library
.import QtQuick 2.0 as Quick

// The dataset
// each array item is nb of line then column in memory
nbOfPairLevelRelationArray = new Array([3,2],[4,2],[5,2],[4,3],
                                       [6,3],[5,4],[6,4],[7,4],
                                       [8,4])

// list of picture
imageList = new Array("01_cat.png","02_pig.png","03_bear.png",
                      "04_hippopotamus.png","05_penguin.png",
                      "06_cow.png", "07_sheep.png", "08_turtle.png",
                      "09_panda.png", "10_chicken.png", "11_redbird.png",
                      "12_wolf.png", "13_monkey.png", "14_fox.png",
                      "15_bluebirds.png", "16_elephant.png", "17_lion.png",
                      "18_gnu.png", "19_bluebaby.png", "20_greenbaby.png",
                      "21_frog.png")

var currentLevel = 0
var numberOfLevel = 9
var main
var background
var bar
var bonus
var grid
var containerModel
var cardRepeater
var nb_of_pair
var nbOfPairLevelRelationArray
var imageList
var line
var column
var firstPictureClicked
var lastPics = new Array
var cardLeft


function start(main_, background_, bar_, bonus_,
               containerModel_, cardRepeater_, grid_) {
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    containerModel = containerModel_
    cardRepeater = cardRepeater_
    grid = grid_
    currentLevel = 0

    initLevel()
}

function stop() {
}

function initLevel() {

    bar.level = currentLevel + 1
    containerModel.clear()
    firstPictureClicked = null

    // compute the number of cards
    line = nbOfPairLevelRelationArray[currentLevel][1]
    column = nbOfPairLevelRelationArray[currentLevel][0]
    grid.columns = column
    nb_of_pair = line * column / 2

    // place randomly a level-defined number of picture pair
    var cardList = new Array()
    for(var ix = 0;  ix < nb_of_pair; ++ix){
        // select  a picture randomly from 21 pictures
        if (cardList.length > 0) {
            var card = imageList[Math.floor((imageList.length) * Math.random())]
            // is card still in cardList?
            while (cardList.indexOf(card) >= 0) {
                var card = imageList[Math.floor((imageList.length) * Math.random())]
            }
            cardList[ix]= card
        }
        else {
            var card = imageList[Math.floor((imageList.length) * Math.random())] //first run
            cardList[ix]= card
        }

    }
    cardList = shuffle(cardList.concat(cardList))
    cardLeft = cardList.length

    // fill in with pictures
    for(var i = 0;  i < cardList.length; ++i) {
        containerModel.append({
                                  "back": "resource/backcard.png",
                                  "image": "resource/" + cardList[i],
                                  "width_": main.width * 0.7 / column,
                                  "height_": main.height * 0.6 / line,
                                  "matchCode_": cardList[i]
                              })
    }

}


function cardClicked(cardObject) {
    if (!firstPictureClicked) {
        firstPictureClicked = cardObject
        if(lastPics.length == 2) {
            lastPics[0].isBack = true
            lastPics[1].isBack = true
            lastPics = []
        }
    } else {
        // Check that the 2 pictures are the same
        console.log(firstPictureClicked.matchCode)
        console.log(cardObject.matchCode)
        if (firstPictureClicked.matchCode === cardObject.matchCode) {
            firstPictureClicked.isBack = false // stay faced
            firstPictureClicked.isFound = true // signal for hidden state
            cardObject.isBack = false
            cardObject.isFound = true
            cardLeft = cardLeft - 2
            if(cardLeft == 0) { // no more cards in the level
                youWon()
            }
        } else { // pictures clicked are not the same
            // keep them to reverse them on next click
            lastPics = [firstPictureClicked, cardObject]
        }
        firstPictureClicked = null
    }

}

function youWon() {
    bonus.good("flower")
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

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
