/* GCompris - drawing.js
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 *
 *   This program is free software you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program if not, see <http://www.gnu.org/licenses/>.
 */

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/drawing/resource/"

var currentLevel = 0
var numberOfLevel = 4
var items
var loadImagesSource = [
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo1.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo2.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo3.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo4.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo5.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo6.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo7.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo8.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo9.svg",
            "qrc:/gcompris/src/activities/photo_hunter/resource/photo10.svg"
        ]

var undo = []
var redo = []

var userFile = "file://" + GCompris.ApplicationInfo.getSharedWritablePath()
        + "/paint/" + "levels-user.json"

var dataset = null

var ctx

var points = []
var connectedPoints = []
var reloadCanvas = false
var redoMode = false

function start(items_) {
    items = items_
    currentLevel = 0
    items.toolSelected = "pencil"
    items.paintColor = items.selectedColor
    initLevel()
}

function stop() {
}

function initLevel() {
    dataset = null
    points = []
    connectedPoints = []

    undo = []
    redo = []

    ctx = items.canvas.getContext("2d")
    items.globalOpacityValue = 1
    ctx.fillStyle = items.backgroundColor
    if(reloadCanvas) {
        console.log("Clearing canvas!")
        ctx.clearRect(0, 0, items.background.width, items.background.height)
        //        ctx.beginPath()
        //        ctx.clearRect(0, 0, items.background.width, items.background.height)
        //        ctx.moveTo(0, 0)
        //        ctx.lineTo(items.background.width, 0)
        //        ctx.lineTo(items.background.width, items.background.height)
        //        ctx.lineTo(0, items.background.height)
        //        ctx.closePath()
        //        ctx.fill()
        reloadCanvas = false
    }
    ctx.globalAlpha = items.globalOpacityValue
    items.foldablePanels.toolsMode.opacitySliderValue = items.globalOpacityValue
    items.canvas.requestPaint()

    undo = ["data:image/pngbase64,iVBORw0KGgoAAAANSUhEUgAAA4sAAAOLCAYAAAD5ExZjAAAACXBIWXMAAA7EAAAOxAGVKw4bAAATLElEQVR4nO3XsQ0AIRDAsOf33/lokTIAFPYEabNmZj4AAAA4/LcDAAAAeI9ZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgNq0MCxI5gV9wAAAAAElFTkSuQmCC"]

    // if the width/height is changed, the drawing is reset and repainted the last image saved
    if (items.widthHeightChanged) {
        // load the image
        ctx = items.canvas.getContext("2d")
        ctx.clearRect(0, 0, items.background.width, items.background.height)
        ctx.drawImage(items.lastUrl, 0, 0)
        items.canvas.requestPaint()
        // reset the flag to false
        items.widthHeightChanged = false
    }

    //load saved paintings from file
    parseImageSaved()
    items.gridView2.model = dataset

    getPattern()
    items.background.started = true

    items.background.hideExpandedTools()
}

function getPattern() {
    var dotWidth = 20, dotDistance = 5
    var patternCtx = items.shape.getContext("2d")
    patternCtx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = items.shape.height = dotWidth + dotDistance
    patternCtx.fillStyle = items.paintColor
    patternCtx.beginPath()
    patternCtx.arc(dotWidth / 2, dotWidth / 2, dotWidth / 2, 0, Math.PI * 2, false);
    patternCtx.closePath()
    patternCtx.fill()
    items.shape.requestPaint()
}

function getPattern2() {
    var lineSize = 10, lineWidth = 5
    var patternCtx = items.shape.getContext("2d")
    patternCtx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = items.shape.height = lineSize
    patternCtx.strokeStyle = items.paintColor
    patternCtx.lineWidth = lineWidth
    patternCtx.beginPath()
    patternCtx.moveTo(0, lineWidth)
    patternCtx.lineTo(lineSize, lineWidth)
    patternCtx.closePath()
    patternCtx.stroke()
}

function getPattern3() {
    var lineSize = 20, lineWidth = 10
    var ctx = items.shape.getContext("2d")
    ctx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = lineWidth;
    items.shape.height = lineSize;
    ctx.fillStyle = items.paintColor
    ctx.fillRect(lineWidth / 2, 0, lineWidth, lineSize);
}

function getSprayPattern() {
    var patternCtx = items.shape.getContext("2d")
    patternCtx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = items.shape.height = 3
    patternCtx.fillStyle = items.paintColor
    patternCtx.fillRect(0, 0, 2, 2);
}

