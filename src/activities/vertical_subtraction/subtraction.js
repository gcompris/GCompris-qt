/* GCompris - subtraction.js
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 4
var items

var values = []
var operators = []
var mapToPad = {}       // Maps keyboard charcodes to numPad's indexes to animate graphics from computer's numpad
var operationString = ""
var level       // Contains current level "data" from Data.qml

function start(items_) {
    items = items_
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.miniPad.close()
    items.numPad.close()
}

function randInt(max) { return Math.floor(Math.random() * max) }

function countDigits(x) {
    return Math.max(Math.floor(Math.log10(Math.abs(x))), 0) + 1
}

function calcDigitCount() {
    var max = 0
    for (var i = 0; i < values.length; i++) {
        max = Math.max(max, countDigits(values[i]))
    }
    return max
}

function buildNumbersModel() {
    items.numbersModel.clear()
    items.board.digitCount = Math.max(items.nbDigits, calcDigitCount(values))
    if(items.operation === items.operationType.Addition) {
        items.board.digitCount += 1     // add 1 slot for additions as the final sum can have one more digit
    }
    operationString = ""
    var result = values[0]
    for (var i = 0; i < values.length; i++) {
        items.numbersModel.append({ "value_" :  values[i]
                                  , "digitCount_" : items.board.digitCount
                                  , "operator_" : operators[i]
                                  })
        operationString += i ? ` ${operators[i]} ${values[i]}` : values[i]
        if (i > 0) {
            result += (operators[i] === "+") ? values[i] : -values[i]
        }
    }
    items.board.result = result
    items.resultNumber.numberValue = ""
    if (level.doItYourself) {
        items.caption.text = level.title
    } else {
        items.caption.text = (!items.alreadyLaid ? qsTr("Write:") : qsTr("Solve:")) + " " + operationString
    }
}

function valuesToSubtraction() {
    if (items.operation === items.operationType.Subtraction) {
        for (var i = 1; i < items.nbLines; i++) {
            if (operators[i] === "-")
                values[0] += values[i]
        }
    } else {    // addition, order values from biggest to smallest
        values.sort(function(a, b){return b - a})
    }
}

function randomValues() {
    values = []
    operators = []
    for (var i = 0; i < items.nbLines; i++) {
        values.push(level.doItYourself ? -1 :randInt(Math.pow(10, items.nbDigits)))
        operators.push((items.operation === items.operationType.Addition) ? "+" : "-")
    }
    valuesToSubtraction()
}

function distributedRandom() {
    var distribution = {
        2: { count: 45,  distrib: [1,2,3,4,5,6,7,8,9] },
        3: { count: 165, distrib: [1,3,6,10,15,21,28,36,45] },
        4: { count: 495, distrib: [1,4,10,20,35,56,84,120,165] }
    }
    var rand = randInt(distribution[items.nbLines].count)
    var idx = 0
    var sum = 0
    while (rand > sum) {
        sum += distribution[items.nbLines].distrib[idx]
        idx++
    }
    return idx
}

function withoutCarryValues() {
    values = []
    operators = []
    var textValues = Array(items.nbLines).fill("")
    for (var i = 0; i < items.nbDigits; i++) {
        var sum = distributedRandom()
        for (var j = 0; j < items.nbLines; j++) {
            var digit = (j !== items.nbLines - 1) ? randInt(sum) : sum
            textValues[j] = String(digit) + textValues[j]
            sum -= digit
        }
    }

    // Copy to values
    for (j = 0; j < items.nbLines; j++) {
        values.push(Number(textValues[j]))
        operators.push((items.operation === items.operationType.Addition) ? "+" : "-")
    }
    valuesToSubtraction()
}

function checkDropped() {
    if(items.inputLocked) {
        return
    }
    items.inputLocked = true
    var ok = true
    if (level.doItYourself) {
        for (var i = 0; i < items.numbersModel.count; i++)      // Copy value to expected
            items.numberRepeater.itemAt(i).copyDroppedValues()
        for (i = 0; i < items.numbersModel.count; i++)          // Check for valid lines
            ok = ok && items.numberRepeater.itemAt(i).checkEmptyDigit()
        if (ok) {
            var result = 0
            for (i = 0; i < items.numbersModel.count; i++) {    // Build the new numberValue (from dropped numbers)
                items.numberRepeater.itemAt(i).toNumberValue()
                var value = Number(items.numberRepeater.itemAt(i).numberValue)
                if (items.numberRepeater.itemAt(i).numberValue !== "0")
                    result += (((i === 0) || (items.operation === items.operationType.Addition)) ? 1 : -1) * value
            }
            items.board.result = result
            if (result < 0)
                ok = false
        }
    } else {
        for (i = 0; i < items.numbersModel.count; i++)          // Check for valid lines
            ok = ok && items.numberRepeater.itemAt(i).checkEmptyDigit()
        for (i = 0; i < items.numbersModel.count; i++)          // Check if value is the one expected
            ok = ok && items.numberRepeater.itemAt(i).checkDroppedValues()
    }
    if (ok) {
        for (i = 0; i < items.numbersModel.count; i++) {
            items.numberRepeater.itemAt(i).flipDroppable(false) // Disable droppable digits
            items.numberRepeater.itemAt(i).clearEmptyDigit()    // Clear unrequired zeros
        }
        if (!level.doItYourself)
            //: Solve (= Find the result of): %1 (= the operation to solve)
            items.caption.text = qsTr("Solve: %1").arg(operationString)
        items.okButton.visible = true
        items.inputLocked = false
    } else {
        items.errorRectangle.startAnimation();
        items.crashSound.play()
    }
}

function checkResult() {
    items.inputLocked = true
    var sums = Array(items.board.digitCount).fill(0)        // sums in an array [ unit, ten, hundred, ...]. 123 => [ 3, 2, 1 ]
    for (var j = 0; j < items.board.digitCount; j++) {      // Build sums with first number
        sums[j] = items.numberRepeater.itemAt(0).digitRepeater.itemAt(j).computedValue
    }
    for (var i = 1; i < items.numberRepeater.count; i++) {  // Compute each number
        var number = items.numberRepeater.itemAt(i)
        for (j = 0; j < number.digitRepeater.count; j++) {  // Add or subtract each digit
            if (items.operation === items.operationType.Addition)
                sums[j] += number.digitRepeater.itemAt(j).computedValue
            else
                sums[j] -= number.digitRepeater.itemAt(j).computedValue
        }
    }
    var ok = true
    var zeros = true
    for (j = 0; j < items.resultNumber.digitRepeater.count; j++) {      // Compare each sums digit with answer digit from units to tens, hundreds
        sums[j] = sums[j] % 10
        var item = items.resultNumber.digitRepeater.itemAt(j)
        ok = ok && (sums[j] === item.computedValue)                     // Same digit ?
        ok = ok && (zeros || (item.value === -1))                       // Accept empty digit while first non zero value is not detected
        if (item.value === -1)                                          // Detect first non zero value. After empty digit are not allowed
            zeros = false
    }
    if (ok) {
        items.currentSubLevel++
        items.score.playWinAnimation()
        items.completeTaskSound.play()
    } else {
        items.errorRectangle.startAnimation()
        items.crashSound.play()
    }
}

function initLevel() {
    items.errorRectangle.resetState()
    level = items.levels[items.currentLevel]
    if (!level.hasOwnProperty("doItYourself"))
        level.doItYourself = false
    items.subLevelCount = level.nbSubLevel
    items.nbLines = level.nbLines
    items.nbDigits= level.nbDigits
    items.withCarry= level.withCarry
    items.alreadyLaid= level.alreadyLaid
    if (items.withCarry)
        randomValues()
    else
        withoutCarryValues()

    buildNumbersModel()
    items.resultNumber.numberValue = "0"
    items.okButton.visible = items.alreadyLaid ? true : false
    items.inputLocked = false
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextSubLevel() {
    if (items.currentSubLevel >= level.nbSubLevel)
        items.bonus.good("flower")
    else
        initLevel()
}

function handleKeys(key) {
    switch (key) {
    case Qt.Key_Return:
    case Qt.Key_Enter:
        if (items.okButton.visible)
            checkResult()
        else
            checkDropped()
        break
    }
}
