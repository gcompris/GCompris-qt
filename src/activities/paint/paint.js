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
var colors = [
            /*blue*/    "#33B5E5", "#1a53ff", "#0000ff", "#0000b3",
            /*green*/   "#bfff00", "#99CC00", "#86b300", "#608000",
            /*orange*/  "#FFBB33",
            /*red*/     "#ff9999", "#FF4444", "#ff0000", "#cc0000",
            /*pink*/    "#ff00ff",
            /*yellow*/  "#ffff00",
            /*white*/   "#ffffff",
            /*black*/   "#000000",
            /*free spots*/
                 "#c2c2d6",  "#c2c2d6", "#c2c2d6", "#c2c2d6",
                 "#c2c2d6", "#c2c2d6", "#c2c2d6", "#c2c2d6"
        ]
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

    items.toolSelected = ""
    items.paintColor = colors[0]

    items.next = false
    items.next2 = false

    undo = ["data:image/pngbase64,iVBORw0KGgoAAAANSUhEUgAAA4sAAAOLCAYAAAD5ExZjAAAACXBIWXMAAA7EAAAOxAGVKw4bAAATLElEQVR4nO3XsQ0AIRDAsOf33/lokTIAFPYEabNmZj4AAAA4/LcDAAAAeI9ZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgzCIAAABhFgEAAAizCAAAQJhFAAAAwiwCAAAQZhEAAIAwiwAAAIRZBAAAIMwiAAAAYRYBAAAIswgAAECYRQAAAMIsAgAAEGYRAACAMIsAAACEWQQAACDMIgAAAGEWAQAACLMIAABAmEUAAADCLAIAABBmEQAAgDCLAAAAhFkEAAAgNq0MCxI5gV9wAAAAAElFTkSuQmCC"]

    // if the widht/height is changed, the drawing is reset and repainted the last image saved
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

}

function getPattern(size) {
    var dotWidth = 20, dotDistance = 5
    if (size) {
        dotWidth = 10; dotDistance = 2.5
    }
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

function getPattern2(size) {
    var lineSize = 10, lineWidth = 5
    if (size) {
        lineSize = 5; lineWidth = 2.5
    }

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

function getPattern3(size) {
    var lineSize = 20, lineWidth = 10
    if (size) {
        lineSize = 10; lineWidth = 5
    }
    var ctx = items.shape.getContext("2d")
    ctx.clearRect(0, 0, items.shape.width, items.shape.height)
    items.shape.width = lineWidth; items.shape.height = lineSize;
    ctx.fillStyle = items.paintColor
    ctx.fillRect(lineWidth / 2, 0, lineWidth, lineSize);
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
    } else print("else")

    // add current painting to the dataset
    if (showMessage)
        dataset = dataset.concat({"imageNumber": 1, "url": items.canvas.toDataURL()})

    // save the dataset to json file
    if (!items.file.write(JSON.stringify(dataset),userFile)) {
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
    if(numberOfLevel <= ++currentLevel ) {
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
