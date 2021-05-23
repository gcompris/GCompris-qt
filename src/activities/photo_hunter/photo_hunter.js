/* GCompris - photo_hunter.js
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.9 as Quick

var currentLevel = 0
var items
var url = "qrc:/gcompris/src/activities/photo_hunter/resource/"



var dataset = [
            {
                "coordinates": [{x: 12, y:5, r: 0.5, w: 1.25, h: 1.25},
                    {x: 75, y:1170, r: 0.5, w: 0.35, h: 0.4},
                    {x: 343, y:1375, r: 1, w: 0.9, h: 0.9}]
            },
            {
                "coordinates": [{x: 949.5, y:268.5, r: 0.7, w: 0.85, h: 0.92},
                    {x: 915, y:1555, r: 0.7, w: 0.75, h: 0.6},
                    {x: 510, y:1300, r: 1.7, w: 1.25, h: 2}]
            },
            {
                "coordinates": [{x: 800, y:40, r: 1.8, w: 2.6, h: 1},
                    {x: 593, y:1450, r: 0.5, w: 0.8, h: 0.65}]
            },
            {
                "coordinates": [{x: 975, y:140, r: 0.2, w: 0.3, h: 0.3},
                    {x: 680, y:720, r: 0.25, w: 0.3, h: 0.4},
                    {x: 570, y:1580, r: 1.3, w: 1.3, h: 0.6},
                    {x: 220, y:650, r: 0.7, w: 1, h: 1}]
            },
            {
                "coordinates": [{x: 540, y:200, r: 0.25, w: 0.5, h: 0.5},
                    {x: 335, y:1228, r: 1, w: 0.25, h: 0.25},
                    {x: 600, y:1150, r: 0.25, w: 0.5, h: 0.5},
                    {x: 680, y:1330, r: 1, w: 1.3, h: 0.6}]
            },
            {
                "coordinates": [{x: 130, y: 450, r: 1, w: 1.5, h: 1.5},
                    {x: 825, y: 234, r: 0.7, w: 0.8, h: 0.8},
                    {x: 950, y: 1450, r: 0.7, w: 1, h: 1}]
            },
            {
                "coordinates": [{x: 70, y: 600, r: 1, w: 1.6, h: 0.8},
                    {x: 950, y: 1120, r: 1, w: 1.3, h: 0.45},
                    {x: 380, y: 815, r: 1, w: 0.3, h: 0.41}]
            },
            {
                "coordinates": [{x: 445, y: 1135, r: 0.5, w: 0.8, h: 0.3},
                    {x: 17, y: 1300, r: 0.5, w: 0.6, h: 0.6},
                    {x: 782, y: 670, r: 0.75, w: 0.8, h: 0.8},
                    {x: 98, y: 1002, r: 0.5, w: 0.85, h: 0.3},
                    {x: 527, y: 415, r: 0.15, w: 0.178, h: 0.25},
                    {x: 337, y: 725, r: 0.15, w: 0.25, h: 0.25}]
            },
            {
                "coordinates":
                    [{x: 275, y: 345, r: 0.15, w: 0.25, h: 0.25},
                    {x: 1013, y: 1322, r: 0.15, w: 0.25, h: 0.25},
                    {x: 595, y: 1530, r: 0.7, w: 1, h: 0.15}]
            },
            {
                "coordinates": [{x: 565, y:1120, r: 0.35, w: 0.6, h: 0.55},
                    {x: 595, y:1500, r: 0.35, w: 0.6, h: 0.55},
                    {x: 680, y:433, r: 0.5, w: 0.6, h: 0.8},
                    {x: 760, y:971, r: 0.5, w: 0.35, h: 0.6}]
            }
        ]

var numberOfLevel = dataset.length


function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.background.startedHelp = false

    items.problem.hideProblem = !items.showProblem

    setUp()
}

function setUp() {
    loadCoordinate()

    for (var i = 0; i < items.model.length; i++) {
        items.img1.circleRepeater.itemAt(i).opacity = 0
        items.img2.circleRepeater.itemAt(i).opacity = 0
    }

    items.img1.good = 0
    items.img2.good = 0

    items.total = dataset[currentLevel].coordinates.length

    items.img1.source = url + "photo" + (currentLevel+1) + ".svg"
    items.img2.source = url + "photo" + (currentLevel+1) + ".svg"
}

function loadCoordinate() {
    var pointPositions = dataset[currentLevel].coordinates
    var linePropertiesArray = []

    for (var i = 0; i < (pointPositions.length); i++) {
        var lineProperties = []
        lineProperties[0] = pointPositions[i].x
        lineProperties[1] = pointPositions[i].y
        linePropertiesArray[i] = lineProperties
    }
    items.model = linePropertiesArray
}


function photoClicked(item, index) {
    //only if the difference is not yet spotted
    if (items.img2.repeater.itemAt(index).opacity === 0) {

        //activate the particle loader
        items.img1.repeater.itemAt(index).particleLoader.item.burst(40)
        items.img2.repeater.itemAt(index).particleLoader.item.burst(40)

        // show the actual difference on the second image
        items.img2.repeater.itemAt(index).differenceAnimation.start()

        // scale animation for the blue circle
        items.img1.circleRepeater.itemAt(index).scaleAnim.start()
        items.img2.circleRepeater.itemAt(index).scaleAnim.start()

        // set opacity of circle differences to 1
        items.img1.circleRepeater.itemAt(index).opacity = 1
        items.img2.circleRepeater.itemAt(index).opacity = 1

        // all good; check if all the differences have been spotted
        item.good++
        items.background.checkAnswer()
    }
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
