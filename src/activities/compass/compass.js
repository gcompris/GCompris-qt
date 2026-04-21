/* GCompris - compass.js
 *
 * SPDX-FileCopyrightText: 2026 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References:
 *  https://stackoverflow.com/questions/12219802/a-javascript-function-that-returns-the-x-y-points-of-intersection-between-two-ci
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items
var level = null
var ready = false
var crossings = []      // intersection points between templates' circles

function start(items_) {
    items = items_
    // Make sure items.numberOfLevel is initialized before calling Core.getInitialLevel
    items.numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    ready = true
    initLevel()
}

function stop() {
    if (!items.isFileSaved) {
        items.actionAfter = "stop"
        items.newImageDialog.active = true
        return
    }
    items.undoStack.clear()
    items.file.rmpath(items.svgTemplate.fileName)   // remove temporary template svg file on disk
    items.file.rmpath(items.svgTank.fileName)       // remove temporary svg file on disk
    ready = false
}

function nextLevel() {
    if (!items.isFileSaved) {
        items.actionAfter = "next"
        items.newImageDialog.active = true
        return
    }
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel)
    initLevel()
}

function previousLevel() {
    if (!items.isFileSaved) {
        items.actionAfter = "previous"
        items.newImageDialog.active = true
        return
    }
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel)
    initLevel()
}

function saveSvgDialog() {
    // Open dialog to save svg
    items.svgTank.writeSvg()
    items.creationHandler.saveWindow(items.svgTank.fileName)
}

function openImageDialog() {
    if (!items.isFileSaved) {
        items.actionAfter = "open"
        items.newImageDialog.active = true
        return
    }
    items.creationHandler.loadWindow()
}

function nextStep() {
    if (items.currentStep < level.steps.length - 1)
        items.currentStep++
    showCurrentStep()
    if (!items.allTemplate)
        templateToSvg()
}

function previousStep() {
    if (items.currentStep > 0)
        items.currentStep--
    showCurrentStep()
    if (!items.allTemplate)
        templateToSvg()
}

function initLevel() {
    if (!ready)
        return
    if (items.isTemplateMode) {
        level = items.levels[items.currentLevel]
        items.backgroundColor = "#ffffff"
    } else {
        level = {}
        level.title = qsTr("Free mode")
        level.size = items.canvasSizeSliderValue
        level.gridStep = items.gridStepSliderValue
        level.steps = []
        items.backgroundColor = items.newBackgroundColor
    }
    items.levelTitle = level.title
    items.stepsCount = level.steps.length
    items.viewSize = level.size
    items.canvasSizeSliderValue = level.size
    items.currentStep = 0
    templateToSvg()
    items.animationCanvas.initDrawing()
    items.sceneGrid.requestPaint()
    items.gridStepSliderValue = level.gridStep
    items.gridStep = level.gridStep

    if (items.stepsCount === 0)   // no template
        items.compass.tipPenInit = 2 * items.gridStep
    else
        items.compass.tipPenInit = level.steps[0].radius
    items.compass.initCompass()
    items.undoStack.clear()
    items.undoStack.pushToUndoStack()
    showCurrentStep()
    items.svgTank.resetSvg(items.viewSize, items.viewSize, items.backgroundColor, true)
    items.mainImage.source = items.svgTank.svgProtocol + items.svgTank.getSource()
    items.isFileSaved = true
}

function addStep(step) {
    if (items.stepsCount === 0)   // no template
        return
    items.svgTemplate.svgDash = "6"
    if (step.hasOwnProperty("start") && step.hasOwnProperty("end")) {
        if (step.end - step.start >= 360) {
            items.svgTemplate.addCircle(step.centerX, step.centerY, step.radius)
        } else {
            items.svgTemplate.addArc(step.centerX, step.centerY, step.radius, step.start, step.end)
            items.svgTemplate.closePath()
        }
    }
    items.svgTemplate.strokeWidth = 2
    items.svgTemplate.svgDash = ""
    items.svgTemplate.addCross(step.centerX, step.centerY, 5)
}

function showCurrentStep() {
    items.svgTemplate.resetSvg(items.viewSize, items.viewSize, "transparent", true)
    if (items.stepsCount === 0) { // no template
        items.stepImage.source = items.svgTemplate.svgProtocol + items.svgTemplate.getSource()
        return
    }
    const step = level.steps[items.currentStep]
    items.svgTemplate.strokeColor = "red"
    addStep(step)
    items.stepImage.source = items.svgTemplate.svgProtocol + items.svgTemplate.getSource()
}

function templateToSvg() {
    items.svgTemplate.resetSvg(items.viewSize, items.viewSize, "#ffffff", true)
    if (items.stepsCount === 0) { // no template
        items.templateImage.source = items.svgTemplate.svgProtocol + items.svgTemplate.getSource()
        return
    }
    items.svgTemplate.strokeWidth = 2
    items.svgTemplate.strokeColor = items.allTemplate ? "black" : "lightgray"
    for (var i = 0; i < level.steps.length; i++) {
        if (i === items.currentStep) continue
        addStep(level.steps[i])
    }
    items.svgTemplate.strokeColor = "black"
    addStep(level.steps[items.currentStep])

    addCrossings()
    items.templateImage.source = items.svgTemplate.svgProtocol + items.svgTemplate.getSource()
}

function getCanvasPixelColor(context, x, y) {
    var pixel = context.getImageData(x, y, 1, 1).data
    return Qt.rgba(pixel[0] / 255, pixel[1] / 255, pixel[2] / 255, 1.0)
}

function addCrossings() {   // Add cross on each template tip position (centerX, centerY)
    crossings = []
    var knownPoints = []
    const steps = level.steps
    level.steps.forEach((step) =>  crossings.push(Qt.point(step.centerX, step.centerY)))
    drawCrossings()
}

function drawCrossings() {
    items.svgTemplate.strokeColor = "red"
    crossings.forEach((pt) => {
        items.svgTemplate.addCross(pt.x, pt.y, 3)
    })
}

// Reference: https://gist.github.com/dcondrey/183971f17808e9277572
function contrastingColor(hex, factorAlpha=false) {
    let [r,g,b,a]=hex.replace(/^#?(?:(?:(..)(..)(..)(..)?)|(?:(.)(.)(.)(.)?))$/, '$1$5$5$2$6$6$3$7$7$4$8$8').match(/(..)/g).map(rgb=>parseInt('0x'+rgb));
    return ((~~(r*299) + ~~(g*587) + ~~(b*114))/1000) >= 128 || (!!(~(128/a) + 1) && factorAlpha) ? '#000000' : '#FFFFFF';
}
