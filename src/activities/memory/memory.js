.pragma library
.import QtQuick 2.0 as Quick

// The dataset
// each array item is nb of line then column in memory
nbOfPairLevelRelationArray = new Array([3,2],[4,2],[5,2],[4,3],
                                       [6,3],[5,4],[6,4],[7,4],
                                       [8,4])

// list of picture


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
var displayWidthRatio
var displayHeightRatio
var displayX
var displayY
var type


function start(main_,type_, background_, bar_, bonus_,
               containerModel_, cardRepeater_, grid_,
               dataset_, displayWidthRatio_, displayHeightRatio_,
               displayX_, displayY_) {
    displayWidthRatio = displayWidthRatio_
    displayHeightRatio = displayHeightRatio_
    displayX = displayX_
    displayY = displayY_
    main = main_
    type = type_
    background = background_
    bar = bar_
    bonus = bonus_
    containerModel = containerModel_
    cardRepeater = cardRepeater_
    grid = grid_
    currentLevel = 0
    imageList = dataset_ //could be a sound list or a operation list
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
            if (type=="math"){
                var card = imageList[Math.floor((imageList.length/10*(currentLevel+1)) * Math.random())] //Difficulty is define here. By construction of dataset

            }
            else {
                var card = imageList[Math.floor((imageList.length) * Math.random())]
                // is card still in cardList?
                while (cardList.indexOf(card) >= 0) {
                    var card = imageList[Math.floor((imageList.length) * Math.random())]
            }
            }
            cardList[ix]= card
        }
        else {
            if (type=="math"){

                var card = imageList[Math.floor((imageList.length/10*(currentLevel+1)) * Math.random())] //Difficulty is define here. By construciton of dataset
                cardList[ix]= card

            }
            else {
                var card = imageList[Math.floor((imageList.length) * Math.random())] //first run
                cardList[ix]= card
            }
        }

    }
    if (type=="math"){

        var cardListValue = new Array()
        for(var ix = 0;  ix < nb_of_pair; ++ix){
            var valeur = eval(cardList[ix].toString())
            cardListValue[ix] = valeur
        }

        cardList = shuffle(cardList.concat(cardListValue))
    }
    else {
        cardList = shuffle(cardList.concat(cardList))
    }


    cardLeft = cardList.length

    // fill in with pictures
    for(var i = 0;  i < cardList.length; ++i) {
        if (type == "picture"){
        containerModel.append({"back": "resource/backcard.png",
                               "image": "resource/" + cardList[i],
                               "width_": main.width * displayWidthRatio / column,
                               "height_": main.height * displayHeightRatio / line,
                               "matchCode_": cardList[i],
                               "audioFile_": "",
                               "text_": ""})
        }
        else if (type == "sound") {
            containerModel.append({"back": "qrc:/gcompris/src/activities/memory-sound/resource/Tux_mute.png",
                                   "image": "qrc:/gcompris/src/activities/memory-sound/resource/Tux_play.png", //it's a sound memory
                                   "width_": main.width * displayWidthRatio / column,
                                   "height_": main.height * displayHeightRatio / line,
                                   "matchCode_": cardList[i],
                                   "audioFile_": cardList[i],
                                   "text_": ""})
        }
        else if (type == "math") {
            containerModel.append({"back": "qrc:/gcompris/src/activities/memory/resource/backcard.png",
                                   "image": "qrc:/gcompris/src/activities/memory/resource/emptycard.png",
                                   "width_": main.width * displayWidthRatio / column,
                                   "height_": main.height * displayHeightRatio / line,
                                   "matchCode_": eval(cardList[i].toString()),
                                   "audioFile_": "",
                                   "text_": cardList[i].toString().replace("*","x").replace("/",String.fromCharCode(247))})
        }
    }

}

function isFormule(text){
    return ((text.indexOf("+")>0) || (text.indexOf("-")>0) || (text.indexOf("x")>0) || (text.indexOf(String.fromCharCode(247))>0))
}

function isAnswer(text){
    return !isFormule(text)
}

function cardClicked(cardObject) {
    if (!firstPictureClicked) {//at first click
        firstPictureClicked = cardObject
        if(lastPics.length == 2) {
            lastPics[0].isBack = true
            lastPics[1].isBack = true
            lastPics = []
        }
    } else {
        // Check that the 2 pictures are the same

        if (firstPictureClicked.matchCode === cardObject.matchCode) {
            if (type=="math"){//need to evaluate if a formula and a result were clicked
                //one and only one text can have a mathematical sign
                if (!(isFormule(cardObject.textDisplayed)&&(isFormule(firstPictureClicked.textDisplayed))) && (!(isAnswer(cardObject.textDisplayed)&&(isAnswer(firstPictureClicked.textDisplayed))))){
                    //not 2 formules and not two answers

                    firstPictureClicked.isBack = false // stay faced
                    firstPictureClicked.isFound = true // signal for hidden state
                    cardObject.isBack = false
                    cardObject.isFound = true
                    cardLeft = cardLeft - 2
                    if(cardLeft == 0) { // no more cards in the level
                        youWon()
                    }
                }
                else {  console.log("deux résultats ou deux forumes")
                        lastPics = [firstPictureClicked, cardObject]
                }

            }
            else {
                firstPictureClicked.isBack = false // stay faced
                firstPictureClicked.isFound = true // signal for hidden state
                cardObject.isBack = false
                cardObject.isFound = true
                cardLeft = cardLeft - 2
                if(cardLeft == 0) { // no more cards in the level
                    youWon()

                }
            }
        }
        else { // pictures clicked are not the same
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
