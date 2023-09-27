/* GCompris - followline.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/followline/resource/"

var numberOfLevel = 8
var items
var createdLineParts
var movedOut = true
// used to bypass initLevel triggered on stop by onHeightChanged...
var isStopped = false

function start(items_) {
    isStopped = false
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    isStopped = true
    items.lineBrokenTimer.stop()
    destroyLineParts()
}

function initLevel() {
    /* Check items.bar because when starting followline at least twice,
     it is undefined (called by FollowLine.qml:onHeightChanged())
    */
    if(!items || isStopped)
        return

    items.currentLock = 0
    movedOut = true
    destroyLineParts()
    createdLineParts = new Array()
    var width = 40 * GCompris.ApplicationInfo.ratio
    var nextWidth = Math.max(items.verticalLayout ? items.lineArea.height / 30 : items.lineArea.width / 40,
                              5 * GCompris.ApplicationInfo.ratio)
    var height = 60 * GCompris.ApplicationInfo.ratio
    var index = 0
    var y = 0
    var x = 0
    var angle = 0
    var directionStep = items.verticalLayout ? 0.02 * (items.currentLevel + 1) * 0.5 : 0.01 * (items.currentLevel + 1)
    var direction = directionStep
    if(!items.verticalLayout) {
        do {
            if(index != 0) {
                width = nextWidth
            }
            var newy = y + Math.sin(angle) * width * 0.5
            var newx = x + Math.cos(angle) * width * 0.5
            angle += direction
            if(angle > Math.PI / 4)
                direction = - directionStep
            else if(angle < - Math.PI / 4)
                direction = directionStep
            if(y > items.lineArea.height * 0.5)
                direction = - directionStep
            else if(y < 0)
                direction = directionStep
            createdLineParts[index] =
                            createLinePart(index, x, y, width, height,
                                           getAngleOfLineBetweenTwoPoints(x, y, newx, newy) * (180 / Math.PI))
            x = newx
            y = newy
            index++
        } while(x < (items.lineArea.width - 10))
    } else {
        do {
            if(index != 0) {
                width = nextWidth
            }
            var newy = y + Math.sin(angle) * width * 0.5
            var newx = x + Math.cos(angle) * width * 0.5
            angle += direction
            if(angle > Math.PI / 2)
                direction = - directionStep
            else if(angle < - Math.PI / 4)
                direction = directionStep
            createdLineParts[index] =
                            createLinePart(index, x, y, width, height,
                                           getAngleOfLineBetweenTwoPoints(x, y, newx, newy) * (180 / Math.PI))
            x = newx
            y = newy
            index++
        } while(x < (items.lineArea.width - 10))

    }
    items.lastLock = index - 1
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function createLinePart(index, x, y, width, height, rotation) {
    var component = Qt.createComponent("qrc:/gcompris/src/activities/followline/LinePart.qml");
    var part = component.createObject(
                items.lineArea,
                {
                    "audioEffects": items.audioEffects,
                    "x": x,
                    "y": y,
                    "width": width,
                    "height": height,
                    "rotation": rotation,
                    "z": index,
                    "items": items,
                    "index": index
                });

    if (part === null) {
        // Error Handling
        console.log("Error creating LinePart object");
    }
    return part;
}

// Determines the angle of a straight line drawn between point one and two.
// The number returned, which is a float in radian,
// tells us how much we have to rotate a horizontal line clockwise
// for it to match the line between the two points.
function getAngleOfLineBetweenTwoPoints(x1, y1, x2, y2) {
    var xDiff = x2 - x1;
    var yDiff = y2 - y1;
    return Math.atan2(yDiff, xDiff);
}

function destroyLineParts() {
    if (createdLineParts) {
        for(var i = 0;  i < createdLineParts.length; ++i) {
            createdLineParts[i].destroy()
        }
        createdLineParts.length = 0
    }
}

function cursorMovedOut() {
    movedOut = true;
    if(items.currentLock > 0)
        items.currentLock--;
}

function playAudioFx() {
    if(!items.audioEffects.playing)
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/darken.wav");
}
