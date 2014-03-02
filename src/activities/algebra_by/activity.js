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
var operationDone = [false, false, false, false, false, false, false, false, false, false]
var jsIamReady
var jsBalloon
var jsScore

// The array of created blocks object
var createdBlocks
var killedBlocks

var nbLevel = 10

function start(_main, _background, _bar, _bonus) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    currentLevel = 0
    currentSubLevel = 0
    initLevel()
    totalQuestions = 1
}

function stop() {
}

function initLevel() {

    for(var i=0; i<10; i++)
        operationDone[i] = false
    bar.level = currentLevel + 1
    background.source = "qrc:/gcompris/src/activities/algebra_by/resource/scenery2_background.png"
    calculateOperands()
    totalQuestions = 1
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
    firstOperand = bar.level
    secondOperand = getOperand()
}

function getOperand()
{
    var j = 10;
    var i = Math.floor((Math.random() * 10) + 1);

    // Get the next free slot
    while(operationDone[i] === true && j>=0)
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
        return true
    }
}

function questionsLeft(numpad, score, firstOp, secondOp, balloon, iamReady)
{
    jsIamReady = iamReady
    jsBalloon = balloon
    jsScore = score
    if(validateAnswer(numpad.answer))
    {
        numpad.resetText()
        numpad.answerFlag = true

        if(totalQuestions < 10)
        {
            console.log("totalQuestions " + totalQuestions + "second Operand " + secondOperand)
            totalQuestions += 1
            score.currentSubLevel += 1
            calculateOperands()
            firstOp.firstOpCalculated()
            secondOp.secondOpCalculated()
            balloon.startMoving(balloon.parent.height * 50)

        }

        else if(totalQuestions >= 10)
        {
            score.currentSubLevel += 1
            console.log("totalQuestions " + totalQuestions + "second Operand " + secondOperand)
            totalQuestions = 0
            balloon.visible = false
            balloon.stopMoving()
            firstOp.visible = false
            secondOp.visible = false
            bonus.good("smiley");
            bonus.done.connect(afterDone)
            nextLevel()

        }


    }

    function afterDone(iamReady, balloon)
    {
        jsIamReady.visible = true
        jsBalloon.visible = false
        jsScore.currentSubLevel = 0
    }
}

