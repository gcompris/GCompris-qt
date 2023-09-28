/* GCompris - GnumchEquality.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var main
var bonus
var type
var operator
var modelCells
var levels
var useMultipleDataset
var items
var primeNumbers = [2, 3, 5, 7, 11, 13, 17, 19, 23]

function start(items_, type_, useMultipleDataset_) {
    items = items_
    levels = items.levels
    useMultipleDataset = useMultipleDataset_
    bonus = items.bonus
    type = type_
    operator = items.operator
    modelCells = items.modelCells
    numberOfLevel = (useMultipleDataset) ? levels.length : 8
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
}

function stop() {
}

function initLevel() {
    if(type === "equality" || type === "inequality") {
        operator = levels[items.currentLevel].operator
    }
    fillAllGrid();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
}

function getGoal() {
    var goal = 0
    if (useMultipleDataset) {
        goal = levels[items.currentLevel].goal
    }
    else {
        if (type == "multiples") {
            goal = items.currentLevel + 2
        } else if (type == "factors") {
            var goalsFactor = [4, 6, 8, 10, 12, 15, 18, 20]
            goal = goalsFactor[items.currentLevel]
        } else if (type == "primes") {
            goal = primeNumbers[items.currentLevel + 1] + 1
        }
    }

    return goal
}

function genNumber() {
    if (Math.random() < 0.5) {
        // Choose a good number
        return (getGoal())
    } else {
        // Choose a bad number
        var sign = Math.random() - 0.5
        sign = sign / Math.abs(sign)
        var number = getGoal() + (sign * Math.floor(((Math.random() * (getGoal() - 1)) + 1)))
        return number
    }
}

function genMultiple() {
    var number = getGoal() * Math.floor(Math.random() * 6 + 1)
    if (Math.random() < 0.5) {
        // Choose a good number
        return number
    } else {
        // Choose a bad number
        return number - 1
    }
}

function genFactor() {
    var goodOnes = []
    var badOnes = []
    for (var div = 1; div < getGoal() + 1; ++div) {
        if (getGoal() % div == 0) {
            goodOnes.push(div)
        } else {
            badOnes.push(div)
        }
    }

    if (Math.random() < 0.5) {
        // Choose a good number
        return goodOnes[Math.floor(Math.random() * goodOnes.length)]
    } else {
        // Choose a bad number
        return badOnes[Math.floor(Math.random() * badOnes.length)]
    }
}

function genPrime() {
    var badNumbers = [1, 4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 22]
    if (Math.random() < 0.5) {
        // Choose a good number
        var goodOnes = []
        for (var it = 0; it < primeNumbers.length; ++it) {
            if (getGoal() < primeNumbers[it])
                break

            goodOnes.push(primeNumbers[it])
        }
        return goodOnes[Math.floor(Math.random() * goodOnes.length)]
    } else {
        // Choose a bad number
        var badOnes = []
        for (var it = 0; it < badNumbers.length; ++it) {
            if (getGoal() < badNumbers[it])
                break

            badOnes.push(badNumbers[it])
        }
        return badOnes[Math.floor(Math.random() * badOnes.length)]
    }
}

function genTime() {
    // generate a time in millisecond between 3,000 and 10,000
    var time = Math.floor(((Math.random() * 10) + 3)) * 1000
    return time
}

function splitDivisionNumber(term) {
    var term1 = term * Math.floor(Math.random() * 6 + 1)
    var term2 = term1 / term

    return [term1, term2]
}

function splitMultiplicationNumber(term) {
    var factors = []
    for (var div = 1; div < term + 1; ++div) {
        if (getGoal() % div == 0) {
            factors.push(div)
        }
    }
    var term1 = factors[Math.floor(Math.random() * factors.length)]
    var term2 = Math.floor(term / term1);

    if (Math.random() < 0.5) {
        return [term1, term2]
    } else {
        return [term2, term1]
    }
}


function splitPlusNumber(term) {
    // Check if the term is odd
    var odd = term % 2

    var term1 = Math.floor(term / 2)
    var term2 = term1 + odd

    // Shift randomly the terms
    var shift = Math.floor((Math.random() * term1))
    term1 += shift
    term2 -= shift

    // Switch randomly the terms
    if (Math.random() < 0.5) {
        return [term1, term2]
    } else {
        return [term2, term1]
    }
}

function splitMinusNumber(term) {
    var term1 = term
    var term2 = 0

    // Shift randomly the terms
    var shift = Math.floor((Math.random() * (term + 1)))
    term1 += shift
    term2 += shift

    return [term1, term2]
}

function genPosition(direction, cellWidth, cellHeight) {
    var randomNumber = Math.floor(Math.random() * 5)

    if (direction == 0) {
        return [6 * randomNumber, 0, cellHeight * randomNumber]
    } else if (direction == 2) {
        return [randomNumber, cellWidth * randomNumber, 0]
    } else if (direction == 1) {
        return [6 * randomNumber + 5, cellWidth * 5, cellHeight * randomNumber]
    } else if (direction == 3) {
        return [30 + randomNumber, cellWidth * randomNumber, cellHeight * 5]
    }
}

function genMonster() {
    var monsters = ["Reggie", "Diaper", "Eater", "Fraidy", "Smarty", "Reggie"]
    var allowedMonsters = items.currentLevel % 7
    return monsters[Math.floor(Math.random()*allowedMonsters)]
}

function fillAllGrid() {
    modelCells.clear()
    if (type == "equality" || type == "inequality") {
        for (var it = 0; it < 36; it++) {
            var terms
            if (operator === " + ") {
                terms = splitPlusNumber(
                            genNumber())
            } else if (operator === " - ") {
                terms = splitMinusNumber(
                            genNumber())
            } else if(operator === " * ") {
                terms = splitMultiplicationNumber(
                            genNumber())
            } else if(operator === " / ") {
                terms = splitDivisionNumber(
                            genNumber())
            }

            modelCells.append({
                                   number1: terms[0],
                                   number2: terms[1],
                                   show: true
                               })
        }
    } else if (type == "primes") {
        for (var it = 0; it < 36; it++) {
            modelCells.append({"number1": genPrime(), "number2": -1, "show": true});
        }
    } else if (type == "factors") {
        for (var it = 0; it < 36; it++) {
            modelCells.append({"number1": genFactor(), "number2": -1, "show": true});
        }
    } else if (type == "multiples") {
        for (var it = 0; it < 36; it++) {
            modelCells.append({"number1": genMultiple(), "number2": -1, "show": true});
        }
    }
}

function isExpressionEqualsToGoal(position){
    if (operator === " + ") {
        if ((modelCells.get(position).number1 + modelCells.get(
                 position).number2) == (getGoal())) {
            return true
        } else {
            return false
        }
    } else if (operator === " - ") {
        if ((modelCells.get(position).number1 - modelCells.get(
                 position).number2) == (getGoal())) {
            return true
        } else {
            return false
        }
    } else if (operator === " * ") {
        if ((modelCells.get(position).number1 * modelCells.get(
                 position).number2) === (getGoal())) {
            return true
        } else {
            return false
        }
    } else if (operator === " / ") {
        if ((modelCells.get(position).number1 / modelCells.get(
                 position).number2) === (getGoal())) {
            return true
        } else {
            return false
        }
    }
}

function isAnswerCorrect(position) {
    if (type === "equality") {
        return isExpressionEqualsToGoal(position)
    } else if (type === "inequality") {
        return (!isExpressionEqualsToGoal(position))
    } else if (type === "multiples") {
        if ((modelCells.get(position).number1 / getGoal()) % 1 == 0) {
            return true
        } else {
            return false
        }
    } else if (type === "factors") {
        if ((getGoal() / modelCells.get(position).number1) % 1 == 0) {
            return true
        } else {
            return false
        }
    } else if (type == "primes") {
        for (var it = 0; it < primeNumbers.length; ++it) {
            if (primeNumbers[it] == modelCells.get(position).number1)
                return true
        }
        return false
    }
}
