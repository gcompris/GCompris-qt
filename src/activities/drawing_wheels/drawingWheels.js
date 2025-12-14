/* GCompris - drawing_wheels.js
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */

.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

const baseToothLength = 9
// Values calculated in initCanvas()
var toothLength = 9
var canvasSize = 1

const svgProtocol = "data:image/svg+xml;utf8,"
const svgHeader = `<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n`
const wheelThickness = 10
const wheelKeys = [ 96, 84, 80, 72, 70, 55, 50 ]
const sets = [
            { "wheel": wheelKeys[0], "gears": [ 30, 40, 45, 52, 60, 80] }
          , { "wheel": wheelKeys[1], "gears": [ 30, 40, 45, 52, 60] }
          , { "wheel": wheelKeys[2], "gears": [ 30, 45, 52, 60] }
          , { "wheel": wheelKeys[3], "gears": [ 30, 40, 45, 52, 60] }
          , { "wheel": wheelKeys[4], "gears": [ 30, 40, 45, 60] }
          , { "wheel": wheelKeys[5], "gears": [ 30, 40, 45] }
          , { "wheel": wheelKeys[6], "gears": [ 30, 40, 45] }
        ]

var numberOfLevel = 2
var items

const toRadianMultiplier = Math.PI / 180
// Used in rotateGear, and calculated once after pressing play
var multipliedToothOffset = 0
var radiusDistance = 0

function start(items_) {
    items = items_
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.gearsModel.clear()
    for (var i = 0; i < sets[0].gears.length; i++)
        items.gearsModel.append({ "nbTeeth": sets[0].gears[i]})
    initLevel()
}

function stop() {
    items.gearTimer.stop();
    items.file.rmpath(items.svgTank.fileName);         // remove temporary svg file on disk
    items.file.rmpath(items.canvasArea.tempSaveFile);  // remove png snapshot file on disk
    items.canvasArea.clearUndo();
    items.canvasArea.clearRedo();
    items.undoStack.clear()
}

function pushModel(model, data) {
    model.append(data)
}

function popModel(model) {
    var data = JSON.parse(JSON.stringify(model.get(model.count - 1)))   // Clone data before removing
    model.remove(model.count - 1)
    return data
}

function shiftModel(model) {
    var data = JSON.parse(JSON.stringify(model.get(0)))       // Clone data before removing
    model.remove(0)
    return data
}

function saveSvgDialog() {
    // store png snapshot
    items.canvasArea.saveToFile(items.canvasArea.tempSaveFile)
    // Open dialog to save svg
    items.creationHandler.saveWindow(items.svgTank.fileName)
}

function openImageDialog() {
    if (!items.isFileSaved) {
        items.actionAfter = "open"
        items.newImageDialog.active = true
        return
    }
    items.creationHandler.loadWindow();
}

function resetWheel() {
    items.currentWheel = 0
    items.currentGear = 0
    items.wheelTeeth = sets[items.currentWheel].wheel
    items.gearTeeth = sets[items.currentWheel].gears[items.currentGear]
}

function initLevel() {
    items.fileIsEmpty = true;
    items.canvasArea.clearUndo()
    items.canvasArea.clearRedo()
    items.undoStack.clear()
    items.canvasImage.source = ""
    items.panelManager.closePanel()
    items.backgroundColor = items.newBackgroundColor
    items.gearTimer.stop()
    stop()    // Clear undo-redo stack models and temporary images
    initCanvas()
    items.animationCanvas.initContext()
    //add first empty undo to canvasArea and to undoStack to restore empty canvas
    items.animationCanvas.paintActionFinished();
    initWheel()
    items.toothOffset = 0
    items.svgTank.resetSvg(canvasSize, items.backgroundColor)
    items.isFileSaved = true
    items.canvasLocked = false
}

function initCanvas() {
    // Base size with given baseToothLength,
    const baseSize = 2 * (((wheelKeys[0] + wheelThickness) * baseToothLength) / Math.PI)
    canvasSize = Math.round(Math.min(items.canvasContainer.width, items.canvasContainer.height))
    items.canvasArea.width = canvasSize;
    items.canvasArea.height = canvasSize;
    // Adapt toothLength to actual canvas size
    var sizeMultiplier = canvasSize / baseSize
    toothLength = baseToothLength * sizeMultiplier
}

