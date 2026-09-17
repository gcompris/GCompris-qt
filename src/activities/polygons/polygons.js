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
.import QtQuick 2.12 as Quick
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

function deletePoint(pointIndex) {
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
