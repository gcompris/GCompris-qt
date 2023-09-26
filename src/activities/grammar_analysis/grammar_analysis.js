/* GCompris - grammar_analysis.js
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

// Punctuation includes symbols for all writing systems
const punctuation = "\\,|\\.|:|!|¡|;|\\?|¿|\\\"|«|»|“|”|„|؟|،|。|，|：|？|！|>|<|&|#|=|\\*"

const dataUrl = "qrc:/gcompris/src/activities/grammar_analysis/resource/"
const svgUrl = dataUrl + "svg/"
const defaultLevelsFile = "en";

var dataSetUrl = ""
var syntaxList = []

var numberOfLevel
var grammarMode
var translationMode
var items
var datas = null                // Contains parsed grammar-lang.json file
var goalArray = []
var boxCount = 0                // Total boxes for current sentence (a box is an expected grammatical class)
var animRunning = false

var tutorialInstructions = {
    "_analysis" : [
        {
            "instruction": "<b>" + qsTr("Grammatical analysis") + "</b><br><br>" +
                           qsTr("Learn to identify grammatical classes.") + ("<br>") +
                           qsTr("Find all the words corresponding to the requested grammatical classes.") + ("<br>") +
                           qsTr("Select a grammatical class from the list, then select the box under a word and assign it the class.") + ("<br>") +
                           qsTr("Leave the box blank if no class matches."),
            "instructionQml": ""
        }
    ],
    "_classes" : [
        {
            "instruction": "<b>" + qsTr("Grammatical classes") + "</b><br><br>" +
                           qsTr("Learn to identify grammatical classes.") + "<br>" +
                           qsTr("Find all the words corresponding to the requested grammatical class.") + ("<br>") +
                           qsTr("Select the grammatical class from the list, then select the box under a word and assign it the class.") + ("<br>") +
                           qsTr("Leave the box blank if the class doesn't match."),
            "instructionQml": ""
        }
    ]
}

// Try to read a grammar file
function checkFileName(fileName) {
    datas = items.jsonParser.parseFromUrl(fileName)
    if (datas === null) {
        console.warn("Grammar_analysis: Invalid data file " + fileName);
        return ""
    }
    return fileName         // returns a fileName if datas are valid
}

// Build a file name with locale, try to read it
function checkFile(locale) {
    return checkFileName(GCompris.ApplicationInfo.getLocaleFilePath(dataSetUrl + "grammar" + grammarMode + "-" + locale + ".json"))
}

function loadDatas() {
    datas = null
    // Reset models, objective and goal
    items.syntaxModel.clear()
    items.datasetModel.clear()
    items.goalModel.clear()
    items.answerModel.clear()
    items.objective.text = ""
    goalArray = []
    //--- Reset debug informations
    items.goalStr = ""
    items.phrase.text = ""
    items.response.text = ""
    items.inspector.message = ""
    //--- End debug informations

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    var fileName = "file://" + GCompris.ApplicationSettings.userDataPath + "/grammar" + grammarMode + "-xx.json"    // Translator file
    if (items.file.exists(fileName)) {  // Load translator file if exists. Even with errors.
        datas = items.jsonParser.parseFromUrl(fileName)
    } else {                            // Check for a valid file name, datas are loaded in checkFile
        fileName = checkFile(locale);
        if (fileName === "") fileName = checkFile(defaultLevelsFile)    // Try default file
    }

    items.locale = locale
    items.translationFile = fileName.split('/').reverse()[0]            // Extract basename for debug infos
    var dataErrors = []
    if (datas !== null) {                                               // Check datas main keys. Stop if something is missing
        if (!datas.hasOwnProperty('levels')) dataErrors.push('levels missing')
        if (!datas.hasOwnProperty('dataset')) dataErrors.push('dataset missing')
        if (!datas.hasOwnProperty("syntax")) dataErrors.push('syntax missing')
        if (dataErrors.length) {
            items.errors.text = 'Error in file: ' +fileName + '\n' + dataErrors.join("\n")
            datas = null
        }
    }
    // Values loaded once and stored to avoid multiple calls
    datas.needSpaces = Core.localeNeedSpaces(items.locale)
    datas.rightToLeft = Core.isLeftToRightLocale(items.locale)
}

function start(items_, grammarMode_, translationMode_) {
    items = items_
    grammarMode = grammarMode_
    translationMode = translationMode_
    dataSetUrl = "qrc:/gcompris/src/activities/grammar" + grammarMode + "/resource/"
    numberOfLevel = 0
    items.currentExercise = 0
    loadDatas();
    if (datas === null) return

    checkLevels()
    numberOfLevel = datas["levels"].length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.wordsFlow.layoutDirection = (datas.rightToLeft) ? Qt.LeftToRight : Qt.RightToLeft
    initSyntax()
    initExercises()
    initLevel()
}

function stop() {}

// Check each level for valid exercises. Remove empty levels
function checkLevels() {
    var level = 0
    while (level < datas["levels"].length) {
        var oneGood = false
        var exercises = datas.dataset[datas["levels"][level].exercise];
        for (var i = 0; i < exercises.length ; i++) {
            var parsed = analyzeExercise(level, exercises[i])
            if (checkExercise(parsed, translationMode)) {
                oneGood = true
            }
        }
        if (oneGood) {      // keep this level
            level++
        } else {            // remove this level
            datas["levels"].splice(level, 1)
        }
    }
}

// Check if exercise fits goal (translators should see something)
function checkExercise(parsed, force = false) {
    if (force) return true          // Translators should see all datasets with an error message.
    var usedClasses = []            // contains single and merged classes
    for (var k = 0; k < parsed.classes.length; k++) {
        usedClasses = usedClasses.concat(parsed.classes[k].split(/\+/))
    }
    var j
    var isValid = false
    for (j = 0; j < goalArray.length; j++) {    // At least one goal's class must be present
        isValid |= (usedClasses.indexOf(goalArray[j]) !== -1)
    }
    parsed.isValid = isValid
    return isValid
}

// Load dataset model for current level
// Keep only valid exercises except for translators
function initExercises() {
    if (datas === null) return
    if (grammarMode === '_classes') {
        // Garder le premier
    }
    items.datasetModel.clear()
    var exercises = datas.dataset[datas["levels"][items.currentLevel].exercise];
    for (var i = 0; i < exercises.length ; i++) {
        var parsed = analyzeExercise(items.currentLevel, exercises[i])
        if (checkExercise(parsed, translationMode)) {
            items.datasetModel.append({ "exercise" : exercises[i] })
        }
    }
    if (items.datasetModel.count === 0) {
        nextLevel()
    }
    if (!translationMode)
        items.datasetModel.shuffleModel()
}

// Load writing system's syntax
function initSyntax() {
    items.syntaxModel.clear()
    for (var i = 0; i < datas.syntax.length ; i++) {
        items.syntaxModel.append(
                    {
                        "code" : datas.syntax[i].code,
                        "wordClass" : datas.syntax[i].wordClass,
                        "image" : datas.syntax[i].image
                    })
    }
    syntaxList = toArrayKeys(items.syntaxModel, "code")
}

function initLevel() {
    items.selectedClass = 0
    items.selectedBox = 0
    items.keysOnTokens = true
    if (datas === null) return
    buildAnswer()
}

function nextLevel() {
    items.currentExercise = 0
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initExercises()
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    if (datas === null) return
    items.currentExercise = 0
    initExercises()
    initLevel();
}

function nextSubLevel() {
    if( ++items.currentExercise >= items.datasetModel.count) {
        items.currentExercise = 0;
        nextLevel();
    }
    initLevel();
}

function previousSubLevel() {
    if( --items.currentExercise < 0) {
        items.currentExercise = 0;
        previousLevel();
    }
    initLevel();
}

function checkResult() {
    var ok = true
    for (var i = 0; i < items.rowAnswer.count; i++) {
        var wordCard = items.rowAnswer.itemAt(i)
        if (wordCard.expected !== "")
            ok &= (wordCard.expected === wordCard.proposition)
    }
    if (ok) items.bonus.good("sun")
    else {
        items.bonus.bad("sun")
    }
}

// builds an array with the model's propertyName (indexOf will give an index in the model)
function toArrayKeys(model, propertyName) {
    var arr = []
    for (var i = 0; i < model.count; i++)
        arr.push(model.get(i)[propertyName])
    return arr
}

function handleKeys(event) {
    if (animRunning) return         // No key during animation
    if ((event.modifiers & Qt.AltModifier) && translationMode) {
        switch (event.key) {        // sublevel navigation in translation mode
        case Qt.Key_Left:
            previousSubLevel()
            break
        case Qt.Key_Right:
            nextSubLevel()
            break
        case Qt.Key_Return:         // Switch visibility of infoView and inspector with Ctrl+Alt+Enter
            if (event.modifiers & Qt.ControlModifier) {
                items.debugActive = !items.debugActive
            }
            break
        }
    } else {
        switch (event.key) {
        case Qt.Key_Left:
            items.keyboardNavigation = true
            if (items.keysOnTokens)
                items.selectedClass = (items.selectedClass + items.goalModel.count - 1) % items.goalModel.count
            else
                items.selectedBox = (items.selectedBox + boxCount -1) % boxCount
            break
        case Qt.Key_Right:
            items.keyboardNavigation = true
            if (items.keysOnTokens)
                items.selectedClass = (items.selectedClass + 1) % items.goalModel.count
            else
                items.selectedBox = (items.selectedBox +1) % boxCount
            break
        case Qt.Key_Up:
        case Qt.Key_Down:
        case Qt.Key_Tab:
            items.keyboardNavigation = true
            items.keysOnTokens = !items.keysOnTokens
            break
        case Qt.Key_Backspace:
            items.keyboardNavigation = true
            items.selectedBox = (items.selectedBox + boxCount - 1) % boxCount
            break
        case Qt.Key_Enter:
        case Qt.Key_Return:
            if (items.okButton.visible)
                checkResult()
            break
        case Qt.Key_Space:
            items.keyboardNavigation = true
            var pos = items.boxIndexes[items.selectedBox].split('-')
            items.wordsFlow.children[pos[0]].setProposal(pos[1])
            break
        default :
            break
        }
    }
}

// Build datas for answerModel
function buildAnswer() {
    var parsed = analyzeExercise(items.currentLevel, items.datasetModel.get(items.currentExercise).exercise)
    checkExercise(parsed)       // Add isValid flag
    items.objective.text = datas["levels"][items.currentLevel].objective
    var idx = 0
    var word
    // Update answerModel
    items.answerModel.clear()
    if (parsed.errors === "") {
        // Check for space and/or punctuation before first word, extract and insert
        if (parsed.indexes[0] > 0) {
            word = parsed.cleaned.slice(0, parsed.indexes[0])           // Cut string before first word
            if (datas.needSpaces || (word !== ' '))                     // Test for writing systems with no spaces
                items.answerModel.append(                               // Append space or/and punctuation
                            {  'code': '',
                               'svg': '',
                               'word': word,
                               'prop': ''
                            })
        }
        boxCount = 0
        items.boxIndexes = []
        for (var i = 0 ; i < parsed.classes.length ; i ++) {                   // Loop on classes (or words)
            var classList = parsed.classes[i].split(/\+/)               // Split merged classes
            var wordCodes = []
            var bCount = boxCount
            for (var j = 0; j < classList.length; j++) {                // Loop on merged classes
                idx = syntaxList.indexOf(classList[j])                  // Find index for this class
                if (idx !== -1) {                                       // Check if it's a know class
                    if (goalArray.includes(datas.syntax[idx].code)) {   // Check if it's an expected class
                        wordCodes.push(datas.syntax[idx].code)          // Push grammar class
                        items.boxIndexes.push((items.answerModel.count) + "-" + j)
                        boxCount++
                    } else {
                        wordCodes.push("_")                             // Box is shown but should be empty
                        items.boxIndexes.push((items.answerModel.count) + "-" + j)
                        boxCount++
                    }
                }
            }
            items.answerModel.append({'code': wordCodes.join('+'), 'svg': '', 'word': parsed.words[i], 'prop' : '', 'startCount': bCount })

            // Check for space and/or punctuation between words, extract and insert
            var limit = (i < parsed.words.length - 1 ) ? parsed.indexes[i+1] : parsed.cleaned.length    // Expected word end
            if (parsed.indexes[i] + parsed.words[i].length < limit) {                                   // If the next word is further
                word = parsed.cleaned.slice(parsed.indexes[i] + parsed.words[i].length, limit)          // Cut string between words
                if (datas.needSpaces || (word !== ' '))                                                 // Test for writing systems with no spaces
                    items.answerModel.append(
                                {   'code': '',
                                    'svg': '',
                                    'word': word,
                                    'prop': ''
                                })        // Append space or/and punctuation
            }
        }
    }
    // Check goal's syntax
    var k
    for (k = 0; k < goalArray.length; k++) {
        if (!syntaxList.includes(goalArray[k]))
            parsed.errors += "Unknown goal code : " + goalArray[k] +"<br>"
    }
    // Update goalModel
    items.goalModel.clear()
    for (k = 0; k < syntaxList.length ; k++) {                          // Loop on syntax order
        if (goalArray.includes(syntaxList[k])) {                        // If class found in goal
            items.goalModel.append(
                        {   'code': datas.syntax[k].code,
                            'wordClass': datas.syntax[k].wordClass,
                            'image': svgUrl + datas.syntax[k].image
                        })
        }
    }
    items.goalModel.append(
                {   'code': "eraser",
                    'wordClass': qsTr("Empty"),
                    'image': 'qrc:/gcompris/src/core/resource/cancel.svg'
                })        // Add erase button
    // Display errors found
    items.errors.text = (parsed.errors === "") ? "" : "<b>Error(s) :</b><br>" + parsed.errors
    if (!parsed.isValid) {
        items.errors.text += "At least one goal class must be present"
    }

    //--- Update debugging informations
    items.phrase.text = items.datasetModel.get(items.currentExercise).exercise.sentence
    items.response.text = items.datasetModel.get(items.currentExercise).exercise.answer
    items.inspector.message = JSON.stringify(parsed, null, 4)
    //--- End debug informations
}

// Analyze an exercise. Store splitted parts and computed parts in an object
function analyzeExercise(level, exercise) {
    var parsed = {}                                                             // Object container for parsed segments
    parsed.sentence = exercise.sentence.replace(/\s+/,' ').trim()               // Trim multiple spaces
    parsed.answer = exercise.answer.replace(/\s+/,' ').trim()                   // Trim multiple spaces
    parsed.cleaned = parsed.sentence.replace(/\(|\)/g,'')                       // Delete parentheses to get a cleaned string
    parsed.classes = parsed.answer.replace(/  +/g, ' ').split(/ /)              // Clear multiple spaces and extract classes

    var tempStr = parsed.sentence                                               // Work in a temporary string
    tempStr = tempStr.replace(/([\\'|’])/g,"$1 ")                               // Single quote as word delimiter
    var parentheses = tempStr.match(/\([^\(\)]+\)/g)                            // Extract parentheses blocks in an array
    var regex = new RegExp(punctuation, "g");                                   // Build regular expression with punctuation
    tempStr = tempStr.replace(regex,' ')                                        // Punctuation is replaced by spaces
    tempStr = tempStr.replace(/ +/g, ' ').trim()                                // Clear multiple spaces
    tempStr = tempStr.replace(/\([^\(\)]+\)/g,"\t")                             // Replace parentheses blocks with a tabulation char
    parsed.words = tempStr.split(/ /)                                           // Cleared string can be splitted now
    if (parentheses !== null) {
        var idx = 0
        for (var i=0; i<parsed.words.length ; i++) {
            if (parsed.words[i] === "\t") {                                     // Restore parentheses blocks when tabulation char found
                parsed.words[i] = parentheses[idx++].replace(/\(|\)/g,'')       // Eliminate parentheses
            }
        }
    }

    // Calculate position for each word in the cleaned string
    parsed.indexes = Array()
    var strPosition = 0
    var numWord = 0
    while (numWord < parsed.words.length) {
        var strPos = parsed.cleaned.indexOf(parsed.words[numWord], strPosition) // Find position of current word
        parsed.indexes.push(strPos)                                             // Save position in indexes array
        strPosition = strPos + parsed.words[numWord].length                     // Move to next start position
        numWord++
    }

    // Test if no spaces required
    if (datas.needSpaces) {
        tempStr = tempStr.replace(/ */g, '')                                    // Clear all spaces
    }

    // Syntax check
    parsed.errors = ""
    if (parsed.words.length !== parsed.classes.length)                         // Check words and classes count
        parsed.errors += parsed.words.length + " classes expected, "+ parsed.classes.length + " found.<br>"
    for (numWord=0; numWord<Math.min(parsed.words.length, parsed.classes.length); numWord++) {
        var classList = parsed.classes[numWord].split(/\+/)                    // Split merged classes
        for (var j = 0; j < classList.length; j++) {                           // Loop on merged classes
            if (!syntaxList.includes(classList[j]))                            // Check if it's a known class
                parsed.errors += "Unknown code : " + classList[j] +"<br>"
        }
    }
    goalArray = datas["levels"][level].goal.split(/ /)            // Create an array of expected classes
    if (grammarMode === '_classes') {
        goalArray = goalArray.slice(0,1)                          // Keep only first goal for _classes
    }
    items.goalStr = goalArray.join(' ')     // Debug display
    return parsed
}