function getCirclePattern() {
    var dotWidth = 10, dotDistance = 2.5
    var patternCtx = items.shape.getContext("2d")
    patternCtx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = dotWidth * 0.6 + dotDistance * 2
    items.shape.height = items.shape.width
    patternCtx.strokeStyle = items.paintColor
    patternCtx.lineWidth = 1
    patternCtx.beginPath()
    patternCtx.arc(dotWidth / 2, dotWidth / 2, dotWidth / 2, 0, Math.PI * 2, false);
    patternCtx.closePath()
    patternCtx.stroke()
}

// parse the content of the paintings saved by the user
function parseImageSaved() {
    dataset = items.parser.parseFromUrl(userFile)
    if (dataset == null) {
        console.error("ERROR! dataset = []")
        dataset = []
        return
    }
}

// if showMessage === true, then show the message Core.showMessageDialog(...), else don't show it
function saveToFile(showMessage) {
    // verify if the path is good
    var path = userFile.substring(0, userFile.lastIndexOf("/"))
    if (!items.file.exists(path)) {
        if (!items.file.mkpath(path))
            console.error("Could not create directory " + path)
        else
            console.debug("Created directory " + path)
    }

    // add current painting to the dataset
    if (showMessage)
        dataset = dataset.concat({"imageNumber": 1, "url": items.canvas.toDataURL()})

    // save the dataset to json file
    if (!items.file.write(JSON.stringify(dataset), userFile)) {
        if (showMessage)
            Core.showMessageDialog(items.main,
                                   //~ singular Error saving %n level to your levels file (%1)
                                   //~ plural Error saving %n levels to your levels file (%1)
                                   qsTr("Error saving %n level(s) to your levels file (%1)", "", numberOfLevel)
                                   .arg(userFile),
                                   "", null, "", null, null)
    } else {
        if (showMessage)
            Core.showMessageDialog(items.main,
                                   //~ singular Saved %n level to your levels file (%1)
                                   //~ plural Saved %n levels to your levels file (%1)
                                   qsTr("Saved %n level(s) to your levels file (%1)", "", numberOfLevel)
                                   .arg(userFile),
                                   "", null, "", null, null)
    }
    items.initSave = false

    //reload the dataset:
    parseImageSaved()
    items.gridView2.model = dataset

    // reset nothingChanged
    items.nothingChanged = true
}

function handleKeyNavigations(event) {
    if(event.modifiers === Qt.ControlModifier && event.key === Qt.Key_Z) {
        selectTool("Undo")
    }
    else if(event.modifiers === Qt.ControlModifier && event.key === Qt.Key_Y) {
        selectTool("Redo")
    }
    else if(event.modifiers === Qt.ControlModifier && event.key === Qt.Key_N) {
        selectTool("Erase all")
    }
    else if(event.modifiers === Qt.ControlModifier && event.key === Qt.Key_S) {
        selectTool("Save")
    }
    else if(event.modifiers === Qt.ControlModifier && event.key === Qt.Key_O) {
        selectTool("Load")
    }

}

// Exports the current drawing in png format.
function exportToPng() {
    var path =  GCompris.ApplicationInfo.getSharedWritablePath() + "/drawing"
    if(!items.file.exists(path)) {
        if(!items.file.mkpath(path)) {
            Core.showMessageDialog(items.main,
                                   qsTr("Error: could not create the directory %1").arg(path),
                                   "", null, "", null, null)
            console.error("Could not create directory " + path)
            return;
        }
        else
            console.debug("Created directory " + path)
    }
    var i = 0;
    while(items.file.exists(path + "/drawing" + i.toString() + ".png")) {
        i += 1
    }
    items.canvas.grabToImage(function(result) {
        if(result.saveToFile(path + "/drawing" + i.toString() + ".png")) {
            console.log("File drawing" + i + ".png saved successfully.")
            Core.showMessageDialog(items.main,
                                   qsTr("Saved drawing to %1").arg(path + "/drawing" + i.toString() + ".png"),
                                   "", null, "", null, null)

        }
        else {
            Core.showMessageDialog(items.main,
                                   qsTr("Error in saving the drawing."),
                                   "", null, "", null, null)
        }
    })

}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}


