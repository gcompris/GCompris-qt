/* GCompris - PhotoHunter.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick port)
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

var currentLevel = 0
var items
var url = "qrc:/gcompris/src/activities/PhotoHunter/resource/"



var dataset = [
            {
                "imageName1": "photo1.svg",
                "imageName2": "photo2.svg",
                "coordinates": [[27,25],[37,1120],[325,1360]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo4.svg",
                "imageName2": "photo5.svg",
                "coordinates": [[930,255],[915,1515],[500,1335]],
                "radius": [1,1,1.7],
                "dim": [[1,1],[1,1],[1,1.5]]
            },
            {
                "imageName1": "photo1.svg",
                "imageName2": "photo3.svg",
                "coordinates": [[30,840],[505,1030],[470,1360]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo8.svg",
                "imageName2": "photo9.svg",
                "coordinates": [[800,40],[593,1375]],
                "radius": [1,1],
                "dim": [[1,1],[1,1]]
            },
            {
                "imageName1": "photo10.svg",
                "imageName2": "photo11.svg",
                "coordinates": [[965,93],[633,655],[585,1560]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo12.svg",
                "imageName2": "photo13.svg",
                "coordinates": [[525,145],[280,1160],[600,1052]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo14.svg",
                "imageName2": "photo15.svg",
                "coordinates": [[183,500],[795,215],[950,1450]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo16.svg",
                "imageName2": "photo17.svg",
                "coordinates": [[70,600],[950,1120],[325,760]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo18.svg",
                "imageName2": "photo19.svg",
                "coordinates": [[435,1075],[17,1195],[782,670],[90,945],[490,400],[300,620]],
                "radius": [1,1,1,1,1,1],
                "dim": [[1,1],[1,1],[1,1],[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo20.svg",
                "imageName2": "photo21.svg",
                "coordinates": [[275,345],[1013,1232],[595,1460]],
                "radius": [1,1,1],
                "dim": [[1,1],[1,1],[1,1]]
            },
            {
                "imageName1": "photo22.svg",
                "imageName2": "photo23.svg",
                "coordinates": [[668,403],[727,930],[565,1120],[595,1500]],
                "radius": [1,1,1,1],
                "dim": [[1,1],[1,1],[1,1],[1,1]]
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

    setUp()
}

function setUp() {
    loadCoordinate()

    for (var i=0;i<items.model.length;i++) {
        items.img1.repeater.itemAt(i).opacity = 0
        items.img2.repeater.itemAt(i).opacity = 0

        items.img1.repeater.itemAt(i).sourceSize.width = dataset[currentLevel].radius[i] * 200
        items.img1.repeater.itemAt(i).sourceSize.height = dataset[currentLevel].radius[i] * 200

        items.img2.repeater.itemAt(i).sourceSize.width = dataset[currentLevel].radius[i] * 200
        items.img2.repeater.itemAt(i).sourceSize.height = dataset[currentLevel].radius[i] * 200

        items.img1.repeater.itemAt(i).widthScale = dataset[currentLevel].dim[i][0]
        items.img1.repeater.itemAt(i).heightScale = dataset[currentLevel].dim[i][1]

        items.img2.repeater.itemAt(i).widthScale = dataset[currentLevel].dim[i][0]
        items.img2.repeater.itemAt(i).heightScale = dataset[currentLevel].dim[i][1]

        items.img1.repeater.itemAt(i).scale = dataset[currentLevel].radius[i]
        items.img2.repeater.itemAt(i).scale = dataset[currentLevel].radius[i]
    }

    items.img1.good = 0
    items.img2.good = 0

    items.total = dataset[currentLevel].coordinates.length

    items.img1.source = url + dataset[currentLevel].imageName1
    items.img2.source = url + dataset[currentLevel].imageName2
}

function loadCoordinate() {
    var pointPositions = dataset[currentLevel].coordinates
    var linePropertiesArray = []

    for (var i = 0; i < (pointPositions.length); i++) {
        var lineProperties = []
        lineProperties[0] = pointPositions[i][0]
        lineProperties[1] = pointPositions[i][1]
        linePropertiesArray[i] = lineProperties
    }
    items.model = linePropertiesArray
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
