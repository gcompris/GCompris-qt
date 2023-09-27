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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items
var url = "qrc:/gcompris/src/activities/photo_hunter/resource/"


//coordinates are normalized (0 to 1) position/size values of items relative to original image size
var dataset = [
            {
                "coordinates": [{x: 0.037, y: 0.011, w: 0.138, h: 0.138},
                    {x: 0.064, y: 0.707, w: 0.031, h: 0.032},
                    {x: 0.278, y: 0.816, w: 0.104, h: 0.072}]
            },
            {
                "coordinates": [{x: 0.792, y: 0.16, w: 0.082, h: 0.093},
                    {x: 0.77, y: 0.906, w: 0.083, h: 0.06},
                    {x: 0.417, y: 0.759, w: 0.128, h: 0.206}]
            },
            {
                "coordinates": [{x: 0.7, y: 0.09, w: 0.214, h: 0.072},
                    {x: 0.487, y: 0.856, w: 0.134, h: 0.055}]
            },
            {
                "coordinates": [{x: 0.786, y: 0.093, w: 0.059, h: 0.028},
                    {x: 0.553, y: 0.477, w: 0.017, h: 0.044},
                    {x: 0.406, y: 0.929, w: 0.158, h: 0.046},
                    {x: 0.173, y: 0.388, w: 0.087, h: 0.073}]
            },
            {
                "coordinates": [{x: 0.456, y: 0.143, w: 0.038, h: 0.033},
                    {x: 0.28, y: 0.72, w: 0.022, h: 0.023},
                    {x: 0.482, y: 0.686, w: 0.077, h: 0.039},
                    {x: 0.599, y: 0.786, w: 0.139, h: 0.074}]
            },
            {
                "coordinates": [{x: 0.14, y: 0.291, w: 0.139, h: 0.14},
                    {x: 0.659, y: 0.084, w: 0.126, h: 0.082},
                    {x: 0.741, y: 0.872, w: 0.128, h: 0.072}]
            },
            {
                "coordinates": [{x: 0.049, y: 0.265, w: 0.155, h: 0.05},
                    {x: 0.507, y: 0.739, w: 0.134, h: 0.049},
                    {x: 0.766, y: 0.405, w: 0.038, h: 0.039}]
            },
            {
                "coordinates": [{x: 0.364, y: 0.665, w: 0.088, h: 0.029},
                    {x: 0.077, y: 0.834, w: 0.047, h: 0.058},
                    {x: 0.663, y: 0.395, w: 0.073, h: 0.054},
                    {x: 0.133, y: 0.503, w: 0.047, h: 0.071},
                    {x: 0.378, y: 0.239, w: 0.015, h: 0.022},
                    {x: 0.439, y: 0.48, w: 0.022, h: 0.015}]
            },
            {
                "coordinates":
                    [{x: 0.096, y: 0.157, w: 0.02, h: 0.017},
                    {x: 0.9, y: 0.891, w: 0.018, h: 0.011},
                    {x: 0.497, y: 0.899, w: 0.098, h: 0.014}]
            },
            {
                "coordinates": [{x: 0.294, y: 0.86, w: 0.106, h: 0.048},
                    {x: 0.032, y: 0.146, w: 0.052, h: 0.022},
                    {x: 0.561, y: 0.25, w: 0.075, h: 0.087},
                    {x: 0.621, y: 0.559, w: 0.056, h: 0.074}]
            }
        ]

var numberOfLevel = dataset.length


function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.background.startedHelp = false
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

    items.total = dataset[items.currentLevel].coordinates.length

    items.img1.source = url + "photo" + (items.currentLevel+1) + ".svg"
    items.img2.source = url + "photo" + (items.currentLevel+1) + ".svg"
}

function loadCoordinate() {
    var pointPositions = dataset[items.currentLevel].coordinates
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
    items.model = []
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.model = []
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
