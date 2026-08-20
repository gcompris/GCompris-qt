.pragma library
    .import QtQuick 2.12 as Quick
        .import "qrc:/gcompris/src/core/core.js" as Core

// --- Variables globales ---
var numberOfLevel = 4
var items
var linesFlowsArray = []
var interactiveFieldsArray = []
var interactiveFieldsExercicesArray = []
var exerciceIndex = 0
var scoreElementArray = []
var exerciceType = ""
var enumerationMarksEnabled = false

var regularLinePadding = 40
var headingLinePadding = 40
var verticalMcqButtonHeight = 40


const alphabetArray = 'abcdefghijklmnopqrstuvwxyz'.split('');
const defaultFontSize = 17

var lineIndexWithVert = 0

// --- Composants QML ---
var components = {}
function loadComponents() {
    components = {
        fillInGap: Qt.createComponent("FillInGap.qml"),
        qcmDropDown: Qt.createComponent("QcmDropDown.qml"),
        qcmHorizontalItems: Qt.createComponent("QcmHorizontalItems.qml"),
        qcmVerticalItems: Qt.createComponent("QcmVerticalItems.qml"),
        displayText: Qt.createComponent("DisplayText.qml"),
        flow: Qt.createComponent("RealViewFlow.qml"),       
        circularIcon: Qt.createComponent("CircularNumberedIcon.qml"),
        successFail: Qt.createComponent("SuccessFailMark.qml"),
        enumerationMarker: Qt.createComponent("EnumerationMarker.qml")
    }
}

// --- Cycle de vie ---
function start(items_) {
    items = items_;
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    loadComponents()
    initLevel()
}

function stop() { }

function initLevel() {
    // à compléter selon logique du jeu
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    initLevel()
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel)
    initLevel()
}

// --- Main functions ---
function convertSourceTextToApp() {

    if (!items || !items.textAreaInput) {
        return;
    }

    resetSession()
    const lines = splitTextIntoLines(items.textAreaInput.text)
    createFlows(lines)
    lines.forEach(processLine)
    enumerationMarksEnabled = false
    initialiseScores()
}

function checkAnswers() {
    interactiveFieldsExercicesArray.forEach((exerciceFields, i) => {
        let valid = 0
        exerciceFields.forEach(fieldObj => {
            const [type, field] = Object.entries(fieldObj)[0]
            console.log("un test: " + type)
            if (type === "qcmVerticalItems") {
                let goodAnswers = field.userSelections.length === field.verticalQcmOriginalContentArray.length;
                if (goodAnswers) {
                   for (var i = 0; i < field.userSelections.length; i++) {
                       var isSelected = field.userSelections[i];
                       var startsWithStar = (field.verticalQcmOriginalContentArray[i] || "").startsWith("*");
                       if (isSelected !== startsWithStar) {
                           goodAnswers = false;
                           break;
                       }
                   }
                }
                if (goodAnswers) {
                    field.resultMarkStatus = "success"
                    valid++
                } else {
                    field.resultMarkStatus = "failure"
                }
            } else if (type === "qcmHorizontalItems") {
                let goodAnswers = field.userSelections.length === field.horizontalQcmOriginalContentArray.length;
                if (goodAnswers) {
                  for (var i = 0; i < field.userSelections.length; i++) {
                      var isSelected = field.userSelections[i];
                      var startsWithStar = (field.horizontalQcmOriginalContentArray[i] || "").startsWith("*");
                      if (isSelected !== startsWithStar) {
                          goodAnswers = false;
                          break;
                      }
                  }
                }
                if (goodAnswers) {
                   field.resultMarkStatus = "success"
                   valid++
                } else {
                   field.resultMarkStatus = "failure"
                }
            } else if (type === "qcmDropDownItems") {
                if (field.comboboxOriginalContentArray[field.userAnswerIndex]?.startsWith("*")) {
                    field.resultMarkStatus = "success"
                    valid++
                } else {
                    field.resultMarkStatus = "failure"
                }
            } else if (type === "gap-fill") {
                field.resultMarkStatus = (field.defaultDisplayString === field.expectedAnswer)
                    ? "success" : "failure"
                if (field.resultMarkStatus === "success") valid++
            }
        })
        scoreElementArray[i].wordText = valid + "/" + exerciceFields.length
    })
}

// --- internal functions -----
function resetSession() {
    linesFlowsArray.forEach(f => f.destroy())
    linesFlowsArray = []
    interactiveFieldsExercicesArray = []
    scoreElementArray = []
    interactiveFieldsArray = []
    exerciceIndex = 0
}

function splitTextIntoLines(text) {
    return text.split("\n")
}

function createFlows(lines) {
    lines.forEach(() => {
        const flow = components.flow.createObject(items.flowsColumn)
        // flow.anchors.left = items.flowsColumn.left
        // flow.anchors.right = items.flowsColumn.right
        linesFlowsArray.push(flow)
    })
}

function processLine(line, lineIndex) {
    if (line.trim() === "") return
    if (line.startsWith("#set ")) return handleSetCommand(line, lineIndex)
    if (line.startsWith("#")) return handleHeading(line, lineIndex)
    if (line.startsWith("$")) return handleExerciseStatement(line, lineIndex)
    handleRegularLine(line, lineIndex)
}

