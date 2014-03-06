.pragma library
.import QtQuick 2.0 as Quick

var currentLevel
var main
var background
var bar
var bonus
var score
var balloon
var iAmReady
var firstOp
var secondOp
var secondOperandVal
var firstOperandVal
var operations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var nbLevel = 10

function start(_main, _background, _bar, _bonus, _score, _balloon,
               _iAmReady, _firstOp, _secondOp) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    score = _score
    balloon = _balloon
    iAmReady = _iAmReady
    firstOp = _firstOp
    secondOp = _secondOp
    currentLevel = 0
    score.numberOfSubLevels = 10
    initLevel()
}

function stop() {
}

function initLevel() {
    bar.level = currentLevel + 1
    score.currentSubLevel = 0
    operations = shuffle(operations)
    calculateOperands()

    iAmReady.visible = true
    balloon.visible = false
    firstOp.visible = false
    secondOp.visible = false
    balloon.stopMoving()
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
    firstOperandVal = bar.level
    secondOperandVal = operations[score.currentSubLevel]
    score.currentSubLevel++
    firstOp.text = firstOperandVal
    secondOp.text = secondOperandVal
}

function validateAnswer(screenAnswer)
{
    return (firstOperandVal * secondOperandVal === screenAnswer)
}

function questionsLeft(numpad, firstOp, secondOp)
{
    if(validateAnswer(parseInt(numpad.answer)))
    {
        numpad.resetText()
        numpad.answerFlag = true

        if(score.currentSubLevel < 10)
        {
            calculateOperands()
            balloon.startMoving(balloon.parent.height * 50)
        }

        else if(score.currentSubLevel >= 10)
        {
            score.currentSubLevel += 1
            balloon.visible = false
            balloon.stopMoving()
            firstOp.visible = false
            secondOp.visible = false
            bonus.good("smiley");
        }
    }
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
