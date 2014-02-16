.pragma library
.import QtQuick 2.0 as Quick

var _currentLevel = 0
var _numberOfLevel = 4
var _main
var _background
var _bar
var _bonus

function start(main, background, bar, bonus) {
    console.log("template activity: start")
    _main = main
    _background = background
    _bar = bar
    _bonus = bonus
    _currentLevel = 0
    initLevel()
}

function stop() {
    console.log("template activity: stop")
}

function initLevel() {
    console.log("template activity: create some content in my activity")
}

function nextLevel() {
    if(_numberOfLevel <= ++_currentLevel ) {
        _currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--_currentLevel < 0) {
        _currentLevel = _numberOfLevel - 1
    }
    initLevel();
}
