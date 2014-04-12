.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var starsToCount
var nbStarsUnderHat=0
var nbUserStars=0
var items;
var mode;
var magicHat
var nbStars=new Array(0,0,0,0)
var nbStarsToCount=0

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
    starsToCount=new Array()
    nbStars=new Array(0,0,0,0)
    nbUserStars=0
    nbStarsUnderHat=0

    switch(currentLevel){
        case 0: nbStars[0]=getRandomInt(1,2)
                nbStars[1]=0
                nbStars[2]=getRandomInt(1,2)
                nbStars[3]=0
             break;
        case 1: nbStars[0]=getRandomInt(1,4)
                nbStars[1]=0
                nbStars[2]=getRandomInt(1,2)
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

    nbStarsUnderHat=nbStars[0]+nbStars[1]+nbStars[2]+nbStars[3]
    createStarsToMoveUnderHat()
}

function createStarsToMoveUnderHat(){
    for(var i=0;i<nbStars[0];i++){
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
         starsToCount[nbStarsToCount]=star
        nbStarsToCount++
   }
}

function verifyAnswer(starState) {
    if(starState=="on"){
        nbUserStars++
    }
    else nbUserStars--
    if(nbUserStars==nbStarsUnderHat){
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

function moveStarsUnderTheHat(){
    for(var i=0;i<nbStarsUnderHat;i++){
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
