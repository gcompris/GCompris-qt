/* GCompris - tangram.js
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe / Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
    initLevel()
}

function stop() {
}

function initLevel() {
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
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

function getDistance(ix, iy, jx, jy) {
    return Math.sqrt(Math.pow((ix - jx), 2) + Math.pow((iy - jy), 2))
}

function dumpTans(tans) {
    console.log("== tans ==")
    for(var i = 0; i < tans.length; i++) {
        console.log(tans[i].img, tans[i].x, tans[i].y, tans[i].rotation, tans[i].flipping)
    }
}

/* Returns the [x, y] coordinate of the closest point */
function getClosest(point) {
    var nbpiece = items.currentTans.pieces.length
    var closestItem
    var closestDist = 1
    for(var i = 0; i < nbpiece; i++) {
        var p1 = items.currentTans.pieces[i]
        var dist = getDistance(p1.x, p1.y, point[0], point[1])
        if(dist < closestDist) {
            closestDist = dist
            closestItem = p1
        }
    }

    if(closestDist < 0.1)
        return [closestItem.x, closestItem.y]
    return
}

function check() {
    var nbpiece = items.currentTans.pieces.length
    var userTans = items.userList.asTans()
    for(var i = 0; i < nbpiece; i++) {
        var p1 = items.currentTans.pieces[i]
        var ok = false
        for(var j = 0; j < nbpiece; j++) {
            var p2 = userTans[j]
            // Check type distance and rotation are close enough
            if(p1.img === p2.img &&
                    p1.flipping == p2.flipping &&
                    getDistance(p1.x, p1.y, p2.x, p2.y) < 0.01 &&
                    p1.rotation === p2.rotation ) {
                ok = true
                break
            }
        }
        if(!ok)
            return false
    }
    return true
}

function toDataset() {
    var nbpiece = items.currentTans.pieces.length
    var userTans = items.userList.asTans()
    var tanss = '            {\n' +
                "                'bg': '',\n" +
                "                'name': '" + items.currentTans.name + "',\n" +
                "                'colorMask': '#999',\n" +
                "                'pieces': [\n"
    for(var i = 0; i < nbpiece; i++) {
        var p1 = items.currentTans.pieces[i]
        var p2 = userTans[i]
        tanss += '                    {' + '\n' +
                "                        'img': '" + p1.img + "',\n" +
                "                        'flippable': " + p1.flippable + ',\n' +
                "                        'flipping': " + p2.flipping + ',\n' +
                "                        'height': " + p1.height + ',\n' +
                "                        'initFlipping': " + p1.initFlipping + ',\n' +
                "                        'initRotation': " + p1.initRotation + ',\n' +
                "                        'initX': " + p1.initX + ',\n' +
                "                        'initY': " + p1.initY + ',\n' +
                "                        'moduloRotation': " + p1.moduloRotation + ',\n' +
                "                        'rotation': " + p2.rotation + ',\n' +
                "                        'width': " + p1.width + ',\n' +
                "                        'x': " + p2.x + ',\n' +
                "                        'y': " + p2.y + '\n' +
                "                    },\n";
    }
    tanss += '                ]\n' +
             '            },\n'
    return(tanss)
}

/* In edition mode arrow keys allow the move by 1 pixels in any direction */
function processPressedKey(event) {

    if ( items.editionMode && items.selectedItem && items.selectedItem.selected) {
        /* Move the player */
        switch (event.key) {
        case Qt.Key_Right:
            items.selectedItem.x += 1
            event.accepted = true
            break
        case Qt.Key_Left:
            items.selectedItem.x -= 1
            event.accepted = true
            break
        case Qt.Key_Up:
            items.selectedItem.y -= 1
            event.accepted = true
            break
        case Qt.Key_Down:
            items.selectedItem.y += 1
            event.accepted = true
            break
        }
    }
}

