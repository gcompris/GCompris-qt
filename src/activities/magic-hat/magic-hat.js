.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var starsBars
var starsToCount
var magicHat
var nbStarsUnderHat=0
var nbUserStars=0
var items;
var mode

function start(items_,mode_) {
    console.log("template activity: start")
    items=items_
    currentLevel = 0
    destroyObjects()
    initLevel()
}

function stop() {
    console.log("template activity: stop")
    destroyObjects()
}

function initLevel() {
    console.log("template activity: create some content in my activity")
    destroyObjects()
    starsBars=new Array(3)
    starsToCount=new Array()
    nbUserStars=0
    nbStarsUnderHat=0
    var nbStars1
    var nbStars2
    magicHat=createHat()

    switch(currentLevel){
        case 1: nbStars1=getRandomInt(1,2)
                nbStars2=getRandomInt(1,2)
             break;
        case 2: nbStars1=getRandomInt(1,3)
            nbStars2=getRandomInt(1,2)
             break;
        case 3: nbStars1=getRandomInt(1,4)
            nbStars2=getRandomInt(1,3)
            break;
        case 4: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,4)
            break;
        case 5: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,5)
            break;
        case 6: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,5)
            break;
        case 7: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,5)
            break;
        case 8: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,5)
            break;
        case 9: nbStars1=getRandomInt(1,5)
            nbStars2=getRandomInt(1,5)
            break;
    }

    starsBars[0]=createStarBar(2,1)
    starsBars[1]=createStarBar(1,2)
    starsBars[2]=createStarBar(0,3)
}

function createHat(){
     var component=Qt.createComponent("Hat.qml")
     var hat=component.createObject(items.background.leftLayout,
                                    {
                                        "anchors.centerIn" : items.background.leftLayout,
                                    });
    return hat
}

function destroyObjects() {
    if (starsBars) {
        for(var i = 0;  i < starsBars.length; ++i) {
            starsBars[i].destroy()
        }
        starsBars.length = 0
    }
    if(magicHat)
        magicHat.destroy()
    if(starsToCount){
        for(var j=0;j<nbStarsUnderHat;j++){
            starsToCount[j].destroy()
        }
    }
}

function createStarBar(nbStarsOn,barNumber){

    var component=Qt.createComponent("StarsBar.qml")
    var offset
    var isClickAuthorized
    switch(barNumber){
        case 1: offset=-items.background.height/3
                isClickAuthorized=false
            break;
        case 2: offset=0
                isClickAuthorized=false
            break;
        case 3: offset=items.background.height/3
                isClickAuthorized=true
            break;
    }

    var starbar=component.createObject(items.background,
                                       {
                                        "nbStarsOn": nbStarsOn,
                                        "vertOffset" : offset,
                                        "authorizeClick" : isClickAuthorized
                                       })
    for(var i=0;i<nbStarsOn;i++){
        var starcomponent=Qt.createComponent("Star.qml")
        var star=starcomponent.createObject(items.background,
                                            {
                                                "x" : starbar.x + (starbar.height + 5)*i,
                                                "y" : starbar.y,
                                                "width" : starbar.height,
                                                "height" : starbar.height,
                                                "starState" : "on",
                                                "displayBounds": false
                                            })
        starsToCount[nbStarsUnderHat]=star
        nbStarsUnderHat++
    }

    return starbar
}

function verifyAnswer(starState){
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
        starsToCount[i].x=magicHat.x + magicHat.width/2
        starsToCount[i].y=magicHat.y + magicHat.height - 40
        starsToCount[i].z=magicHat.z-1
    }
}

function hideStarsUnderHat(){
    magicHat.state="GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
