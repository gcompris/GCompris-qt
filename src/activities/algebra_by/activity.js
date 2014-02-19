.pragma library
.import QtQuick 2.0 as Quick

var backgroundImages = [
    "scenery2_background.png",
]

var currentLevel
var currentSubLevel
var main
var background
var bar
var bonus
var secondOperand
var firstOperand

// The array of created blocks object
var createdBlocks
var killedBlocks

var nbLevel = 6
var nbSubLevel = 8

function start(_main, _background, _bar, _bonus) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    currentLevel = 0
    currentSubLevel = 0
    initLevel()

    console.log("Activity.js start()");
}

function stop() {
    //destroyBlocks();
}

function initLevel() {
    console.log("Activity.js initLevel()");
    bar.level = currentLevel + 1
    background.source = "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
    calculateOperands()

 }

function nextLevel() {
    if( ++currentLevel >= nbLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= nbSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = nbLevel - 1
    }
    initLevel();
}

function calculateOperands()
{
    console.log("Activity.js calculateOperands()");
    var min
    var max

    switch(currentLevel + 1)
    {
    case 1 :
        min = 1;
        max = 2;
        break;
    case 2 :
        min = 2;
        max = 3;
        break;
    case 3 :
        min = 4;
        max = 5;
        break;
    case 4 :
        min = 6;
        max = 7;
        break;
    case 5 :
        min = 8;
        max = 9;
        break;
    case 6 :
        min = 1;
        max = 10;
        break;
    default :
        min = 1;
        max = 10;
    }
    secondOperand = (min + Math.floor(Math.random() * max-min+1));
    console.log(secondOperand);
    firstOperand  = (secondOperand*(min + Math.floor(Math.random() * max)));
    console.log(firstOperand);
}

