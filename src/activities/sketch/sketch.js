/* GCompris - sketch.js
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick as Quick
.import GCompris 1.0 as GCompris

var url = "qrc:/gcompris/src/activities/sketch/resource/";
var items;
var currentLevel = 0;

var canvasWidth = 1;
var canvasHeight = 1;
var undo = [];
var redo = [];

var backgroundImageSet = [
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

var extensions = ["*.svg", "*.png", "*.jpg", "*.jpeg", "*.webp"];

var savedImages = [];

function start(items_) {
    items = items_;
    currentLevel = 0;
    initLevel();
    // items.foldablePanels.colorUpdate();
}

function stop() {
    items.canvasArea.width = items.canvasArea.height = 0
}

function initLevel() {
    resetUndo();
    resetRedo();
    initCanvas();
    items.canvasArea.init();
    items.canvasLocked = false;
}

// set fixed canvas size at init to avoid various bugs...
function initCanvas() {
    // size to be rounded to smallest even number to avoid bugs with software renderer...
    canvasWidth = 2 * parseInt(items.layoutArea.width / 2);
    canvasHeight = 2 * parseInt(items.layoutArea.height / 2);
    items.canvasArea.width = canvasWidth;
    items.canvasArea.height = canvasHeight;
    items.canvasColor.color = items.backgroundColor
    items.canvasImage.source = "";
    items.tempCanvas.initContext();
    //add empty undo item to restore empty canvas
    items.tempCanvas.paintActionFinished();
}


// function fillCanvas() {
//     // init white background by default
//     items.canvasLocked = true;
//     items.tempCanvas.ctx = items.tempCanvas.getContext("2d");
//     items.tempCanvas.ctx.globalAlpha = 1;
//     items.tempCanvas.ctx.fillStyle = "white";
//     items.tempCanvas.ctx.fillRect(0, 0, canvasWidth, canvasHeight);
//     items.tempCanvas.requestPaint();
// }

// function drawUrlImage() {
//     items.canvas.ctx = items.canvas.getContext("2d");
//     items.canvas.ctx.globalCompositeOperation = "source-over";
//     items.canvas.ctx.globalAlpha = 1.0;
//     items.canvas.loadImage(items.urlImage)
//     console.log("drawUrlImage called")
// }

function pushToUndo(undoPath) {
    // push last snapshot png to UNDO stack
    undo.push(undoPath);
    // undo size hardcoded to 11 to limit memory use as it can easily get too heavy.
    if(undo.length > 11) {
        undo.shift();
    }
    items.undoIndex += 1;
    if(items.undoIndex > 11)
        items.undoIndex = 1
    console.log("undo length is " + undo.length)
    console.log("undo index is " + items.undoIndex)
}

function resetUndo() {
    if(undo.length > 0) {
        undo = [];
    }
    items.undoIndex = 0;
}

function resetRedo() {
    if(redo.length > 0) {
        redo = [];
    }
}

function undoAction() {
    if(undo.length > 1) {
        items.scrollSound.play();
        items.canvasLocked = true;
        redo.push(undo.pop());
        items.canvasImageSource = undo[undo.length - 1];
        items.canvasImage.source = items.canvasImageSource
        items.undoIndex -= 1
        if(items.undoIndex < 0)
            items.undoIndex = 10
        items.canvasLocked = false;
        console.log("undo length is " + undo.length)
        console.log("undo index is " + items.undoIndex)
    }
}

function redoAction() {
    if(redo.length > 0) {
        items.scrollSound.play();
        items.canvasLocked = true;
        items.canvasImageSource = redo.pop();
        items.canvasImage.source = items.canvasImageSource
        pushToUndo(items.canvasImageSource);
        items.canvasLocked = false;
    }
}


