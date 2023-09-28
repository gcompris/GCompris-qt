/* GCompris - guess24.js
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Reference :
 *      https://en.wikipedia.org/wiki/Shunting_yard_algorithm
 *
 * function infixToPostfix(text) is a simplified version of Shunting Yard Algorithm
 *   - Well formed solutions (no check for missing parenthesis)
 *   - Only four operators, all left associative
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

const dataUrl = "qrc:/gcompris/src/activities/guess24/resource/guess24.json"
var numberOfLevel
var items
var allProblems = []        // All dataset problems
var problems = []           // Dataset for current level
var operationsStack = []
var stepsStack= []
var result = 0
var lastAction
var animActions = [ "forward", "backward", "cancel" ]
var unstack = false         // Unstack all operations when true (hintButton)
var helpCount = 0           // Number of lines shown with hintButton (0 to 3)
var splittedSolution = []   // 3 lines for help

var OperandsEnum = {
    NO_SIGN: -1,
    PLUS_SIGN: 0,
    MINUS_SIGN: 1,
    TIMES_SIGN: 2,
    DIVIDE_SIGN: 3
}

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    allProblems = items.jsonParser.parseFromUrl(dataUrl)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.currentSubLevel = 0
    problems = allProblems.filter(obj => { return items.levels[items.currentLevel].complexities.includes(obj.complexity) })
    Core.shuffle(problems)
    problems = problems.slice(0, items.levels[items.currentLevel].count)
    items.subLevelCount = problems.length
    items.operatorsCount = items.levels[items.currentLevel].operatorsCount
    items.cardsBoard.enabled = true
    items.operators.enabled = true
    initCards()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextSubLevel() {
    if( ++items.currentSubLevel >= problems.length)
        nextLevel();
    else
        initCards();
}

function previousSubLevel() {
    if( --items.currentSubLevel < 0)
        previousLevel();
    else
        initCards();
}

function randomSolution(problem, complexities) {
    var max = 0
    for (var i = 0; i < complexities.length; i++) {
        max = Math.max(complexities[i], max)
    }
    var validSolutions = []
    // Check if solution fits required complexity level
    for (var solution of problem["solutions"]) {
        if ((solution.indexOf("/") !== -1) && (max < 3)) {
            continue
        }
        if ((solution.indexOf("*") !== -1) && (max < 2)) {
            continue
        }
        validSolutions.push(solution.trim())
    }
    Core.shuffle(validSolutions)
    var sol = validSolutions[0]     // Choose first valid solution from shuffled array
    sol = sol.replace(new RegExp(/\*/, "g"), "×")
    sol = sol.replace(new RegExp(/\//, "g"), "÷")
    return sol
}

// Convert infixed notation string into a reverse polish notation array (RPN)
// Shunting Yard Algorithm
function infixToPostfix(text) {
    var words = text.match(new RegExp(/(\d+|[\(\)\+-×÷])/g))
    var precedence = { "×": 3, "÷": 3, "+": 2, "-": 2 }
    var rpnStack = []   // Reverse polish notation stack
    var opStack = []    // operators stack
    var op = ""
    while (words.length) {
        var atom = words.shift()
        switch (atom) {
        case "+" :
        case "-" :
        case "×" :
        case "÷" :
            op = opStack[opStack.length - 1]
            while ((op !== "") && (op !== "(") && (precedence[op] >= precedence[atom])) {
                rpnStack.push(opStack.pop())
                op = opStack.length ? opStack[opStack.length - 1] : ""
            }
            opStack.push(atom)
            break
        case "(" :
            opStack.push(atom)
            break
        case ")" :
            op = ""
            while ((op = opStack.pop()) !== "(") {
                rpnStack.push(op)
            }
            break
        default :
            rpnStack.push(atom)
            break
        }
    }
    while (opStack.length) {
        rpnStack.push(opStack.pop())
    }
    return rpnStack
}

function parseSolution(solutionText) {
    splittedSolution = []
    var rpnStack = infixToPostfix(solutionText)

    // Recursive function to solve RPN array (from end to beginning)
    function calcStack() {
        if (!rpnStack.length)
            return
        var atom = rpnStack.pop()
        var value = parseInt(atom)
        if (!isNaN(value)) {
            return value
        } else {
            var calc = 0
            var b = calcStack()
            var a = calcStack()
            switch (atom) {
            case "+": calc = a + b; break
            case "-": calc = a - b; break
            case "×": calc = a * b; break
            case "÷": calc = a / b; break
            }
            splittedSolution.push(`${a} ${atom} ${b} = ${calc}`)
            return calc
        }
    }
    calcStack()   // build solution steps, add them to splittedSolution
}

function initCards() {
    helpCount = 0
    items.animationCard.state = ""
    items.cancelButton.visible = false
    items.hintButton.visible = false
    items.keysOnValues = true
    var puzzle = problems[items.currentSubLevel]["puzzle"].split(" ")
    items.cardsModel.clear()
    for (var i = 0; i < 4; i++) {
        items.cardsModel.append( { "value_" : puzzle[i] })
    }
    items.cardsModel.shuffleModel()
    items.currentValue = -1
    items.cardsBoard.currentIndex = 0
    items.operators.currentIndex = 0
    items.currentOperator = OperandsEnum.NO_SIGN
    unstack = false
    operationsStack = []
    stepsStack = []
    items.steps.text = stepsStack.join("\n")
    parseSolution(randomSolution(problems[items.currentSubLevel], items.levels[items.currentLevel].complexities))
    items.solution.text = ""
}

function valueClicked(idx) {
    result = 0
    if (items.currentValue === -1 || items.currentValue === idx) {
        items.cardsBoard.currentIndex = idx
        items.currentValue = idx
    } else {
        if (items.currentOperator !== OperandsEnum.NO_SIGN) {
            var a = Number(items.cardsModel.get(items.currentValue).value_)
            var b = Number(items.cardsModel.get(idx).value_)
            var text = ""
            switch (items.currentOperator) {
            case OperandsEnum.PLUS_SIGN:
                result = a + b
                text = `${a} + ${b} = ${result}`
                break
            case OperandsEnum.MINUS_SIGN:
                result = a - b
                text = `${a} - ${b} = ${result}`
                break
            case OperandsEnum.TIMES_SIGN:
                result = a * b
                text = `${a} × ${b} = ${result}`
                break
            case OperandsEnum.DIVIDE_SIGN:
                if (b !== 0)
                    result = a / b
                else
                    result = -1.5       // Any rational number will trigger an error
                text = `${a} ÷ ${b} = ${result}`
                break
            }
            stepsStack.push(text)
            // Check if result is not an integer
            if (result !== Math.floor(result)) {
                result = `${a}÷${b}`
            }
            items.cardsBoard.currentIndex = items.currentValue
            // Init card animation
            items.animationCard.value = a
            items.animationCard.x = items.cardsBoard.currentItem.x
            items.animationCard.y = items.cardsBoard.currentItem.y
            operationsStack.push({   from: items.currentValue,
                                     valFrom: String(a),
                                     to: idx,
                                     valTo: String(b)
                                 })
            items.cancelButton.visible = true
            items.cardsBoard.currentItem.visible = false
            items.currentValue = idx
            items.cardsBoard.currentIndex = idx
            // Start card animation
            items.animationCard.action = "forward"
            items.animationCard.state = "moveto"
        } else {
            items.currentValue = idx
            items.cardsBoard.currentIndex = idx
        }
    }
    items.keysOnValues = false
}

function checkResult() {
    items.operators.currentIndex = items.currentOperator
    items.currentOperator = OperandsEnum.NO_SIGN
    if ((result < 0) || (result !== Math.floor(result))) {
        items.animationCard.x = items.cardsBoard.currentItem.x
        items.animationCard.y = items.cardsBoard.currentItem.y
        items.animationCard.value = String(result)
        items.animationCard.action = "cancel"
        items.animationCard.state = "wait"
        return
    }
    items.steps.text = stepsStack.join("\n")
    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')
    items.cardsModel.setProperty(items.currentValue, "value_", String(result))
    if (operationsStack.length === 3) {
        if (Number(items.cardsModel.get(items.currentValue).value_) === 24) {
            items.cancelButton.visible = false
            items.bonus.good("sun")
        } else {
            items.bonus.bad("sun")
            items.hintButton.visible = true
        }
    }
}

function operatorClicked(idx) {
    if ((items.currentValue === -1) || (items.animationCard.state !== ""))
        return
    if (items.currentOperator === idx)
        items.currentOperator = OperandsEnum.NO_SIGN
    else {
        items.currentOperator = idx
        items.operators.currentIndex = idx
    }
    items.keysOnValues = true
}

function popOperation() {
    items.cancelButton.enabled = false
    lastAction = operationsStack.pop();
    items.cardsModel.setProperty(lastAction.to, "value_", lastAction.valTo)
    items.animationCard.value = lastAction.valFrom
    items.currentValue = items.cardsBoard.currentIndex = lastAction.to
    items.animationCard.x = items.cardsBoard.currentItem.x
    items.animationCard.y = items.cardsBoard.currentItem.y
    items.currentValue = items.cardsBoard.currentIndex = lastAction.from
    items.animationCard.action = "backward"
    items.animationCard.state = "moveto"
    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
    items.hintButton.visible = false
    if (operationsStack.length < 1)
        items.cancelButton.visible = false
    items.keysOnValues = true
}

function endPopOperation() {
    stepsStack.pop()
    items.steps.text = stepsStack.join("\n")
    items.cardsModel.setProperty(lastAction.from, "value_", lastAction.valFrom)
    items.currentValue = items. cardsBoard.currentIndex = lastAction.from
    items.cardsBoard.currentItem.visible = true
    if (!operationsStack.length)
        unstack = false
    if ((unstack) && (operationsStack.length > 0))
        popOperation()
    if (!unstack)
        items.cancelButton.enabled = true
}

function moveToNextCard() {
    if (items.keysOnValues) {
        do {
            items.cardsBoard.currentIndex = ++items.cardsBoard.currentIndex % items.cardsBoard.count
        } while (!items.cardsBoard.currentItem.visible)
    } else {
        items.operators.currentIndex = ++items.operators.currentIndex % items.operatorsCount
    }
}

function handleKeys(event) {
    items.keyboardNavigation = true
    switch (event.key) {
    case Qt.Key_Up:
    case Qt.Key_Down:
        if (items.keysOnValues) {
            do {
                switch (items.cardsBoard.currentIndex) {
                case OperandsEnum.PLUS_SIGN: items.cardsBoard.currentIndex = OperandsEnum.TIMES_SIGN; break;
                case OperandsEnum.MINUS_SIGN: items.cardsBoard.currentIndex = OperandsEnum.DIVIDE_SIGN; break;
                case OperandsEnum.TIMES_SIGN: items.cardsBoard.currentIndex = OperandsEnum.PLUS_SIGN; break;
                case OperandsEnum.DIVIDE_SIGN: items.cardsBoard.currentIndex = OperandsEnum.MINUS_SIGN; break;
                }

            } while (!items.cardsBoard.currentItem.visible)
        } else {
            items.keysOnValues = true
        }
        break
    case Qt.Key_Left:
        if (items.keysOnValues) {
            do {
                items.cardsBoard.currentIndex = (items.cardsBoard.count + items.cardsBoard.currentIndex - 1) % items.cardsBoard.count
            } while (!items.cardsBoard.currentItem.visible)
        } else {
            items.operators.currentIndex = (items.operatorsCount + items.operators.currentIndex - 1) % items.operatorsCount
        }

        break
    case Qt.Key_Right:
        moveToNextCard()
        break
    case Qt.Key_Return:
    case Qt.Key_Enter:
    case Qt.Key_Space:
        if (items.keysOnValues)
            valueClicked(items.cardsBoard.currentIndex)
        else {
            operatorClicked(items.operators.currentIndex)
            moveToNextCard()
        }
        break
    case Qt.Key_Plus:
        operatorClicked(OperandsEnum.PLUS_SIGN)
        break
    case Qt.Key_Minus:
        operatorClicked(OperandsEnum.MINUS_SIGN)
        break
    case Qt.Key_Asterisk:
        if (items.operatorsCount > 2)
            operatorClicked(OperandsEnum.TIMES_SIGN)
        break
    case Qt.Key_Slash:
        if (items.operatorsCount > 3)
            operatorClicked(OperandsEnum.DIVIDE_SIGN)
        break
    case Qt.Key_Delete:
    case Qt.Key_Backspace:
        if (items.solutionRect.opacity !== 0.0)
            items.animSol.start()
        else if ((items.cancelButton.enabled) && (operationsStack.length > 0))
            popOperation()
        break
    case Qt.Key_Tab:
        if (items.currentValue != -1)
            items.keysOnValues = !items.keysOnValues
        break
    }
}
