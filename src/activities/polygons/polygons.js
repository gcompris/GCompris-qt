/* GCompris - polygons.js
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 4
var levelProperties = null
var items

function start(items_) {
    items = items_;
    numberOfLevel = items.tutorialDataset.tutorialLevels.length;
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel();
}

function stop() {
}

function initLevel() {
    items.buttonsBlocked = true;
    items.keyboardCursor.xPosition = 0;
    items.keyboardCursor.yPosition = 0;
    resetShape();
    if(items.isTutorialMode) {
        // setup level tutorial
        levelProperties = items.tutorialDataset.tutorialLevels[items.currentLevel]

        if(levelProperties.introMessage.length != 0) {
            items.tutorialInstruction.index = 0;
            items.tutorialInstruction.intro.clear()
            for(var i = 0; i < levelProperties.introMessage.length; ++ i) {
                items.tutorialInstruction.intro.append({"text": levelProperties.introMessage[i]})
            }
            if(levelProperties.introImage) {
                items.tutorialImage.source = levelProperties.introImage;
            }
            if(levelProperties.instruction) {
                items.instruction.text = levelProperties.instruction;
            }
        } else {
            items.tutorialInstruction.index = -1;
            items.tutorialImage.source = "";
        }
    } else {
        // free mode, hide tutorial
        levelProperties = null;
        items.tutorialInstruction.index = -1;
        items.tutorialImage.source = "";
    }
    items.buttonsBlocked = false;
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function createPoint(xPosition, yPosition) {
    var point = {
        "x": xPosition,
        "y": yPosition
    }
    items.points.append(point);
    items.sceneGrid.requestPaint();
}

function closeShape() {
    var firstPoint = items.points.get(0);
    createPoint(firstPoint.x, firstPoint.y);
    items.isClosed = true;
}

function deletePoint(pointIndex) {
    items.selectedPoint = -1;
    if(items.isClosed) {
        // If last point, simply delete it and the first/duplicate point.
        if(pointIndex === items.points.count - 1) {
            items.points.remove(pointIndex, 1);
            items.points.remove(0, 1);
            items.isClosed = false;
        } else {
            // remove last duplicate/closing point, remove selected point, and move next ones to the start
            items.points.remove(items.points.count - 1, 1);
            items.points.remove(pointIndex, 1);
            var pointsToMove = items.points.count - pointIndex;
            items.points.move(pointIndex, 0, pointsToMove);
            items.isClosed = false
        }

    } else {
        items.points.remove(pointIndex, 1);
    }
    items.sceneGrid.requestPaint();
}

function resetShape() {
    resetKeyboardControls();
    items.points.clear();
    items.isClosed = false;
    items.sceneGrid.requestPaint();
}

function computeAngles() {
    items.polygonAngles = [];
    for(var i = 0; i < items.points.count - 1; i++) {
        var A = (i === 0) ? items.points.get(items.points.count - 2) : items.points.get(i - 1);
        var B = items.points.get(i);
        var C = items.points.get(i + 1);

        var AB = Math.sqrt(Math.pow(B.x - A.x, 2) + Math.pow(B.y - A.y, 2));
        var BC = Math.sqrt(Math.pow(B.x - C.x, 2) + Math.pow(B.y - C.y, 2));
        var AC = Math.sqrt(Math.pow(C.x - A.x, 2) + Math.pow(C.y - A.y, 2));
        // rounded to 2 decimals
        var angle = Math.round((Math.acos((BC*BC + AB*AB - AC*AC) / (2*BC*AB)) * 180) / Math.PI * 100) / 100;
        items.polygonAngles.push(angle);
    }
}

function computeSides() {
    items.polygonSides = [];
    for(var i = 0; i < items.points.count - 1; i++) {
        var point1 = items.points.get(i);
        var point2 = items.points.get(i + 1);
        // rounded to 2 decimals
        var distance = Math.round(Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2)) * 100) / 100;
        items.polygonSides.push(distance);
    }
}

function checkAnswer() {
    items.buttonsBlocked = true;
    if(levelProperties.validate()) {
        items.bonus.good("lion");
    } else {
        items.bonus.bad("lion");
    }
}

function resetKeyboardControls() {
    items.keyboardControls = false;
    items.selectedPoint = -1;
}

function moveCursorToPoint(_x, _y) {
    items.keyboardCursor.xPosition = _x;
    items.keyboardCursor.yPosition = _y;
}

function moveCursorLeft() {
    if(items.keyboardCursor.xPosition <= 0) {
        items.keyboardCursor.xPosition = 10;
    } else {
        --items.keyboardCursor.xPosition
    }
    if(items.selectedPoint != -1) {
        movePoint(items.selectedPoint, items.keyboardCursor.xPosition, items.keyboardCursor.yPosition);
    }
}

function moveCursorRight() {
    if(items.keyboardCursor.xPosition >= 10) {
        items.keyboardCursor.xPosition = 0;
    } else {
        ++items.keyboardCursor.xPosition
    }
    if(items.selectedPoint != -1) {
        movePoint(items.selectedPoint, items.keyboardCursor.xPosition, items.keyboardCursor.yPosition);
    }
}

function moveCursorUp() {
    if(items.keyboardCursor.yPosition <= 0) {
        items.keyboardCursor.yPosition = 10;
    } else {
        --items.keyboardCursor.yPosition
    }
    if(items.selectedPoint != -1) {
        movePoint(items.selectedPoint, items.keyboardCursor.xPosition, items.keyboardCursor.yPosition);
    }
}

function moveCursorDown() {
    if(items.keyboardCursor.yPosition >= 10) {
        items.keyboardCursor.yPosition = 0;
    } else {
        ++items.keyboardCursor.yPosition
    }
    if(items.selectedPoint != -1) {
     movePoint(items.selectedPoint, items.keyboardCursor.xPosition, items.keyboardCursor.yPosition);
    }
}

function movePoint(pointIndex, xDestination, yDestination) {
    items.points.setProperty(pointIndex, "x", xDestination);
    items.points.setProperty(pointIndex, "y", yDestination);
    if(items.isClosed) {
        var lastPointIndex = items.points.count - 1;
        if(pointIndex === 0) {
            items.points.setProperty(lastPointIndex, "x", xDestination);
            items.points.setProperty(lastPointIndex, "y", yDestination);
        } else if(pointIndex === lastPointIndex) {
            items.points.setProperty(0, "x", xDestination);
            items.points.setProperty(0, "y", yDestination);
        }
    }
    items.sceneGrid.requestPaint();
}

function keyboardCreatePoint() {
    if(items.isClosed) {
        return;
    }
    var pointIndex = findPointIndex();
    if(pointIndex === -1) {
        createPoint(items.keyboardCursor.xPosition, items.keyboardCursor.yPosition);
    } else if(items.points.count > 2 &&
        (pointIndex === 0 || pointIndex === items.points.count -1)){
        closeShape();
    }
}

function findPointIndex() {
    var pointIndex = -1;
    for(var i = 0; i < items.points.count; i++) {
        var pointItem = items.points.get(i);
        if(pointItem.x === items.keyboardCursor.xPosition &&
           pointItem.y === items.keyboardCursor.yPosition) {
            pointIndex = i;
            break;
        }
    }
    return pointIndex;
}

function selectPoint() {
    if(items.selectedPoint != -1) {
        items.selectedPoint = -1;
        return;
    }
    items.selectedPoint = findPointIndex();
}

function selectNextPoint() {
    if(items.points.count < 1) {
        return;
    }
    ++items.selectedPoint;
    if(items.selectedPoint >= items.points.count) {
        if(items.isClosed) {
            items.selectedPoint = 1;
        } else {
            items.selectedPoint = 0;
        }
    }
    var selectedPoint = items.points.get(items.selectedPoint);
    items.keyboardCursor.xPosition = selectedPoint.x;
    items.keyboardCursor.yPosition = selectedPoint.y;
}
