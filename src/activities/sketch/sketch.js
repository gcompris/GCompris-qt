/* GCompris - sketch.js
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick as Quick
.import core 1.0 as GCompris

var url = "qrc:/gcompris/src/activities/sketch/resource/";
var items;
var currentLevel = 0;

var canvasWidth = 1;
var canvasHeight = 1;
var undo = [];
var redo = [];
var currentSnapshot = "";

var backgroundImageSet = [
    "qrc:/gcompris/src/core/resource/cancel_white.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo1.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo2.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo3.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo4.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo5.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo6.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo7.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo8.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo9.svg",
    "qrc:/gcompris/src/activities/photo_hunter/resource/photo10.svg",
    "qrc:/gcompris/src/activities/algebra_by/resource/background.svg",
    "qrc:/gcompris/src/activities/align4_2players/resource/background.svg",
    "qrc:/gcompris/src/activities/bargame/resource/background.svg",
    "qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg",
    "qrc:/gcompris/src/activities/categorization/resource/background.svg",
    "qrc:/gcompris/src/activities/click_on_letter/resource/background.svg",
    "qrc:/gcompris/src/activities/color_mix/resource/background.svg",
    "qrc:/gcompris/src/activities/colors/resource/background.svg",
    "qrc:/gcompris/src/activities/crane/resource/background.svg",
    "qrc:/gcompris/src/activities/enumerate/resource/background.svg",
    "qrc:/gcompris/src/activities/family/resource/background.svg",
    "qrc:/gcompris/src/activities/followline/resource/background.svg",
    "qrc:/gcompris/src/activities/football/resource/background.svg",
    "qrc:/gcompris/src/activities/gletters/resource/background.svg",
    "qrc:/gcompris/src/activities/hangman/resource/background.svg",
    "qrc:/gcompris/src/activities/hanoi_real/resource/background.svg",
    "qrc:/gcompris/src/activities/instruments/resource/background.svg",
    "qrc:/gcompris/src/activities/land_safe/resource/background.svg",
    "qrc:/gcompris/src/activities/magic-hat-minus/resource/background.svg",
    "qrc:/gcompris/src/activities/menu/resource/background.svg",
    "qrc:/gcompris/src/activities/missing-letter/resource/background.svg",
    "qrc:/gcompris/src/activities/mosaic/resource/background.svg",
    "qrc:/gcompris/src/activities/redraw/resource/background.svg",
    "qrc:/gcompris/src/activities/scalesboard/resource/background.svg",
    "qrc:/gcompris/src/activities/smallnumbers/resource/background.svg",
    "qrc:/gcompris/src/activities/smallnumbers2/resource/background.svg",
    "qrc:/gcompris/src/activities/submarine/resource/background.svg",
    "qrc:/gcompris/src/activities/sudoku/resource/background.svg",
    "qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg",
    "qrc:/gcompris/src/activities/wordsgame/resource/background.svg",
    "qrc:/gcompris/src/activities/color_mix/resource/background2.svg"
    ];

var imageToLoad = "";

function start(items_) {
    items = items_;
    currentLevel = 0;
    initLevel();
}

function stop() {
    items.canvasArea.width = 0;
    items.canvasArea.height = 0;
}

function initLevel() {
    resetUndo();
    resetRedo();
    initCanvas();
    items.canvasArea.init();
    items.isSaved = true;
    items.canvasLocked = false;
}

function resetLevel() {
    items.resetRequested = false;
    items.backgroundColor = Qt.rgba(1,1,1,1);
    items.backgroundToLoad = "";
    initLevel();
}

// set fixed canvas size at init to avoid various bugs...
function initCanvas() {
    // size to be rounded to smallest even number to avoid bugs with software renderer...
    canvasWidth = 2 * parseInt(items.layoutArea.width / 2);
    canvasHeight = 2 * parseInt(items.layoutArea.height / 2);
    items.canvasArea.width = canvasWidth;
    items.canvasArea.height = canvasHeight;
    items.canvasColor.color = items.backgroundColor;
    items.canvasImage.source = "";
    items.tempCanvas.initContext();
    //add empty undo item to restore empty canvas
    items.tempCanvas.paintActionFinished();
}

function pushToUndo(undoPath) {
    // push last snapshot png to UNDO stack
    undo.push(undoPath);
    currentSnapshot = undoPath;
    // undo size hardcoded to 11 to limit memory use as it can easily get too heavy.
    if(undo.length > 11) {
        undo.shift();
    }
    items.undoIndex += 1;
    if(items.undoIndex > 11) {
        items.undoIndex = 1;
    }
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
        items.canvasImage.source = items.canvasImageSource;
        currentSnapshot = items.canvasImage.source
        items.undoIndex -= 1;
        if(items.undoIndex < 0) {
            items.undoIndex = 10;
        }
        items.canvasLocked = false;
    }
}

function redoAction() {
    if(redo.length > 0) {
        items.scrollSound.play();
        items.canvasLocked = true;
        items.canvasImageSource = redo.pop();
        items.canvasImage.source = items.canvasImageSource;
        currentSnapshot = items.canvasImage.source
        pushToUndo(items.canvasImageSource);
        items.canvasLocked = false;
    }
}

function loadImage() {
    items.canvasImage.source = "";
    items.loadedImage.sourceSize.width = undefined;
    items.loadedImage.sourceSize.height = undefined;
    items.loadedImage.source = imageToLoad;
    imageToLoad = "";
    items.loadedImage.visible = true;
    initLevel();
}

function loadBackground() {
    items.canvasImage.source = "";
    items.loadedImage.sourceSize.width = items.loadedImage.width;
    items.loadedImage.sourceSize.height = items.loadedImage.height;
    items.loadedImage.source = items.backgroundToLoad;
    items.loadedImage.visible = true;
    initLevel();
}

function requestNewImage() {
    if(items.isSaved) {
        newImage();
    } else {
        items.newImageDialog.active = true;
    }
}

function newImage() {
    items.backgroundColor = items.newBackgroundColor;
    if(imageToLoad != "") {
        loadImage();
    } else if(items.backgroundToLoad != "") {
        loadBackground();
    } else {
        initLevel();
    }
}

function saveImageDialog() {
    items.creationHandler.saveWindow(currentSnapshot);
}

function openImageDialog() {
    items.creationHandler.loadWindow();
}