function nextLevel() {
    if (!items.isFileSaved) {
        items.actionAfter = "next"
        items.newImageDialog.active = true
        return
    }
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    resetWheel()
    initLevel()
}

function previousLevel() {
    if (!items.isFileSaved) {
        items.actionAfter = "previous"
        items.newImageDialog.active = true
        return
    }
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel)
    resetWheel()
    initLevel()
}

function initWheel() {
    items.theWheel.source = svgProtocol + newWheel(items.wheelTeeth + wheelThickness, items.wheelTeeth)
    initGear()
}

function initGear() {
    items.gearTimer.stop()
    items.theGear.source = svgProtocol + newGear(items.gearTeeth)
    // stick gear to wheel
    items.theGear.centerX = 0
    items.theGear.centerY = items.theWheel.intRadius - items.theGear.extRadius
    items.theGear.wheelAngle = 0
    multipliedToothOffset = items.toothOffset * 360 / items.wheelTeeth
    radiusDistance = items.theGear.extRadius - items.theWheel.intRadius
    rotateGear(0)
}

function startGear() {
    items.canvasLocked = true
    items.isFileSaved = false
    if(items.theGear.wheelAngle != 0) {
        items.startedFromOrigin = false
    } else {
        items.startedFromOrigin = true
    }
    items.undoStack.updateUndo()   // Save pen and gear changes since last image stacked
    const pos = items.animationCanvas.getPencilPosition()
    items.svgTank.openPath(pos.x, pos.y)
    items.animationCanvas.ctx.lineWidth = items.actualPenWidth
    items.animationCanvas.ctx.strokeStyle = items.penColor
    items.gearTimer.startTimer()
}

function stopGear(completed = false) {
    items.gearTimer.stop()
    items.svgTank.finishPath()
    items.svgTank.writeSvg()
    items.fileIsEmpty = false
    items.animationCanvas.paintActionFinished();
}

// Compute current position, draw or not, move and rotate gear, move pen
function rotateGear(angle) {
    // // Uncomment this and memTime in Spiral.qml to log time needed to render one wheel loop for debug purpose.
    // var t = (items.theGear.wheelAngle % 360)
    // if (t + angle >= 360) {
    //     var tim = new Date().getTime()
    //     console.log(tim - items.gearTimer.memTime)
    //     items.gearTimer.memTime = tim
    // }

    items.theGear.wheelAngle += angle
    const trueAngle = items.theGear.wheelAngle - multipliedToothOffset  // wheelAngle + toothOffset
    const multipliedAngle = trueAngle * toRadianMultiplier
    items.theGear.centerX = radiusDistance * Math.sin(multipliedAngle)
    items.theGear.centerY = -radiusDistance * Math.cos(multipliedAngle)
    const arc = items.theWheel.intRadius * ((trueAngle + multipliedToothOffset) * toRadianMultiplier)
    items.theGear.rotation = -(arc / items.theGear.extRadius) / toRadianMultiplier + trueAngle

    const pos = items.animationCanvas.getPencilPosition()
    if(angle > 0) {
        // Other ctx actions before and after are in gearTimer's rotateGear in main QML file, for optimization.
        items.animationCanvas.ctx.lineTo(pos.x, pos.y)
    }
    items.lastPoint = pos
    if((items.theGear.wheelAngle / 360) >= items.maxRounds) {
        items.runCompleted = true
        items.theGear.wheelAngle = 0
        if(items.startedFromOrigin) {
            items.svgTank.closePath()
        }
    } else {
        items.svgTank.addLine(pos.x, pos.y)
    }
}

function undoAction() {
    // 1st element of the list is always last possible state, never undo it
    if(items.canvasArea.undoSize > 1) {
        items.scrollSound.play();
        items.canvasLocked = true;
        items.canvasArea.doUndo();
        items.undoStack.restoreFromStack(items.undoStack.undoLast())
        items.svgTank.undo()
        items.svgTank.writeSvg()
        items.canvasArea.sendToImageSource();
        items.canvasLocked = false;
    }
}

