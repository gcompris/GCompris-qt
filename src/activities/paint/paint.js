/* GCompris - paint.js
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

var url = "qrc:/gcompris/src/activities/paint/resource/"

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

var aux = ["1","2","3","4","5"]

var userFile = "file://" + GCompris.ApplicationInfo.getSharedWritablePath()
        + "/paint/" + "levels-user.json"

var dataset = null

var ctx

var points = []
var connectedPoints = []

function start(items_) {
    items = items_
    currentLevel = 0
    items.toolSelected = "pencil"
    items.paintColor = "#000000"
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
    ctx.fillStyle = "#ffffff"

    ctx.beginPath()
    ctx.clearRect(0, 0, items.background.width, items.background.height)

    ctx.moveTo(0, 0)
    ctx.lineTo(items.background.width, 0)
    ctx.lineTo(items.background.width, items.background.height)
    ctx.lineTo(0, items.background.height)
    ctx.closePath()
    ctx.fill()
    items.canvas.requestPaint()


    items.next = false
    items.next2 = false

    undo = ["data:image/pngbase64,iVBORw0KGgoAAAANSUhEUgAAA4sAAAOLCAYAAAD5ExZjAAAACXBIWXMAAA7EAAAOxAGVKw4bAAATLElEQVR4nO3XsQ0AIRDAsOf33/lokTIAFPYEabNmZj4AAAA4/LcDAAAAeI9ZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgNq0MCxI5gV9wAAAAAElFTkSuQmCC"]

    // if the width/height is changed, the drawing is reset and repainted the last image saved
    if (items.widthHeightChanged) {
        // load the image
        items.canvas.url = items.lastUrl
        items.canvas.loadImage(items.lastUrl)
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
    if(toolName === "Eraser") {
        items.toolSelected = "eraser"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()
    }
    else if(toolName === "Bucket fill") {
        items.toolSelected = "fill"
        items.background.hideExpandedTools()

        // make the hover over the canvas false
        items.area.hoverEnabled = false

        // change the selectBrush tool
        items.timer.index = 0
        items.timer.start()

        items.background.reloadSelectedPen()
    }
    else if(toolName === "Text") {
        items.toolSelected = "text"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()

        // enable the text to follow the cursor movement
        items.area.hoverEnabled = true

        // make visible the inputTextFrame
        items.inputTextFrame.opacity = 1
        items.inputTextFrame.z = 1000

        // restore input text to ""
        items.inputText.text = ""
    }
    else if(toolName === "Undo") {
        items.background.hideExpandedTools()
        if (undo.length > 0 && items.next ||
                undo.length > 1 && items.next == false) {
            items.undoRedo = true

            if (items.next) {
                redo = redo.concat(undo.pop())
            }

            items.next = false
            items.next2 = true

            // pop the last image saved from "undo" array
            items.urlImage = undo.pop()

            // load the image in the canvas
            items.canvas.loadImage(items.urlImage)

            // save the image into the "redo" array
            redo = redo.concat(items.urlImage)

            // print("undo:   " + undo.length + "  redo:  " + redo.length + "     undo Pressed")
        }
    }
    else if(toolName === "Redo") {
        items.background.hideExpandedTools()
        if (redo.length > 0) {
            items.undoRedo = true

            if (items.next2) {
                undo = undo.concat(redo.pop())
            }

            items.next = true
            items.next2 = false

            items.urlImage = redo.pop()

            items.canvas.loadImage(items.urlImage)
            undo = undo.concat(items.urlImage)

            // print("undo:   " + undo.length + "  redo:  " + redo.length + "     redo Pressed")
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
            items.saveToFilePrompt2.text = qsTr("Do you want to save your painting before reseting the board?")
            items.saveToFilePrompt2.opacity = 1
            items.saveToFilePrompt2.z = 200
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
    else if(toolName === "Pencil") {
        items.toolSelected = "pencil"
        items.lastToolSelected = "pencil"
        items.background.hideExpandedTools()
        items.background.reloadSelectedPen()
        items.toolsMode.modesModel = items.toolsMode.pencilModes
    }
    else if(toolName === "Red") items.paintColor = "red"
    else if(toolName === "Green") items.paintColor = "green"
    else if(toolName === "Yellow") items.paintColor = "yellow"
    else if (toolName === "Orange") items.paintColor = "orange"
    else if(toolName === "Blue") items.paintColor = "blue"
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
