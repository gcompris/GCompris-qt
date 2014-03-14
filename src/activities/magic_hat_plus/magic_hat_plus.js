.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var main
var background
var bar
var bonus
var stars
var nbStarsUnderHat=0

function start(main_, background_, bar_, bonus_) {
    console.log("template activity: start")
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("template activity: stop")
}

function initLevel() {
    console.log("template activity: create some content in my activity")
    stars=new Array(3)
    for(var i=0;i<3;i++){
        stars[i]=new Array(10)
    }
    createStarBar(2,1)
    createStarBar(1,2)
    createStarBar(0,3)
}

function createStar(rank,barNumber,starStatus){
    var component=Qt.createComponent("Star.qml")
    var state=starStatus? "on" : "off"
    var star=component.createObject(background,
                                     {
                                      "x" : background.width/2 + rank*40 ,
                                      "y" : 60*barNumber+ 100*(barNumber-1),
                                      "starState": state
                                     }
                                     );
    return star
}

function createStarBar(nbStarsOn,barNumber){
    for(var i=0;i<10;i++){
        if(i<nbStarsOn){
            stars[barNumber-1][i]=createStar(i,barNumber,1)
        }
        else stars[barNumber-1][i]=createStar(i,barNumber,0)
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

}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
