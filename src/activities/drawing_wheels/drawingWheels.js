/* GCompris - drawing_wheels.js
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */

.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

const toothLength = 9                               // Could be a var to fit screen size
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

// calculated once after pressing play
var multipliedToothOffset = 0

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
    items.undoStack.clear()
    items.file.rmpath(items.undoStack.tempFile + ".svg")          // remove temporary svg file on disk
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

function savePngDialog() {
    items.creationHandler.svgMode = false
    items.creationHandler.saveWindow(items.undoStack.lastSavedFile)
    items.undoStack.isFileSaved = true
}

function saveSvgDialog() {
    items.creationHandler.svgMode = true
    items.creationHandler.saveWindow(items.undoStack.tempFile + ".svg")
    items.undoStack.isFileSaved = true
}

function openImageDialog() {
    if (!items.undoStack.isFileSaved) {
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
    items.gearTimer.stop()
    stop()                          // Clear undo-redo stack models and temporary images
    const maxRadius = ((wheelKeys[0] + wheelThickness) * toothLength) / Math.PI     // Max size for svg
    items.imageSize = 2 * maxRadius
    items.mainCanvas.initContext()
    items.animationCanvas.initContext()
    items.activityBackground.pushToUndoStack(true)
    initWheel()
    items.toothOffset = 0
    items.svgTank.resetSvg(maxRadius, items.backgroundColor)
}

function nextLevel() {
    if (!items.undoStack.isFileSaved) {
        items.actionAfter = "next"
        items.newImageDialog.active = true
        return
    }
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    resetWheel()
    initLevel()
}

function previousLevel() {
    if (!items.undoStack.isFileSaved) {
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
    rotateGear(0)
}

function startGear() {
    if(items.theGear.wheelAngle != 0) {
        items.startedFromOrigin = false;
    } else {
        items.startedFromOrigin = true;
    }
    items.activityBackground.updateUndo()   // Save pen and gear changes since last image stacked
    const pos = items.animationCanvas.getPencilPosition()
    items.svgTank.openPath(pos.x, pos.y)
    items.animationCanvas.ctx.lineWidth = items.penWidth
    items.animationCanvas.ctx.strokeStyle = items.penColor
    items.gearTimer.startTimer()
}

function stopGear(completed = false) {
    items.gearTimer.stop()
    items.svgTank.finishPath()
    items.svgTank.writeSvg()
    items.mainCanvas.ctx.globalAlpha = items.penOpacity     // Pen opacity is applied while copying canvas to canvas
    items.mainCanvas.ctx.drawImage(items.animationCanvas, 0, 0)
    items.mainCanvas.requestPaint()
    items.mainCanvas.ctx.globalAlpha = 1.0
    items.animationCanvas.initContext() // Clear animation canvas for next rounds
    items.activityBackground.pushToUndoStack(true)
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
    const trueAngle = items.theGear.wheelAngle - (multipliedToothOffset)   // wheelAngle + toothOffset
    const distance = items.theGear.extRadius - items.theWheel.intRadius
    var multipliedAngle = trueAngle * Math.PI / 180
    items.theGear.centerX = distance * Math.sin(multipliedAngle)
    items.theGear.centerY = -distance * Math.cos(multipliedAngle)
    const arc = items.theWheel.intRadius * ((trueAngle + (multipliedToothOffset)) * Math.PI / 180)
    items.theGear.rotation = -(arc / items.theGear.extRadius) / Math.PI * 180 + trueAngle

    const pos = items.animationCanvas.getPencilPosition()
    if (angle > 0) {
        items.animationCanvas.ctx.beginPath()
        items.animationCanvas.ctx.moveTo(items.lastPoint.x, items.lastPoint.y)
        items.animationCanvas.ctx.lineTo(pos.x, pos.y)
        items.animationCanvas.ctx.stroke()
        items.animationCanvas.ctx.closePath()
        items.svgTank.addLine(pos.x, pos.y)
        // A quadratic arc double the size of the svg, result is not better. Kept as an example
        // items.svgTank.addQuadratic(items.lastPoint.x, items.lastPoint.y, pos.x, pos.y)
    }
    items.animationCanvas.requestPaint()
    items.lastPoint.x = pos.x
    items.lastPoint.y = pos.y
    if ((items.theGear.wheelAngle / 360) >= items.maxRounds) {
        items.runCompleted = true
        items.theGear.wheelAngle = 0
        if(items.startedFromOrigin) {
            items.svgTank.closePath()
        }
        stopGear(true)
    } else {
        items.svgTank.addLine(pos.x, pos.y)
    }
}

function newWheel(externalTeeth, internalTeeth) {
    const extRadius = (externalTeeth * toothLength) / Math.PI
    const intRadius = (internalTeeth * toothLength) / Math.PI
    items.theWheel.extRadius = extRadius
    items.theWheel.intRadius = intRadius
    var svg = svgHeader
    svg += `<svg width="${1 + extRadius * 2}" height="${1 + extRadius * 2}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`

    // External circle, add points clockwise
    svg += `<path d="M`
    var points = []
    points = newCircle(externalTeeth, extRadius)
    var point = []
    while (points.length) {
        point = points.shift()
        svg += `${point.shift()},${point.shift()} `
    }

    // Internal serration, add points counter-clockwise
    svg += `M`
    points = newSerration(internalTeeth, extRadius)
    while (points.length) {
        point = points.pop()
        svg += `${point.shift()},${point.shift()} `
    }
    svg += `" fill="burlywood" stroke="blue" stroke-width="1" />\n`

    // Write teeth count on the wheel
    svg += `<text x="${extRadius - 5}" y="${extRadius - intRadius - (wheelThickness / 2)}">${internalTeeth}</text>\n`

    svg += `</svg>`
    return svg
}

function newGear(teethCount) {
    const radius = (teethCount * toothLength) / Math.PI
    items.theGear.extRadius = radius
    var svg = svgHeader
    svg += `<svg width="${1 + radius * 2}" height="${1 + radius * 2}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`

    // External serration, add points clockwise
    svg += `<path d="M`
    var point = []
    var points = newSerration(teethCount, radius)
    while (points.length) {
        point = points.shift()
        svg += `${point.shift()},${point.shift()} `
    }
    svg += `" fill="beige" stroke="blue" stroke-width="1" fill-opacity="0.4" />\n`

    // Draw a dotted line along radius
    svg += `<line x1="${radius}" y1="${radius}" x2="${radius}" y2="${radius * 2}" stroke="gray" stroke-dasharray="0" />\n`
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
        x = penOffset + (radius - gap) * Math.sin(angle * Math.PI / 180) + 1
        y = penOffset + (radius - gap) * Math.cos(angle * Math.PI / 180) + 1
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
        x = penOffset + radius * Math.sin(angle * Math.PI / 180) + 1
        y = penOffset + radius * Math.cos(angle * Math.PI / 180) + 1
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
