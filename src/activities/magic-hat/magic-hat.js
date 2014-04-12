.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var starsToCount
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
    destroyObjects()
    starsToCount=new Array()
    nbStars=new Array(0,0,0,0)
    nbUserStars=0
    nbStarsToRemove=0
    items.starsBar0.nbStarsOn = 0
    items.starsBar1.nbStarsOn = 0
    items.starsBar2.nbStarsOn = 0
    items.starsBar3.nbStarsOn = 0
    items.starsBarAnswer.nbStarsOn = 0

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
                items.starsBar1.opacity = 1

            break;
        case 3: nbStars[0]=getRandomInt(1,3)
                nbStars[1]=getRandomInt(1,2)
                nbStars[2]=getRandomInt(1,2)
                nbStars[3]=getRandomInt(1,3)
                items.starsBar1.opacity = 1
                items.starsBar2.opacity = 1
            break;
    }

    items.starsBar0.nbStarsOn = nbStars[0]
    items.starsBar1.nbStarsOn = nbStars[1]
    items.starsBar2.nbStarsOn = nbStars[2]
    items.starsBar3.nbStarsOn = nbStars[3]

    nbStarsToRemove=getRandomInt(1,nbStars[0]-1)

    nbTotalStars=nbStars[0]+nbStars[1]+nbStars[2]+nbStars[3]

    nbStarsToCount=nbTotalStars-nbStarsToRemove

    createMovingStars()
}

function createMovingStars(){
    for(var i=0;i<nbStarsToRemove;i++){
        var starcomponent=Qt.createComponent("Star.qml")
        var star=starcomponent.createObject(items.background,
                                                {
                                                    "x" : magicHat.x + magicHat.width/2,
                                                    "y" : magicHat.y + magicHat.height/1.5,
                                                    "z" : magicHat.z - 1,
                                                    "width" : items.starsSize,
                                                    "height" : items.starsSize,
                                                    "starState" : "on",
                                                    "displayBounds": false
                                                })
        starsToCount[i]=star
   }
}

function destroyObjects() {
    if(starsToCount) {
        for(var i=0;i<starsToCount.length;i++) {
            starsToCount[i].destroy()
        }
    }
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

function moveStars(){
    for(var i=0;i<nbStarsToRemove;i++){
        starsToCount[i].x=items.background.width/2 + items.background.width/26 + i*(items.starsSize + 5)
        starsToCount[i].y=items.columnY + items.background.height/6
        starsToCount[i].z++
    }
}

function hideStarsUnderHat(){
    magicHat.state="GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
