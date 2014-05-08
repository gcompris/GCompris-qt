.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 9
var nbTotalStars=0
var number_of_userStars=new Array()
var items;
var mode;
var magicHat
var number_of_stars=new Array()
var nbStarsToAddOrRemove=new Array()
var nbStarsToCount=new Array()
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
    number_of_stars=new Array(0,0,0)
    number_of_userStars=new Array(0,0,0)
    nbStarsToAddOrRemove=new Array(0,0,0)
    nbStarsToCount=new Array(0,0,0)
    count=0
    for (var i=0;i<items.repeatersList.length;i++){
        for(var j=0;j<3;j++){
            items.repeatersList[i].itemAt(j).resetStars()
            if(j==0){
                items.repeatersList[i].itemAt(j).opacity = 1
            }
            else items.repeatersList[i].itemAt(j).opacity = 0
        }
    }

    switch(currentLevel){
        case 0: number_of_stars[0]=getRandomInt(2,4)
             break;
        case 1: number_of_stars[0]=getRandomInt(2,6)
             break;
        case 2: number_of_stars[0]=getRandomInt(2,10)
            break;
        case 3: number_of_stars[0]=getRandomInt(2,5)
                number_of_stars[1]=getRandomInt(2,5)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                }
            break;
        case 4: number_of_stars[0]=getRandomInt(2,8)
                number_of_stars[1]=getRandomInt(2,8)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                }
             break;
        case 5: number_of_stars[0]=getRandomInt(2,10)
                number_of_stars[1]=getRandomInt(2,10)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                }
             break;
        case 6: number_of_stars[0]=getRandomInt(2,4)
                number_of_stars[1]=getRandomInt(2,4)
                number_of_stars[2]=getRandomInt(2,4)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                    items.repeatersList[i].itemAt(2).opacity = 1
                }
            break;
        case 7: number_of_stars[0]=getRandomInt(2,6)
                number_of_stars[1]=getRandomInt(2,6)
                number_of_stars[2]=getRandomInt(2,6)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                    items.repeatersList[i].itemAt(2).opacity = 1
                }
            break;
        case 8: number_of_stars[0]=getRandomInt(2,8)
                number_of_stars[1]=getRandomInt(2,8)
                number_of_stars[2]=getRandomInt(2,8)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                    items.repeatersList[i].itemAt(2).opacity = 1
                }
            break;
        case 9: number_of_stars[0]=getRandomInt(2,10)
                number_of_stars[1]=getRandomInt(2,10)
                number_of_stars[2]=getRandomInt(2,10)
                for(var i=0;i<3;i++){
                    items.repeatersList[i].itemAt(1).opacity = 1
                    items.repeatersList[i].itemAt(2).opacity = 1
                }
            break;
    }

    for(var i=0;i<3;i++){
        items.repeatersList[0].itemAt(i).nbStarsOn = number_of_stars[i]
        if(number_of_stars[i]>0){
            if(mode=="minus")
                nbStarsToAddOrRemove[i]=getRandomInt(1,number_of_stars[i]-1)
            else nbStarsToAddOrRemove[i]=getRandomInt(1,10-number_of_stars[i])
        }
        else nbStarsToAddOrRemove[i]=0
    }

    if(mode=="minus"){
        items.hat.nbYellowStars=nbStarsToAddOrRemove[0]
        items.hat.nbGreenStars=nbStarsToAddOrRemove[1]
        items.hat.nbBlueStars=nbStarsToAddOrRemove[2]
        for(var i=0;i<3;i++){
            nbStarsToCount[i]=number_of_stars[i]-nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn=0
        }
    }
    else {
        items.hat.nbYellowStars=0
        items.hat.nbGreenStars=0
        items.hat.nbBlueStars=0
        for(var i=0;i<3;i++){
            nbStarsToCount[i]=number_of_stars[i]+nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn=nbStarsToAddOrRemove[i]
        }
    }
}

function verifyAnswer(starState) {
    if(starState=="on_yellow"){
        number_of_userStars[0]++
    }
    if(starState=="on_green"){
        number_of_userStars[1]++
    }
    if(starState=="on_blue"){
        number_of_userStars[2]++
    }
    if(number_of_userStars[0]==nbStarsToCount[0] && number_of_userStars[1]==nbStarsToCount[1] && number_of_userStars[2]==nbStarsToCount[2]){
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
    items.hat.targetY=items.columnY + items.background.height/8
        for(var j=0;j<3;j++){
            items.repeatersList[0].itemAt(j).targetX=-items.background.width/3 + items.starsSize/1.5
            items.repeatersList[0].itemAt(j).targetY=items.background.height/(2+(j*0.3)) + items.starsSize/4
            items.repeatersList[0].itemAt(j).moveStars()
        }
}

function movePlusStars(){
    for(var j=0;j<3;j++){
        items.repeatersList[1].itemAt(j).targetX=-items.background.width/3 + items.starsSize/1.5
        items.repeatersList[1].itemAt(j).targetY=items.background.height/(4+(j*1.3)) - items.starsSize/5
        items.repeatersList[1].itemAt(j).moveStars()
    }
}

//Function called everytime a star animation ends, it permits to change the hat state at the end of an animation for exemple
function animationFinished(){
    count++
    if(count==number_of_stars[0]+number_of_stars[1]+number_of_stars[2]){
        if(mode=="minus")
            items.hat.moveStars()
        else movePlusStars()
    }
    if(count==number_of_stars[0]+number_of_stars[1]+number_of_stars[2]+nbStarsToAddOrRemove[0]+nbStarsToAddOrRemove[1]+nbStarsToAddOrRemove[2]){
        userGuessNumberState()
    }
}

function userGuessNumberState(){
    for(var i=0;i<3;i++){
        items.repeatersList[2].itemAt(i).authorizeClick=true
        if(mode=="minus")
            items.repeatersList[1].itemAt(i).nbStarsOn=nbStarsToAddOrRemove[i]
    }
    magicHat.state="GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