// --- Custom Markdown command ---
function handleSetCommand(line, lineIndex) {
    const captured = line.match(/^#set (.*)$/)[1]
    if (captured.match(/^type_exercice\(([^(]+)\)$/)) {
        exerciceType = RegExp.$1
        return
    }
    if (captured.match(/^new_exercice/)) {
        exerciceIndex++
        return
    }
    if (captured.match(/^end_exercice/)) {
        interactiveFieldsExercicesArray.push(interactiveFieldsArray)
        interactiveFieldsArray = []
        return
    }
    if (captured.match(/^enumeration_marks/)) {
        enumerationMarksEnabled = true
        return
    }

    //find why pos is not used
    const match = captured.match(/^score\(([^)]+)\)$/)
    if (match) {
        //linesFlowsArray[lineIndex].alignEnd()  //TODO
        //linesFlowsArray[lineIndex].rightPadding = items.flowsColumn.width * 2 / 10  //TODO
        //console.log(items.flowsColumn.width)  //TODO

        // On récupère directement le groupe capturé via le tableau retourné par match()
        const pos = match[1]

        const score = components.displayText.createObject(linesFlowsArray[lineIndex], {
            fontPixelSize: 17,
            wordText: "5/7"
        })
        scoreElementArray.push(score)
        return
    }


}

// --- Handle the different line types ---
function handleHeading(line, lineIndex) {
    //linesFlowsArray[lineIndex].leftPadding = headingLinePadding todo

    const level = line.match(/^(#+)\s*(.*)$/)
    const text = level[2]
    const size = { 1: 24, 2: 22, 3: 19 }[level[1].length] || 17
    const bold = true
    addTextToFlow(lineIndex, text, size, bold)
}

function handleExerciseStatement(line, lineIndex) {
    const text = line.replace(/^\$\s*/, "")
    addCircularIconToFlow(lineIndex, exerciceIndex)
    addTextToFlow(lineIndex, text, 19, false, "navy")
}

function handleRegularLine(line, lineIndex) {
    //linesFlowsArray[lineIndex].leftPadding = regularLinePadding  //TODO
    const processed = line.replace(/\[(.*?)\]/g, (_, g1) => `[${g1.replace(/ /g, "※")}]`)
    const words = processed.split(" ")
    words.forEach(word => handleWord(word, lineIndex))
}

// --- Process each word ---
function handleWord(word, lineIndex) {
    const match = word.match(/(\S*?)\[([^\]]+)\](\S*)/)
    if (match) return createInteractiveField(match, lineIndex)
    addTextToFlow(lineIndex, word + " ", defaultFontSize)
}

function createInteractiveField(match, lineIndex) {
    const [, before, content, after] = match
    if (before) addTextToFlow(lineIndex, before, defaultFontSize)
    if (exerciceType === "horizontal-qcm") createHorizontalQcmField(content, lineIndex)
    if (exerciceType === "vertical-qcm") createVerticalQcmField(content, lineIndex)
    if (exerciceType === "gap-fill") createGapFillField(content, lineIndex)
    if (exerciceType === "dropdown-qcm") createQcmDropDownField(content, lineIndex)
    if (after) addTextToFlow(lineIndex, after, defaultFontSize)
    addTextToFlow(lineIndex, " ", defaultFontSize)
}

function createVerticalQcmField(content, lineIndex) {
    const answerOriginalPropositionsArray = content.split("|")
    const answerCleanedPropositionsdArray = answerOriginalPropositionsArray.map(a => a.replace(/^\*/, "").replace(/※/g, " "))
    const qcmVerticalItems = components.qcmVerticalItems.createObject(linesFlowsArray[lineIndex], {
        verticalQcmOriginalContentArray: answerOriginalPropositionsArray,
        verticalQcmContentArray: answerCleanedPropositionsdArray
    })
    interactiveFieldsArray.push({ qcmVerticalItems })
}

function createHorizontalQcmField(content, lineIndex) {
    const answerOriginalPropositionsArray = content.split("|")
    const answerCleanedPropositionsdArray = answerOriginalPropositionsArray.map(a => a.replace(/^\*/, "").replace(/※/g, " "))
    const qcmHorizontalItems = components.qcmHorizontalItems.createObject(linesFlowsArray[lineIndex], {
        horizontalQcmOriginalContentArray: answerOriginalPropositionsArray,
        horizontalQcmContentArray: answerCleanedPropositionsdArray
    })
    interactiveFieldsArray.push({ qcmHorizontalItems })
}

function createGapFillField(content, lineIndex) {
    const [defaultDisplayString, expectedAnswer] = content.split("|")
    const gap = components.fillInGap.createObject(linesFlowsArray[lineIndex], {
        defaultDisplayString,
        expectedAnswer
    })
    interactiveFieldsArray.push({ "gap-fill": gap })
}

function createQcmDropDownField(content, lineIndex) {
    const answerOriginalPropositionsArray = content.split("|")
    const answerCleanedPropositionsdArray = answerOriginalPropositionsArray.map(a => a.replace(/^\*/, "").replace(/※/g, " "))
    //linesFlowsArray[lineIndex].height = 25 //answers.length * verticalMcqButtonHeight * 1.8

    const qcmDropDownItems = components.qcmDropDown.createObject(linesFlowsArray[lineIndex], {
        comboboxOriginalContentArray: answerOriginalPropositionsArray,
        comboboxContentArray: answerCleanedPropositionsdArray,
    })

    interactiveFieldsArray.push({ qcmDropDownItems })
}


function addTextToFlow(lineIndex, text, size, bold = false, color = "black") {
    components.displayText.createObject(linesFlowsArray[lineIndex], {
        wordText: text,
        fontPixelSize: size,
        fontIsBold: bold,
        fontColor: color,
        fontFamily: "DejaVu Sans"
    })
}

function addCircularIconToFlow(lineIndex, text) {
    components.circularIcon.createObject(linesFlowsArray[lineIndex], {
        text: text,
    })
}

function initialiseScores() {
    interactiveFieldsExercicesArray.forEach((fields, i) => {
        scoreElementArray[i].wordText = ".../" + fields.length
    })
}
