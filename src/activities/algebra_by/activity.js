.pragma library
.import QtQuick 2.0 as Quick

var currentLevel
var currentSubLevel
var main
var background
var bar
var bonus
var secondOperand
var firstOperand
var totalQuestions
var score
var operationDone = [false, false, false, false, false, false, false, false, false, false]

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
    totalQuestions = 0
    score = 0

    console.log("Activity.js start()");
}

function stop() {
    //destroyBlocks();
}

function initLevel() {

    for(var i=0; i<10; i++)
        operationDone[i] = false
    bar.level = currentLevel + 1
    console.log("Activity.js initLevel()");
    background.source = "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
    calculateOperands()
    totalQuestions = 0
    score = 0

 }

function nextLevel() {
    if( ++currentLevel >= nbLevel ) {
        currentLevel = 0
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
    console.log("Activity.js calculateOperands() " + bar.level);
    firstOperand = bar.level
    secondOperand = getOperand()
}
function getOperand()
{
    console.log("Activity.js getOperand() " + bar.level)
  var j = 10;
  var i = Math.floor((Math.random() * 10) + 1);

  // Get the next free slot
  while(operationDone[i] === true && j>=0)
    //while(j>=0)
    {
      j--;
      i++;
      if(i>10)
        i=1;
    }
  operationDone[i] = true;
  return i;
}

function validateAnswer(screenAnswer)
{
    if(firstOperand * secondOperand == (screenAnswer * 1))
    {
        console.log("Correct Answer")
        //totalQuestions += 1
        return true
    }
}

