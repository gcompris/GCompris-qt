/* GCompris - GnumchEquality.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
.pragma library
.import QtQuick 2.6 as Quick

var _currentLevel = 0
var _numberOfLevel = 14
var _main
var _bar
var _bonus
var _type
var _operator
var _modelCells

function start(modelCells, bar, bonus, type, operator) {
    _bar = bar
    _bonus = bonus
    _currentLevel = 0
    _type = type
    _operator = operator
    _modelCells = modelCells
    if (type != "equality" && type != "inequality") {
        _numberOfLevel = 8
    }
}

function stop() {
}

function nextLevel() {
    if(_numberOfLevel <= ++_currentLevel ) {
        _currentLevel = 0
    }
}

function previousLevel() {
    if(--_currentLevel < 0) {
        _currentLevel = _numberOfLevel - 1
    }
}

function getGoal() {
    var goal
    if (_type == "equality" || _type == "inequality") {
        goal = _currentLevel + 6
        if (_currentLevel > 6) {
            goal = _currentLevel - 1
        }
    } else if (_type == "multiples") {
        goal = _currentLevel + 2
    } else if (_type == "factors") {
        var goalsFactor = [4, 6, 8, 10, 12, 15, 18, 20]
        goal = goalsFactor[_currentLevel]
    } else if (_type == "primes") {
        var primenumbers = [2, 3, 5, 7, 11, 13, 17, 19, 23]
        goal = primenumbers[_currentLevel + 1] + 1
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
    var primenumbers = [2, 3, 5, 7, 11, 13, 17, 19, 23]
    var badNumbers = [1, 4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 22]
    if (Math.random() < 0.5) {
        // Choose a good number
        var goodOnes = []
        for (var it = 0; it < primenumbers.length; ++it) {
            if (getGoal() < primenumbers[it])
                break

            goodOnes.push(primenumbers[it])
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
    var allowedMonsters = _currentLevel % 7
    return monsters[Math.floor(Math.random()*allowedMonsters)]
}

function fillAllGrid() {
    _modelCells.clear()
    if (_type == "equality" || _type == "inequality") {
        for (var it = 0; it < 36; it++) {
            var terms
            if (_operator == " + ") {
                terms = splitPlusNumber(
                            genNumber())
            } else {
                terms = splitMinusNumber(
                            genNumber())
            }

            _modelCells.append({
                                  number1: terms[0],
                                  number2: terms[1],
                                  show: true
                              })
        }
    } else if (_type == "primes") {
        for (var it = 0; it < 36; it++) {
            _modelCells.append({"number1": genPrime(), "number2": -1, "show": true});
        }
    } else if (_type == "factors") {
        for (var it = 0; it < 36; it++) {
            _modelCells.append({"number1": genFactor(), "number2": -1, "show": true});
        }
    } else if (_type == "multiples") {
        for (var it = 0; it < 36; it++) {
            _modelCells.append({"number1": genMultiple(), "number2": -1, "show": true});
        }
    }
}

function isAnswerCorrect(position) {
    if (_type == "equality") {
        if (_operator == " + ") {
            if ((_modelCells.get(position).number1 + _modelCells.get(
                     position).number2) == (getGoal())) {
                return true
            } else {
                return false
            }
        } else {
            if ((_modelCells.get(position).number1 - _modelCells.get(
                     position).number2) == (getGoal())) {
                return true
            } else {
                return false
            }
        }
    } else if (_type == "inequality") {
        if (_operator == " + ") {
            if ((_modelCells.get(position).number1 + _modelCells.get(
                     position).number2) != (getGoal())) {
                return true
            } else {
                return false
            }
        } else {
            if ((_modelCells.get(position).number1 - _modelCells.get(
                     position).number2) != (getGoal())) {
                return true
            } else {
                return false
            }
        }
    } else if (_type == "multiples") {
        if ((_modelCells.get(position).number1 / getGoal()) % 1 == 0) {
            return true
        } else {
            return false
        }
    } else if (_type == "factors") {
        if ((getGoal() / _modelCells.get(position).number1) % 1 == 0) {
            return true
        } else {
            return false
        }
    } else if (_type == "primes") {
        var primenumbers = [2, 3, 5, 7, 11, 13, 17, 19]
        for (var it = 0; it < 8; ++it) {
            if (primenumbers[it] == _modelCells.get(position).number1)
                return true
        }
        return false
    }
}
