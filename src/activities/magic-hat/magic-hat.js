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
    console.log("Magic hat minus activity: start")
    items=items_
    mode=mode_
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
    items.hat.nbStarsUnderHat=0

    switch(currentLevel){
        case 0: number_of_stars[0]=getRandomInt(2,4)
                number_of_stars[1]=0
                if(mode=="plus")
                    number_of_stars[2]=getRandomInt(1,3)
                else number_of_stars[2]=0
                number_of_stars[3]=0
             break;
        case 1: number_of_stars[0]=getRandomInt(2,6)
                number_of_stars[1]=0
                if(mode=="plus")
                    number_of_stars[2]=getRandomInt(1,3)
                else number_of_stars[2]=0
                number_of_stars[3]=0
             break;
        case 2: number_of_stars[0]=getRandomInt(1,5)
                number_of_stars[1]=getRandomInt(1,2)
                if(mode=="plus")
                    number_of_stars[2]=getRandomInt(1,3)
                else number_of_stars[2]=0
                number_of_stars[3]=0
                items.barsList[1].opacity = 1

            break;
        case 3: number_of_stars[0]=getRandomInt(1,5)
                number_of_stars[1]=getRandomInt(1,5)
                if(mode=="plus")
                    number_of_stars[2]=getRandomInt(1,3)
                else number_of_stars[2]=0
                number_of_stars[3]=0
                items.barsList[1].opacity = 1
                items.barsList[3].opacity = 1
            break;
    }

    items.barsList[0].nbStarsOn = number_of_stars[0]
    items.barsList[1].nbStarsOn = number_of_stars[1]
    items.barsList[2].nbStarsOn = number_of_stars[2]
    items.barsList[3].nbStarsOn = number_of_stars[3]

    nbStarsToAddOrRemove=getRandomInt(1,number_of_stars[0]+number_of_stars[1]-1)

    items.hat.nbStarsUnderHat=nbStarsToAddOrRemove

    nbTotalStars=number_of_stars[0]+number_of_stars[1]+number_of_stars[2]+number_of_stars[3]

    if(mode=="minus")
        nbStarsToCount=nbTotalStars-nbStarsToAddOrRemove
    else nbStarsToCount=nbTotalStars+nbStarsToAddOrRemove

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
    items.barsList[0].targetX=-items.background.width/3 + items.barsList[0].starsSize
    items.barsList[0].targetY=items.background.height/2 - items.barsList[0].starsSize/2
    items.barsList[0].moveStars()
}

function animationFinished(){
    console.log("animation finished")
    count++
    if(count==1){
        items.hat.moveStars()
    }
    if(count==nbStarsToAddOrRemove+2){
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
