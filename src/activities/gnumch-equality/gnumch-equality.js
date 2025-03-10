/* GCompris - GnumchEquality.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var activityType;
var operator = ""
var useMultipleDataset;
var items;
var primeNumbers = [2, 3, 5, 7, 11, 13, 17, 19, 23];

function start(items_, activityType_, useMultipleDataset_) {
    items = items_;
    useMultipleDataset = useMultipleDataset_;
    activityType = activityType_;
    numberOfLevel = (useMultipleDataset) ? items.levels.length : 8;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    stopLevel();
}

function initLevel() {
    stopLevel();
    if(activityType === "equality" || activityType === "inequality") {
        operator = items.levels[items.currentLevel].operator;
    }
    else {
        operator = "";
    }
    items.goal = getGoal();
    items.life = true;
    fillAllGrid();

    if(useMultipleDataset) {
        if(items.levels[items.currentLevel].spawnMonsters) {
            items.withMonsters = true;
            items.spawningMonsters.restart();
        }
    }
    else if (items.currentLevel !== 0) {
        items.withMonsters = true;
        items.spawningMonsters.restart();
    }
    else {
        items.withMonsters = false;
    }
    items.muncher.init();
    items.muncher.caught = false;
    items.muncher.opacity = 1;
}

function stopLevel() {
    items.warning.opacity = 0;
    items.spawningMonsters.stop()
    items.timerActivateWarn.stop()
    destroyAllMonsters()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function getGoal() {
    var goal = 0;
    if(useMultipleDataset) {
        goal = items.levels[items.currentLevel].goal;
    }
    else {
        if(activityType == "multiples") {
            goal = items.currentLevel + 2;
        } else if(activityType == "factors") {
            var goalsFactor = [4, 6, 8, 10, 12, 15, 18, 20];
            goal = goalsFactor[items.currentLevel];
        } else if(activityType == "primes") {
            goal = primeNumbers[items.currentLevel + 1] + 1;
        }
    }
    return goal;
}

function genNumber() {
    if(Math.random() < 0.5) {
        // Choose a good number
        return (getGoal());
    } else {
        // Choose a bad number
        var sign = Math.random() - 0.5;
        sign = sign / Math.abs(sign);
        var number = getGoal() + (sign * Math.floor(((Math.random() * (getGoal() - 1)) + 1)));
        return number;
    }
}

function genMultiple() {
    var number = getGoal() * Math.floor(Math.random() * 6 + 1);
    if(Math.random() < 0.5) {
        // Choose a good number
        return number;
    } else {
        // Choose a bad number
        return number - 1;
    }
}

function genFactor() {
    var goodOnes = [];
    var badOnes = [];
    for(var div = 1; div < getGoal() + 1; ++div) {
        if(getGoal() % div == 0) {
            goodOnes.push(div);
        } else {
            badOnes.push(div);
        }
    }

    if(Math.random() < 0.5) {
        // Choose a good number
        return goodOnes[Math.floor(Math.random() * goodOnes.length)];
    } else {
        // Choose a bad number
        return badOnes[Math.floor(Math.random() * badOnes.length)];
    }
}

function genPrime() {
    var badNumbers = [1, 4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 22];
    if(Math.random() < 0.5) {
        // Choose a good number
        var goodOnes = [];
        for(var it = 0; it < primeNumbers.length; ++it) {
            if(getGoal() < primeNumbers[it]) {
                break;
            }
            goodOnes.push(primeNumbers[it]);
        }
        return goodOnes[Math.floor(Math.random() * goodOnes.length)];
    } else {
        // Choose a bad number
        var badOnes = [];
        for(var it = 0; it < badNumbers.length; ++it) {
            if(getGoal() < badNumbers[it]) {
                break;
            }
            badOnes.push(badNumbers[it]);
        }
        return badOnes[Math.floor(Math.random() * badOnes.length)];
    }
}

function genTime() {
    // generate a time in millisecond between 3,000 and 10,000
    var time = Math.floor(((Math.random() * 10) + 3)) * 1000;
    return time;
}

function splitDivisionNumber(term) {
    var term1 = term * Math.floor(Math.random() * 6 + 1);
    var term2 = term1 / term;

    return [term1, term2];
}

function splitMultiplicationNumber(term) {
    var factors = [];
    for(var div = 1; div < term + 1; ++div) {
        if(getGoal() % div == 0) {
            factors.push(div);
        }
    }
    var term1 = factors[Math.floor(Math.random() * factors.length)];
    var term2 = Math.floor(term / term1);

    if(Math.random() < 0.5) {
        return [term1, term2];
    } else {
        return [term2, term1];
    }
}


function splitPlusNumber(term) {
    // Check if the term is odd
    var odd = term % 2;

    var term1 = Math.floor(term / 2);
    var term2 = term1 + odd;

    // Shift randomly the terms
    var shift = Math.floor((Math.random() * term1));
    term1 += shift;
    term2 -= shift;

    // Switch randomly the terms
    if(Math.random() < 0.5) {
        return [term1, term2];
    } else {
        return [term2, term1];
    }
}

function splitMinusNumber(term) {
    var term1 = term;
    var term2 = 0;

    // Shift randomly the terms
    var shift = Math.floor((Math.random() * (term + 1)));
    term1 += shift;
    term2 += shift;

    return [term1, term2];
}

function genPosition(direction) {
    var randomNumber = Math.round(Math.random() * 5);

    if(direction == 0) {
        return randomNumber * 6;  // index on the left side
    } else if(direction == 2) {
        return randomNumber;  // index on the top side
    } else if(direction == 1) {
        return randomNumber * 6 + 5; // index on the right side
    } else if(direction == 3) {
        return 30 + randomNumber; // index on the bottom side
    }
}

function genMonster() {
    var monsters = ["Reggie", "Diaper", "Eater", "Fraidy", "Smarty", "Reggie"];
    var allowedMonsters = items.currentLevel % 7;
    return monsters[Math.floor(Math.random()*allowedMonsters)];
}

function fillAllGrid() {
    items.modelCells.clear();
    if(activityType == "equality" || activityType == "inequality") {
        for(var it = 0; it < 36; it++) {
            var terms;
            if(operator === " + ") {
                terms = splitPlusNumber(genNumber());
            } else if(operator === " - ") {
                terms = splitMinusNumber(genNumber());
            } else if(operator === " * ") {
                terms = splitMultiplicationNumber(genNumber());
            } else if(operator === " / ") {
                terms = splitDivisionNumber(genNumber());
            }

            items.modelCells.append({
                                   number1: terms[0],
                                   number2: terms[1],
                                   show: true
                               });
        }
    } else if(activityType == "primes") {
        for(var it = 0; it < 36; it++) {
            items.modelCells.append({"number1": genPrime(), "number2": -1, "show": true});
        }
    } else if(activityType == "factors") {
        for(var it = 0; it < 36; it++) {
            items.modelCells.append({"number1": genFactor(), "number2": -1, "show": true});
        }
    } else if(activityType == "multiples") {
        for(var it = 0; it < 36; it++) {
            items.modelCells.append({"number1": genMultiple(), "number2": -1, "show": true});
        }
    }
}

function isExpressionEqualsToGoal(position){
    if(operator === " + ") {
        if((items.modelCells.get(position).number1 + items.modelCells.get(
                 position).number2) == (getGoal())) {
            return true;
        } else {
            return false;
        }
    } else if(operator === " - ") {
        if ((items.modelCells.get(position).number1 - items.modelCells.get(
                 position).number2) == (getGoal())) {
            return true;
        } else {
            return false;
        }
    } else if(operator === " * ") {
        if((items.modelCells.get(position).number1 * items.modelCells.get(
                 position).number2) === (getGoal())) {
            return true;
        } else {
            return false;
        }
    } else if(operator === " / ") {
        if((items.modelCells.get(position).number1 / items.modelCells.get(
                 position).number2) === (getGoal())) {
            return true;
        } else {
            return false;
        }
    }
}

function checkAnswer() {
    if(!items.muncher.movable) {
        return;
    }

    // Case already discovered
    if (!items.modelCells.get(items.muncher.index).show) {
        return;
    }

    items.muncher.eating = true;
    items.eatSound.play();
    // Set the cell invisible if it's the correct answer.
    if (isAnswerCorrect(items.muncher.index)) {
        items.modelCells.get(items.muncher.index).show = false;
        if(items.gridPart.isLevelDone()) {
            stopLevel();
        }
    } else {
        items.modelCells.get(items.muncher.index).show = false;
        playerGotCaught(items.muncher.index);
    }
}

function isAnswerCorrect(position) {
    if(activityType === "equality") {
        return isExpressionEqualsToGoal(position);
    } else if(activityType === "inequality") {
        return (!isExpressionEqualsToGoal(position));
    } else if(activityType === "multiples") {
        if((items.modelCells.get(position).number1 / getGoal()) % 1 == 0) {
            return true;
        } else {
            return false;
        }
    } else if(activityType === "factors") {
        if((getGoal() / items.modelCells.get(position).number1) % 1 == 0) {
            return true;
        } else {
            return false;
        }
    } else if(activityType == "primes") {
        for(var it = 0; it < primeNumbers.length; ++it) {
            if(primeNumbers[it] == items.modelCells.get(position).number1)
                return true;
        }
        return false;
    }
}

function monsterCheckCell(monster_) {
    if(monster_.index === items.muncher.index && items.muncher.movable) {
        playerGotCaught(-1);
        monster_.eating = true;
        items.eatSound.play()
    }
    if(checkOtherMonster(monster_.index)) {
        monster_.eating = true;
    }
}

function playerGotCaught(index_) {
    if (!items.muncher.movable) {
        return;
    }
    items.muncher.caught = true;
    items.muncher.opacity = 0;
    items.warning.index = index_;
    items.warning.setFault(index_);
    items.warning.opacity = 1;
    items.spawningMonsters.stop();
    setMovableMonsters(false);
}

function hideWarning() {
    if(items.warning.opacity > 0) {
        items.warning.opacity = 0;
        if(items.life) {
            items.life = false;
            items.muncher.caught = false;
            items.muncher.opacity = 1;
            destroyAllMonsters();
            if(items.withMonsters) {
                items.spawningMonsters.restart();
            }
        }
        else {
            items.bonus.bad("gnu");
        }
    }
}


function setMovableMonsters(movable_) {
    var children = items.monsters.children
    for(var it = 0; it < children.length; it++) {
        children[it].movable = movable_
    }
}

function destroyAllMonsters() {
    var children = items.monsters.children
    for(var it = 0; it < children.length; it++) {
        children[it].destroy()
    }
}

function isThereAMonster(position_) {
    var children = items.monsters.children
    for(var it = 0; it < children.length; it++) {
        if(children[it].index === position_) {
            children[it].eating = true
            return true
        }
    }
    return false
}

function checkOtherMonster(position_) {
    var children = items.monsters.children
    var count = 0
    for(var it = 0; it < children.length; it++) {
        if (children[it].index === position_ && !children[it].movingOn) {
            count++
            if (count > 1) {
                children[it].opacity = 0
            }
        }
    }
}
