.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var nbTotalStars=0
var nbUserStars=0
var items;
var mode;
var magicHat
var nbStars=new Array(0,0,0,0)
var nbStarsToRemove=0
var nbStarsToCount

function start(items_,mode_) {
    console.log("Magic hat minus activity: start")
    items=items_
    magicHat=items.hat
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("Magic hat minus activity: stop")
}

function initLevel() {
    console.log("Magic hat minus activity: create some content in my activity")
    items.bar.level=currentLevel + 1
    magicHat.state="NormalPosition"
    nbStars=new Array(0,0,0,0)
    nbUserStars=0
    nbStarsToRemove=0
    items.hat.starsOpacity=1.0
    items.barsList[0].nbStarsOn = 0
    items.barsList[1].nbStarsOn = 0
    items.barsList[2].nbStarsOn = 0
    items.barsList[3].nbStarsOn = 0
    items.barsList[4].nbStarsOn = 0

    switch(currentLevel){
        case 0: nbStars[0]=getRandomInt(2,4)
                nbStars[1]=0
                nbStars[2]=0
                nbStars[3]=0
             break;
        case 1: nbStars[0]=getRandomInt(2,6)
                nbStars[1]=0
                nbStars[2]=0
                nbStars[3]=0
             break;
        case 2: nbStars[0]=getRandomInt(1,5)
                nbStars[1]=getRandomInt(1,2)
                nbStars[2]=getRandomInt(1,3)
                nbStars[3]=0
                items.barsList[1].opacity = 1

            break;
        case 3: nbStars[0]=getRandomInt(1,3)
                nbStars[1]=getRandomInt(1,2)
                nbStars[2]=getRandomInt(1,2)
                nbStars[3]=getRandomInt(1,3)
                items.barsList[1].opacity = 1
                items.barsList[2].opacity = 1
            break;
    }

    items.barsList[0].nbStarsOn = nbStars[0]
    items.barsList[1].nbStarsOn = nbStars[1]
    items.barsList[2].nbStarsOn = nbStars[2]
    items.barsList[3].nbStarsOn = nbStars[3]

    nbStarsToRemove=getRandomInt(1,nbStars[0]-1)

    items.hat.nbStarsUnderHat=nbStarsToRemove

    nbTotalStars=nbStars[0]+nbStars[1]+nbStars[2]+nbStars[3]

    nbStarsToCount=nbTotalStars-nbStarsToRemove

}

function verifyAnswer(starState) {
    if(starState=="on"){
        nbUserStars++
    }
    else nbUserStars--
    if(nbUserStars==nbStarsToCount){
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

function getNewStarsCoordinates(){
    items.hat.newX=items.background.width/2 + items.background.width/26
    items.hat.newY=items.columnY + items.background.height/6
}

function changeHatState(){
    items.barsList[2].nbStarsOn=nbStarsToRemove
    items.hat.starsOpacity=0
    magicHat.state="GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
