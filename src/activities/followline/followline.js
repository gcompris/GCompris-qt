/* GCompris - followline.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris

var url = "qrc:/gcompris/src/activities/followline/resource/"

var currentLevel = 0
var numberOfLevel = 8
var items
var createdLineParts

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    destroyLineParts()
}

function initLevel() {
    /* Check items.bar because when starting followline at least twice,
     it is undefined (called by FollowLine.qml:onHeightChanged())
    */
    if(!items || !items.bar)
        return

    items.bar.level = currentLevel + 1
    items.currentLock = 0
    destroyLineParts()
    createdLineParts = new Array()
    var width = 40 * GCompris.ApplicationInfo.ratio
    var height = 60 * GCompris.ApplicationInfo.ratio
    var index = 0
    var y = items.fireman.y
    var x = items.fireman.x + items.fireman.width
    var angle = 0
    var directionStep = 0.01 * (currentLevel + 1)
    var direction = directionStep
    do {
        var newy = y + Math.sin(angle) * width * 0.5
        var newx = x + Math.cos(angle) * width * 0.5
        angle += direction
        if(angle > Math.PI / 4)
            direction = - directionStep
        else if(angle < - Math.PI / 4)
            direction = directionStep
        if(y > items.fire.y-items.fire.height/2)
            direction = - directionStep
        else if(y < items.background.height * 0.3)
            direction = directionStep
        createdLineParts[index] =
                createLinePart(index, x, y, width, height,
                               getAngleOfLineBetweenTwoPoints(x, y, newx, newy) * (180 / Math.PI))
        x = newx
        y = newy
        index++
    } while(x < (items.fire.x - 10))
    items.lastLock = index - 1
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function createLinePart(index, x, y, width, height, rotation) {
    var component = Qt.createComponent("qrc:/gcompris/src/activities/followline/LinePart.qml");
    var part = component.createObject(
                items.background,
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
