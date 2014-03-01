.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var main
var background
var bar
var bonus

function start(main_, background_, bar_, bonus_) {
    console.log("memory-sound activity: start")
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("memory-sound activity: stop")
}

function initLevel() {
    console.log("memory-sound activity: create some content in my activity")
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
