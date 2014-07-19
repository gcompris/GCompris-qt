/* gcompris - CardItem.qml
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
var cardObject
var nb_of_pair
var nbOfPairLevelRelationArray
var imageList
var line
var column
var firstPictureClicked
var lastPics = new Array
var cardLeft
var cardList
var cardListAnswer
var cardListToShow
var displayWidthRatio
var displayHeightRatio
var displayX
var displayY
var type
var sound1
var tux
var additionnalPath
var nbCardClicked
var playerPoints
var tuxPoints
var tuxTeacher
var tuxTeacherText
var playerText


function start(main_,type_, background_, bar_, bonus_,
               containerModel_, cardRepeater_, grid_,
               dataset_, displayWidthRatio_, displayHeightRatio_,
               displayX_, displayY_, sound1_,tux_,additionnalPath_) {

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
    sound1 = sound1_


    imageList = dataset_ //could be a file list or a operation list. It's an array of array.
    tux=tux_
    if (tux==true){

        additionnalPath=additionnalPath_
    }
    else{
        additionnalPath=""
    }

    initLevel()
}
function destroyTeacher(){
    //delete childs if necessary
    if (tux){
        try{
            tuxTeacherText.visible = 0
            tuxTeacherText.destroy()
            playerText.visible = 0
            playerText.destroy()
            tuxTeacher.visible = 0
            tuxTeacher.destroy()
        } catch (TypeError) {
            console.log('first Run, objects dont exist' )
        }
    }
}

function stop() {

}

function initLevel() {
    bar.level = currentLevel + 1
    containerModel.clear()
    firstPictureClicked = null
    nbCardClicked= -1
    console.log("imageList,  imageList.length", imageList,  imageList.length)
    //clean the background
    destroyTeacher()
    // compute the number of cards
    line = nbOfPairLevelRelationArray[currentLevel][1]
    column = nbOfPairLevelRelationArray[currentLevel][0]
    grid.columns = column
    nb_of_pair = line * column / 2

    // place randomly a level-defined number of picture pair
    cardList = []
    cardListAnswer = []
    for(var ix = 0;  ix < nb_of_pair; ++ix){
        // select  a picture randomly from 21 pictures

                var cardNb = Math.floor((imageList.length/10*(currentLevel+1)) * Math.random())
                var card = imageList[cardNb][0] //Difficulty is define here. By construction of dataset
                var cardAnswer = imageList[cardNb][1]

            if (cardList.length > 0){
                while (cardList.indexOf(card) >= 0) {
                                    var cardNb = Math.floor((imageList.length) * Math.random())
                                    var card = additionnalPath+imageList[cardNb][0]
                                    var cardAnswer = additionnalPath+imageList[cardNb][1]

            }

        }

            console.log(ix)
            cardList[ix]= [card, cardAnswer]
            cardListAnswer[ix] = [cardAnswer, cardAnswer]

    }
    console.log("card, cardAnswer ,cardList, carListaNswer,cardList[0], cardList.lentgh ", card, cardAnswer ,cardList, cardListAnswer, cardList[0], cardListAnswer[1], cardList.length )

    //construct Cards to show
    cardListToShow = Core.shuffle(cardList.concat(cardListAnswer))
    console.log(cardListToShow.length,cardListToShow[0] )

    cardLeft = cardListToShow.length


    // fill in with pictures

    for(var i = 0;  i < cardListToShow.length; ++i) {
        if (type == "picture"){
        containerModel.append({"back": "resource/backcard.png",
                               "image": "resource/" + cardListToShow[i][0],
                               "width_": main.width * displayWidthRatio / column,
                               "height_": main.height * displayHeightRatio / line,
                               "matchCode_": cardListToShow[i][1],
                               "audioFile_": "",
                               "text_": ""})
        }
        else if (type == "sound") {
            containerModel.append({"back": "qrc:/gcompris/src/activities/memory-sound/resource/Tux_mute.png",
                                   "image": "qrc:/gcompris/src/activities/memory-sound/resource/Tux_play.png", //it's a sound memory
                                   "width_": main.width * displayWidthRatio / column,
                                   "height_": main.height * displayHeightRatio / line,
                                   "matchCode_": cardListToShow[i][1],
                                   "audioFile_": cardListToShow[i][1],
                                   "text_": ""})
        }
        else if (type == "math") {
            containerModel.append({"back": "qrc:/gcompris/src/activities/memory/resource/backcard.png",
                                   "image": "qrc:/gcompris/src/activities/memory/resource/emptycard.png",
                                   "width_": main.width * displayWidthRatio / column,
                                   "height_": main.height * displayHeightRatio / line,
                                   "matchCode_": cardListToShow[i][1].toString(), // to change
                                   "audioFile_": "",
                                   "text_": cardListToShow[i][0].toString().replace("*","x").replace("/",String.fromCharCode(247))})
        }
    }
    if (tux) {
        //drawing teacher tux
        var qmlTux="import QtQuick 2.0; Image {source: 'qrc:/gcompris/src/activities/memory/resource/tux-teacher.png'; width: 100; height: 130; x:0.8*parent.width; y:0.5*parent.height}"
        tuxTeacher = Qt.createQmlObject(qmlTux,main, "tuxTeacher");

        //initilize points
        tuxPoints = 0
        nbCardClicked=0
        playerPoints=0
        drawPoints()

    }

}

function drawPoints(){
    if ((tuxPoints!=0) || (playerPoints!=0)){
        tuxTeacherText.destroy()
        playerText.destroy()
    }
    var qmlTuxText="import QtQuick 2.0; Rectangle {width: 100; height: 156;color:'#000000FF'; Text{anchors.centerIn:parent;text:'"+String(tuxPoints)+"';font.bold:true;font.pointSize:24 }}"
    tuxTeacherText = Qt.createQmlObject(qmlTuxText,tuxTeacher, "tuxTeacherText");
    //player points
    var qmlPlayerText="import QtQuick 2.0; Rectangle {x:0.8*parent.width;y:0.2*parent.height;width: 100; height: 156;color:'#000000FF'; Text{anchors.centerIn:parent;text:'"+String(playerPoints)+"';font.bold:true;font.pointSize:24 }}"
    playerText = Qt.createQmlObject(qmlPlayerText,main, "tuxTeacherText");

}

function isFormule(text){
    return ((text.indexOf("+")>0) || (text.indexOf("-")>0) || (text.indexOf("x")>0) || (text.indexOf(String.fromCharCode(247))>0))
}

function isAnswer(text){
    return !isFormule(text)
}

function chooseCard(){
    var listCardNonReturned = []
    for(var i = 0;  i < cardList.length; ++i){
//        if ((cardRepeater.itemAt(i).isBack==true) && (cardRepeater.itemAt(i).isFound==false) ){
        if (cardRepeater.itemAt(i).isFound==false) {
            listCardNonReturned[i]=i
        }
    }
    //select randomly a card in it
    var index = Math.floor(Math.random() * listCardNonReturned.length)
    var listValue = listCardNonReturned[index]
    if (listCardNonReturned.length>1){
        while (listValue==null){

            index = Math.floor(Math.random() * listCardNonReturned.length)
            listValue = listCardNonReturned[index]
        }

        return cardRepeater.itemAt(listValue)
    } else {
        return 0
    }
}

function reverseCards(){
    if(lastPics.length == 2) {
        lastPics[0].isBack = true
        lastPics[1].isBack = true
        lastPics = []
    }
}

function cardClicked(cardObject) {
    nbCardClicked+=1 //count nb of clicks
    if (!firstPictureClicked) {//at first click
        firstPictureClicked = cardObject
//        if(lastPics.length == 2) {
//            lastPics[0].isBack = true
//            lastPics[1].isBack = true
//            lastPics = []
//        }
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
                    if (tux){
                        if (nbCardClicked==0){
                           tuxPoints+=1
                        } else {
                            playerPoints+=1
                        }

                        drawPoints()
                    }

                    if(cardLeft == 0) { // no more cards in the level
                        if(tux){
                            cardLeft=1 //avoid a infinite loop
                            if (tuxPoints<playerPoints){

                                youWon()
                            } else {
                                youLoose()
                            }
                        } else {
                            youWon()
                        }

                    }
                } else {  //two results or two formulas
                        lastPics = [firstPictureClicked, cardObject]
                }

            } else { //The same but not in a mathematical memory
                firstPictureClicked.isBack = false // stay faced
                firstPictureClicked.isFound = true // signal for hidden state
                cardObject.isBack = false
                cardObject.isFound = true
                cardLeft = cardLeft - 2
                if (tux){
                    if (nbCardClicked==0){
                       tuxPoints+=1
                    } else {
                        playerPoints+=1
                    }
                    drawPoints()
                }

                if(cardLeft == 0) { // no more cards in the level
                    if(tux){
                        cardLeft=1 //avoid a infinite loop
                        if (tuxPoints<playerPoints){
                            youWon()
                        } else {
                            youLoose()
                        }
                    } else {
                        youWon()

                    }
                }
            }
        }
        else { // pictures clicked are not the same
            // keep them to reverse them on next click
            lastPics = [firstPictureClicked, cardObject]
        }
        firstPictureClicked = null
    }


    if (((tux) && (nbCardClicked==2)) || ((tux) && (nbCardClicked==3))){

        if (nbCardClicked==3){
            nbCardClicked=-1
        }
        //return all previous cards
        if(lastPics.length == 2) {
            lastPics[0].isBack = true
            lastPics[1].isBack = true

            //have to wait transition

            lastPics = []
            firstPictureClicked = null

        }
        //choose a card
        //construct an array with non selected cards
        cardObject = chooseCard()
        if (firstPictureClicked){
            while (cardObject==firstPictureClicked){
                cardObject=chooseCard()
            }
        }

        //click a card
        if (cardObject!==0){
            cardObject.doWithClick() //click cardObject
        }

    }
}

function youWon() {
    bonus.good("flower")
    //nextLevel()
}

function youLoose(){
    bonus.bad("flower")
    if (tux){
        initLevel()
    }
}

function nextLevel() {
    destroyTeacher()
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


