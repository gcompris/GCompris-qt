/* GCompris - tangram.js
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
.import QtQuick 2.0 as Quick

var url = "qrc:/gcompris/src/activities/tangram/resource/"

/* dataset format
  for each piece we have:
  - piece file name
  - flipping (0 or 1)
  - x
  - y
  - rotation
*/


//back_road.svg  cabin.svg  container.svg  front_road.svg
var dataset = [
            // Level 1
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.519,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.75,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.346,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.05,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.020,
                        'y': 0.354,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.0,
                        'initY': 0.0,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.082,
                        'y': 0.587,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.7,
                        'initY': 0.1,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.565,
                        'y': 0.557,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.3,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 0
                    }
                ]
            },
            // Level 2
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.519,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.75,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.346,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.05,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.020,
                        'y': 0.354,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.0,
                        'initY': 0.0,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.082,
                        'y': 0.587,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.7,
                        'initY': 0.1,
                        'initRotation': 270,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.565,
                        'y': 0.557,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.3,
                        'initY': 0.7,
                        'initRotation': 90,
                        'initFlipping': 1
                    }
                ]
            },
            // Level 3
            {
                'bg': 'truck/traffic_bg.svg',
                'pieces': [
                    {
                        'img': 'truck/engine.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.519,
                        'width': 0.233,
                        'height': 0.109,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0,
                        'initX': 0.75,
                        'initY': 0.7,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'truck/cabin.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.744,
                        'y': 0.346,
                        'width': 0.207,
                        'height': 0.178,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0,
                        'initX': 0.05,
                        'initY': 0.7,
                        'initRotation': 45,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/container.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.020,
                        'y': 0.354,
                        'width': 0.676,
                        'height': 0.271,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0,
                        'initX': 0.0,
                        'initY': 0.0,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'truck/back_road.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.082,
                        'y': 0.587,
                        'width': 0.198,
                        'height': 0.092,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0,
                        'initX': 0.7,
                        'initY': 0.1,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'truck/front_road.svg',
                        'flippable': 1,
                        'flipping': 0,
                        'x': 0.565,
                        'y': 0.557,
                        'width': 0.403,
                        'height': 0.121,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0,
                        'initX': 0.3,
                        'initY': 0.7,
                        'initRotation': 270,
                        'initFlipping': 0
                    }
                ]
            },
                        // Level 1
            {
                'bg': 'car1/car.svg',
                'pieces': [
                    {
                        'img': 'car1/windshield.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.211,
                        'y': 0.196,
                        'width': 0.563,
                        'height': 0.227,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.02,
                        'initY': 0.02,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/tire_right.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.163,
                        'y': 0.647,
                        'width': 0.126,
                        'height': 0.147,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.8,
                        'initY': 0.05,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/tire_right.svg',
                        'flippable': 0,
                        'flipping': 1,
                        'x': 0.719,
                        'y': 0.647,
                        'width': 0.126,
                        'height': 0.147,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.6,
                        'initY': 0.05,
                        'initRotation': 0,
                        'initFlipping': 1
                    },
                    {
                        'img': 'car1/bumper.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.147,
                        'y': 0.564,
                        'width': 0.710,
                        'height': 0.184,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.05,
                        'initY': 0.8,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/grille.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.323,
                        'y': 0.575,
                        'width': 0.365,
                        'height': 0.51,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.2,
                        'initY': 0.8,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 0,
                        'x': 0.715,
                        'y': 0.444,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.8,
                        'initY': 0.8,
                        'initRotation': 0,
                        'initFlipping': 0
                    },
                    {
                        'img': 'car1/headlights.svg',
                        'flippable': 0,
                        'flipping': 1,
                        'x': 0.155,
                        'y': 0.444,
                        'width': 0.134,
                        'height': 0.125,
                        'rotation': 0,
                        'moduloRotation': 360,
                        'opacity': 0.1,
                        'initX': 0.8,
                        'initY': 0.25,
                        'initRotation': 0,
                        'initFlipping': 1
                    }
                ]
            }
        ]


var currentLevel = 0
var numberOfLevel = dataset.length
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
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
    //dumpTans(userTans)
    console.log('== check ==')
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
            }
            if(p1.img === p2.img)
                if(ok)
                    console.log("piece ", p1.img, "OK")
                else
                    console.log("piece ", p1.img, getDistance(p1.x, p1.y, p2.x, p2.y), 'rot exp/got', p1.rotation, '/', p2.rotation, "NOK")
        }
        if(!ok)
            return false
    }
    return true
}
