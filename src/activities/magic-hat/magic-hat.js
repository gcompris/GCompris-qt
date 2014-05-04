.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var nbTotalStars=0
var number_of_userStars=0
var items;
var mode;
var magicHat
var number_of_stars=new Array(0,0,0,0)
var nbStarsToAddOrRemove=0
var nbStarsToCount
var count=0

function start(items_,mode_) {
    console.log("Magic hat " + mode_ + " activity: start")
    items=items_
    mode=mode_
    magicHat=items.hat
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("Magic hat " + mode + " activity: stop")
}

function initLevel() {
    console.log("Magic hat " + mode + " activity: create some content in my activity")
    items.bar.level=currentLevel + 1
    magicHat.state="NormalPosition"
    number_of_stars=new Array(0,0,0,0)
    number_of_userStars=0
    nbStarsToAddOrRemove=0
    count=0
    items.hat.starsOpacity=1.0
    for (var i=0;i<5;i++){
         items.barsList[i].resetStars()
    }
    items.barsList[1].opacity = 0
    items.barsList[3].opacity = 0

    switch(currentLevel){
        case 0: number_of_stars[0]=getRandomInt(2,4)
                number_of_stars[1]=0
             break;
        case 1: number_of_stars[0]=getRandomInt(2,6)
                number_of_stars[1]=0
             break;
        case 2: number_of_stars[0]=getRandomInt(1,5)
                number_of_stars[1]=getRandomInt(1,2)
                items.barsList[1].opacity = 1

            break;
        case 3: number_of_stars[0]=getRandomInt(1,5)
                number_of_stars[1]=getRandomInt(1,5)
                items.barsList[1].opacity = 1
                items.barsList[3].opacity = 1
            break;
    }

    items.barsList[0].nbStarsOn = number_of_stars[0]
    items.barsList[1].nbStarsOn = number_of_stars[1]
    nbStarsToAddOrRemove=getRandomInt(1,number_of_stars[0]+number_of_stars[1]-1)
    nbTotalStars=number_of_stars[0]+number_of_stars[1]

    if(mode=="minus"){
        nbStarsToCount=nbTotalStars-nbStarsToAddOrRemove
        items.hat.nbStarsUnderHat=nbStarsToAddOrRemove
        items.barsList[2].nbStarsOn=0
    }
    else {
        nbStarsToCount=nbTotalStars+nbStarsToAddOrRemove
        items.hat.nbStarsUnderHat=0
        items.barsList[2].nbStarsOn=nbStarsToAddOrRemove
    }

}

function verifyAnswer(starState) {
    if(starState=="on_yellow"){
        number_of_userStars++
    }
    else number_of_userStars--
    if(number_of_userStars==nbStarsToCount){
        items.bonus.good("flower")
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

function moveStarsUnderHat(){
    items.hat.targetX=items.background.width/2 + items.background.width/26
    items.hat.targetY=items.columnY + items.background.height/6.5
    for(var i=0;i<2;i++){
        items.barsList[i].targetX=-items.background.width/3 + items.barsList[0].starsSize/1.5
        items.barsList[i].targetY=items.background.height/(2+(i*0.3)) - items.barsList[0].starsSize/4
        items.barsList[i].moveStars()
    }
    items.barsList[2].targetX=-items.background.width/3 + items.barsList[0].starsSize/1.5
    items.barsList[2].targetY=items.background.height/6
    items.barsList[2].moveStars()
}

function animationFinished(){
    count++
    if(mode=="minus" && count==number_of_stars[0]+number_of_stars[1]){
        items.hat.moveStars()
    }
    if(count==nbStarsToAddOrRemove+number_of_stars[0]+number_of_stars[1]){
        userGuessNumberState()
    }
}

function userGuessNumberState(){
    items.barsList[2].nbStarsOn=nbStarsToAddOrRemove
    magicHat.state="GuessNumber"
    items.barsList[4].authorizeClick=true
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