function selectTool(toolName) {
    console.log("Clicked on " + toolName)
    items.paintColor = items.selectedColor
    items.eraserMode = false
    items.timer.stop()
    if(toolName === "Eraser") {
        items.eraserMode = true
        items.paintColor = Qt.rgba(0, 0, 0, 1)
        items.globalOpacityValue = 1
        items.foldablePanels.toolsMode.opacitySliderValue = items.globalOpacityValue
        items.toolSelected = "eraser"
        items.toolsMode.modesModel = items.toolsMode.pencilModes
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()
    }
    else if(toolName === "Bucket fill") {
        items.toolSelected = "fill"
        items.background.hideExpandedTools()

        // change the selectBrush tool
        items.timer.index = 0
        items.timer.start()

        items.background.reloadSelectedPen()
    }
    else if(toolName === "Text") {
        items.toolSelected = "text"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()

        // make visible the inputTextFrame
        items.inputTextFrame.visible = true
        items.inputTextFrame.enabled = true

        // restore input text to ""
        items.inputText.text = ""
    }
    else if(toolName === "Undo") {
        items.background.hideExpandedTools()
        if(undo.length > 1 ) {
            var temp = undo.pop()
            redo = redo.concat(temp)
            if(redoMode) {
                items.urlImage = temp
            }
            else {
                items.urlImage = undo[undo.length - 1]
            }
            items.canvas.ctx.globalCompositeOperation = 'source-over'
            ctx = items.canvas.getContext("2d")
            ctx.clearRect(0, 0, items.background.width, items.background.height)
            ctx.drawImage(items.urlImage, 0, 0, items.canvas.width, items.canvas.height)
            items.canvas.requestPaint()
        }
        else {
            console.log("Undo array Empty!")
        }
    }
    else if(toolName === "Redo") {
        items.background.hideExpandedTools()
        if(redo.length > 0) {
            redoMode = true
            items.urlImage = redo.pop()
            ctx = items.canvas.getContext("2d")
            ctx.clearRect(0, 0, items.background.width, items.background.height)
            ctx.drawImage(items.urlImage, 0, 0, items.canvas.width, items.canvas.height)
            items.canvas.requestPaint()
            undo = undo.concat(items.urlImage)
            console.log("undo length: " + undo.length)

            if(redo.length == 0) {
                redoMode = false
            }
        }
        else {
            console.log("Redo array Empty!")
        }
    }
    else if(toolName === "Load") {
        if (items.load.opacity == 0)
            items.load.opacity = 1

        items.background.hideExpandedTools()

        // mark the pencil as the default tool
        items.toolSelected = "pencil"

        // move the main screen to right
        items.mainRegion.x = items.background.width
    }
    else if(toolName === "Save") {
        saveToFile(true)
    }
    else if(toolName === "More Colors") {
        items.colorPalette.visible = true
    }
    else if(toolName === "Modes") {
        items.toolsMode.visible = true
    }
    else if(toolName === "Size") {
        items.toolsSize.visible = true
    }
    else if(toolName === "Erase all") {
        if (!items.nothingChanged) {
            items.saveToFilePrompt.buttonPressed = "reload"
            items.saveToFilePrompt.text = qsTr("Do you want to save your painting before reseting the board?")
            items.saveToFilePrompt.opacity = 1
            items.saveToFilePrompt.z = 200
        } else {
            initLevel()
        }
    }
    else if(toolName === "Geometric") {
        items.toolSelected = "rectangle"
        items.lastToolSelected = "rectangle"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()
        items.toolsMode.modesModel = items.toolsMode.geometricModes
    }
    else if(toolName === "Stamp") {
        items.toolSelected = "stamp"
        items.lastToolSelected = "stamp"
        items.toolsMode.modesModel = items.toolsMode.stampsModel
        items.stampGhostImage.opacity = 0.5
        items.stampGhostImage.z = 1500
        items.stampGhostImage.x = items.area.realMouseX
        items.stampGhostImage.y = items.area.realMouseY
    }

    else if(toolName === "Brush") {
        items.toolSelected = "pencil"
        items.lastToolSelected = "pencil"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()
        items.toolsMode.modesModel = items.toolsMode.pencilModes
    }
    else if(toolName === "Export to PNG") {
        exportToPng()
    }
    else if(toolName === "Background color") {
        items.backgroundColorPalette.visible = true
    }
}

function selectMode(modeName) {
    if(modeName === "dot") {
        items.toolSelected = "pattern"
        items.patternType = "dot"
        items.lastToolSelected = "pattern"
        getPattern()
        items.background.reloadSelectedPen()
    }
    else if(modeName === "pattern2") {
        items.toolSelected = "pattern"
        items.patternType = "horizLine"
        items.lastToolSelected = "pattern"
        getPattern2()
        items.background.reloadSelectedPen()
    }
    else if(modeName === "pattern3") {
        items.toolSelected = "pattern"
        items.patternType = "vertLine"
        items.lastToolSelected = "pattern"
        getPattern3()
        items.background.reloadSelectedPen()
    }
}

