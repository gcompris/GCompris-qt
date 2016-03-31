/* GCompris - photo_hunter.qml
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
var url = "qrc:/gcompris/src/activities/photo_hunter/resource/"


var dataset = [
            {
                "imageName1": "images/photo1.svg",
                "imageName2": "images/photo2.svg",
                "coordinates": [[27,25],[37,1120],[325,1360]]
            },
            {
                "imageName1": "images/photo4.svg",
                "imageName2": "images/photo5.svg",
                "coordinates": [[930,255],[915,1515],[500,1360]]
            },
            {
                "imageName1": "images/photo1.svg",
                "imageName2": "images/photo3.svg",
                "coordinates": [[30,840],[505,1030],[470,1360]]
            },
            {
                "imageName1": "images/photo8.svg",
                "imageName2": "images/photo9.svg",
                "coordinates": [[800,40],[570,1370]]
            },
            {
                "imageName1": "images/photo10.svg",
                "imageName2": "images/photo11.svg",
                "coordinates": [[965,93],[633,655],[585,1560]]
            },
            {
                "imageName1": "images/photo12.svg",
                "imageName2": "images/photo13.svg",
                "coordinates": [[525,145],[280,1160],[600,1052]]
            },
            {
                "imageName1": "images/photo14.svg",
                "imageName2": "images/photo15.svg",
                "coordinates": [[183,500],[795,215],[950,1450]]
            },
            {
                "imageName1": "images/photo16.svg",
                "imageName2": "images/photo17.svg",
                "coordinates": [[70,600],[950,1120],[325,760]]
            },
            {
                "imageName1": "images/photo18.svg",
                "imageName2": "images/photo19.svg",
                "coordinates": [[435,1075],[17,1195],[782,670],[90,945],[490,400],[300,620]]
            },
            {
                "imageName1": "images/photo20.svg",
                "imageName2": "images/photo21.svg",
                "coordinates": [[275,345],[1013,1232],[595,1460]]
            },
            {
                "imageName1": "images/photo22.svg",
                "imageName2": "images/photo23.svg",
                "coordinates": [[668,403],[727,930],[565,1120],[595,1500]]
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

    //reset the opacity of the circles
    for (var i=0;i<items.model.length;i++) {
        items.img1.repeater.itemAt(i).opacity = 0
        items.img2.repeater.itemAt(i).opacity = 0
        //radius===how big the circle will be
        //items.img1.repeater.itemAt(i).width*=levelData.levels[items.currentSubLevel].radius[i]
        //items.img1.repeater.itemAt(i).height*=levelData.levels[items.currentSubLevel].radius[i]
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
