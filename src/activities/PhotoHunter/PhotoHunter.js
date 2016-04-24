/* GCompris - PhotoHunter.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
                "imageName": "photo1.svg",
                "coordinates": [[12,5],[75,1170],[343,1375]],
                "name": ["photo1_add1.svg","photo1_add2.svg","photo1_add3.svg"],
                "radius": [0.5,0.25,1],
                "dim": [[1.25,1.25],[0.35,0.4],[0.9,0.9]]
            },
            {
                "imageName": "photo2.svg",
                "coordinates": [[949.5,268.5],[915,1555],[510,1300]],
                "name": ["photo2_add1.svg","photo2_add2.svg","photo2_add3.svg"],
                "radius": [0.7,0.7,1.7],
                "dim": [[0.85,0.92],[0.75,0.6],[1.25,2]]
            },
            {
                "imageName": "photo3.svg",
                "coordinates": [[800,40],[593,1450]],
                "name": ["photo3_add1.svg","photo3_add2.svg"],
                "radius": [1.8,0.5],
                "dim": [[2.6,1],[0.8,0.65]]
            },
            {
                "imageName": "photo4.svg",
                "coordinates": [[975,140],[680,720],[570,1580],[220,650]],
                "name": ["photo4_add1.svg","photo4_add2.svg","photo4_add3.svg","photo4_add4.svg"],
                "radius": [0.2,0.25,1.3,0.7],
                "dim": [[0.3,0.3],[0.3,0.4],[1.3,0.6],[1,1]]
            },
            {
                "imageName": "photo5.svg",
                "coordinates": [[540,200],[335,1228],[600,1150],[680,1330]],
                "name": ["photo5_add1.svg","photo5_add2.svg","photo5_add3.svg","photo5_add4.svg"],
                "radius": [0.25,1,0.25,1],
                "dim": [[0.5,0.5],[0.25,0.25],[0.5,0.5],[1.3,0.6]]
            },
            {
                "imageName": "photo6.svg",
                "coordinates": [[130,450],[825,234],[950,1450]],
                "name": ["photo6_add1.svg","photo6_add2.svg","photo6_add3.svg"],
                "radius": [1,0.7,0.7],
                "dim": [[1.5,1.5],[0.8,0.8],[1,1]]
            },
            {
                "imageName": "photo7.svg",
                "coordinates": [[70,600],[950,1120],[380,815]],
                "name": ["photo7_add1.svg","photo7_add2.svg","photo7_add3.svg"],
                "radius": [1,1,1],
                "dim": [[1.6,0.8],[1.3,0.45],[0.3,0.41]]
            },
            {
                "imageName": "photo8.svg",
                "coordinates": [[445,1135],[17,1300],[782,670],[98,1002],[527,415],[337,725]],
                "name": ["photo8_add1.svg","photo8_add2.svg","photo8_add3.svg","photo8_add4.svg","photo8_add5.svg","photo8_add6.svg"],
                "radius": [0.5,0.5,0.75,0.5,0.15,0.15],
                "dim": [[0.8,0.3],[0.6,0.6],[0.8,0.8],[0.85,0.3],[0.178,0.25],[0.25,0.25]]
            },
            {
                "imageName": "photo9.svg",
                "coordinates": [[275,345],[1013,1322],[595,1530]],
                "name": ["photo9_add1.svg","photo9_add2.svg","photo9_add3.svg"],
                "radius": [0.15,0.15,0.7],
                "dim": [[0.25,0.25],[0.25,0.25],[1,0.15]]
            },
            {
                "imageName": "photo10.svg",
                "coordinates": [[565,1120],[595,1500],[680,433],[760,971]],
                "name": ["photo10_add1.svg","photo10_add1.svg","photo10_add2.svg","photo10_add3.svg"],
                "radius": [0.35,0.35,0.5,0.5],
                "dim": [[0.6,0.55],[0.6,0.55],[0.6,0.8],[0.35,0.6]]
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
        items.img1.repeater.itemAt(i).opacity = items.img1.show ? 1 : 0
        items.img2.repeater.itemAt(i).opacity = items.img2.show ? 1 : 0

        items.img1.repeater.itemAt(i).source = url + dataset[currentLevel].name[i]
        items.img2.repeater.itemAt(i).source = url + dataset[currentLevel].name[i]

        items.img1.repeater.itemAt(i).sourceSize.width = dataset[currentLevel].radius[i] * 200
        items.img1.repeater.itemAt(i).sourceSize.height = dataset[currentLevel].radius[i] * 200

        items.img2.repeater.itemAt(i).sourceSize.width = dataset[currentLevel].radius[i] * 200
        items.img2.repeater.itemAt(i).sourceSize.height = dataset[currentLevel].radius[i] * 200

        items.img1.repeater.itemAt(i).widthScale = dataset[currentLevel].dim[i][0]
        items.img1.repeater.itemAt(i).heightScale = dataset[currentLevel].dim[i][1]

        items.img2.repeater.itemAt(i).widthScale = dataset[currentLevel].dim[i][0]
        items.img2.repeater.itemAt(i).heightScale = dataset[currentLevel].dim[i][1]

        items.img1.circleRepeater.itemAt(i).opacity = 0
        items.img2.circleRepeater.itemAt(i).opacity = 0

    }

    items.img1.good = 0
    items.img2.good = 0

    items.total = dataset[currentLevel].coordinates.length

    items.img1.source = url + dataset[currentLevel].imageName
    items.img2.source = url + dataset[currentLevel].imageName
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