// Paint flood-fill algorithm(Stack based Implementation)
function paintBucket() {
    console.log( "Flood fill started at " + new Date().toLocaleTimeString() )
    items.canvas.isBucketDone = false;
    var reachLeft = false;
    var reachRight = false;
    var sX = parseInt(items.canvas.startX, 10)
    var sY = parseInt(items.canvas.startY, 10)
    var pixelStack = [[items.canvas.startX, items.canvas.startY]]
    var ctx = items.canvas.getContext('2d')

    var colorLayer = ctx.getImageData(0, 0,items.canvas.width, items.canvas.height)
    var begPixel = sX * 4 + sY * 4 * colorLayer.width
    var r1 = colorLayer.data[begPixel]
    var g1 = colorLayer.data[begPixel + 1]
    var b1 = colorLayer.data[begPixel + 2]

    if(r1 === (items.canvas.fillColor.r * 255) && g1 === (items.canvas.fillColor.g * 255) && b1 === (items.canvas.fillColor.b * 255)) {
        items.canvas.isBucketDone = true;
        return;
    }

    var  r2, b2, g2, newIndex, oPixel

    while(pixelStack.length) {
        var pixelToCheck = pixelStack.pop()
        sY = pixelToCheck[1]
        sX = pixelToCheck[0]
        begPixel = sX * 4 + sY * 4 * colorLayer.width

        reachLeft = false;
        reachRight = false;

        while(sY - 1 >= 0) {
            begPixel = sX * 4 + sY * 4 * colorLayer.width

            if (!((colorLayer.data[begPixel] === r1) && (colorLayer.data[begPixel + 1] === g1) && (colorLayer.data[begPixel + 2] === b1))) {
                break;
            }
            sY = sY - 1
        }

        sY = sY + 1;
        ctx.fillRect(sX, sY, 1, 1)
        begPixel = sX * 4 + sY * 4 * colorLayer.width
        colorLayer.data[begPixel] = items.canvas.fillColor.r * 255
        colorLayer.data[begPixel + 1] = items.canvas.fillColor.g * 255
        colorLayer.data[begPixel + 2] = items.canvas.fillColor.b * 255
        colorLayer.data[begPixel + 3] = 255

        while(sY + 1 < colorLayer.height) {
            sY = sY + 1
            begPixel = sX * 4 + sY * 4 * colorLayer.width
            if(((colorLayer.data[begPixel ] === r1) && (colorLayer.data[begPixel + 1] === g1) && (colorLayer.data[ begPixel + 2 ] === b1))) {
                ctx.fillRect(sX, sY, 2, 2)
                colorLayer.data[begPixel] = items.canvas.fillColor.r * 255
                colorLayer.data[begPixel + 1] = items.canvas.fillColor.g * 255
                colorLayer.data[begPixel + 2] = items.canvas.fillColor.b * 255
                colorLayer.data[begPixel + 3] = 255

                if(sX > 1) {
                    oPixel = (sX - 1) * 4 + sY * 4 * colorLayer.width
                    if((colorLayer.data[oPixel] === r1) && (colorLayer.data[oPixel + 1] === g1) && (colorLayer.data[oPixel + 2] === b1)) {
                        if(!reachLeft) {
                            pixelStack.push([sX -1, sY])
                            reachLeft = true;
                        }
                    }
                    else {
                        reachLeft = false;
                    }
                }

                if(sX < items.canvas.width) {
                    oPixel = (sX + 1) * 4 + sY * 4 * colorLayer.width
                    if((colorLayer.data[oPixel ] === r1) && (colorLayer.data[oPixel + 1] === g1) && (colorLayer.data[ oPixel + 2 ] === b1)) {
                        if (!reachRight) {
                            pixelStack.push([sX + 1, sY])
                            reachRight = true;
                        }
                    }
                    else {
                        reachRight = false;
                    }
                }
            }
            else {
                break;
            }
        }
    }

    ctx.drawImage(colorLayer, 0, 0)
    items.canvas.requestPaint()
    items.canvas.startX = -1
    items.canvas.startY = -1
    items.canvas.finishX = -1
    items.canvas.finishY = -1

    console.log( "Flood-fill completed at " + new Date().toLocaleTimeString() )
}