function redoAction() {
    if(items.canvasArea.redoSize > 0) {
        items.scrollSound.play();
        items.canvasLocked = true;
        items.canvasArea.doRedo();
        items.undoStack.restoreFromStack(items.undoStack.redoLast())
        items.svgTank.redo()
        items.svgTank.writeSvg()
        items.canvasArea.sendToImageSource();
        items.canvasLocked = false;
    }
}

function newWheel(externalTeeth, internalTeeth) {
    const extRadius = (externalTeeth * toothLength) / Math.PI
    const intRadius = (internalTeeth * toothLength) / Math.PI
    items.theWheel.extRadius = extRadius
    items.theWheel.intRadius = intRadius
    var wheelSize = 2 + extRadius * 2
    items.theWheel.width = wheelSize
    items.theWheel.height = wheelSize
    var svg = svgHeader
    svg += `<svg width="${wheelSize}" height="${wheelSize}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`

    // External circle, add points clockwise
    svg += `<path d="M`
    var points = []
    points = newCircle(externalTeeth, extRadius)
    var point = []
    while (points.length) {
        point = points.shift()
        svg += `${point.shift()},${point.shift()} `
    }
    svg += ` Z `
    // Internal serration, add points counter-clockwise
    svg += `M`
    points = newSerration(internalTeeth, extRadius)
    while (points.length) {
        point = points.pop()
        svg += `${point.shift()},${point.shift()} `
    }
    svg += `" fill="burlywood" stroke="blue" stroke-width="1" />\n`

    // Write teeth count on the wheel
    // svg += `<text x="${extRadius - 5}" y="${extRadius - intRadius - (wheelThickness / 2)}">${internalTeeth}</text>\n`

    svg += `</svg>`
    return svg
}

function newGear(teethCount) {
    const radius = (teethCount * toothLength) / Math.PI
    items.theGear.extRadius = radius
    var gearSize = 2 + radius * 2
    items.theGear.width = gearSize
    items.theGear.height = gearSize
    var svg = svgHeader
    svg += `<svg width="${gearSize}" height="${gearSize}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`

    // External serration, add points clockwise
    svg += `<path d="M`
    var point = []
    var points = newSerration(teethCount, radius)
    while (points.length) {
        point = points.shift()
        svg += `${point.shift()},${point.shift()} `
    }
    svg += `" fill="beige" stroke="blue" stroke-width="1" opacity="0.5" />\n`

    // Draw a dotted line along radius
    // svg += `<line x1="${radius + 1}" y1="${radius + 1}" x2="${radius + 1}" y2="${radius * 2 + 1}" stroke="gray" stroke-dasharray="0" opacity="0.5" />\n`
    // Write teeth count on the gear
    // svg += `<text x="${radius - 5}" y="${radius - 25}">${teethCount}</text>\n`

    svg += `</svg>`
    return svg
}

function newSerration(teethCount, penOffset) {  // Returns an array of points
    const radius = (teethCount * toothLength) / Math.PI
    const step = 360 / (4 * teethCount)
    var gap = 0
    var bump = 0
    var points = []
    var x = 0
    var y = 0
    for (var angle = 0; angle <= 360; angle += step) {
        x = penOffset + (radius - gap) * Math.sin(angle * toRadianMultiplier) + 1
        y = penOffset + (radius - gap) * Math.cos(angle * toRadianMultiplier) + 1
        points.push( [ x.toFixed(3) ,y.toFixed(3)])
        bump = (bump + 1) % 4
        if (bump % 2)
            gap = toothLength - gap
    }
    return points
}

function newCircle(teethCount, penOffset) {     // Returns an array of points
    const radius = (teethCount * toothLength) / Math.PI
    const step = 360 / (4 * teethCount)
    var points = []
    var x = 0
    var y = 0
    for (var angle = 0; angle <= 360; angle += step) {
        x = penOffset + radius * Math.sin(angle * toRadianMultiplier) + 1
        y = penOffset + radius * Math.cos(angle * toRadianMultiplier) + 1
        points.push( [ x.toFixed(3) ,y.toFixed(3)])
    }
    return points
}

function computeGcd(a, b) {     // Greatest common divisor
    if (b === 0) {
        return a
    } else {
        return computeGcd(b, a % b)
    }
}

function computeLcm(a, b) {     // Least common multiple
    const gcd = computeGcd(a, b)
    return (a * b) / gcd
}
