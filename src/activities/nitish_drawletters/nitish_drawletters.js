/* GCompris - nitish_drawletters.js
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
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

var currentLevel = 0
var items
var clickanddrawflag

var pointPositions = []
var linePropertiesArray = []



// array of datasets
var dataset = [


            {
                "imageName1": "A2.svg",
                "imageName2": "A1.svg",
                "coordinates": [[324,31],[402,29],[606,422],[534,422],[469,306],[259,303],[201,422],[131,422],[324,31]]
            }
,

            {
                "imageName1": "d2.svg",
                "imageName2": "d1.svg",
                "coordinates":   [[102,29],[383,36],[502,115],[528,229],[486,327],[366,383],[232,391],[102,389],[102,29]]
            },

            {
                "imageName1": "K2.svg",
                "imageName2": "K1.svg",
                "coordinates": [[159,20],[96,23],[99,437],[164,437],[162,294],[239,232],[407,439],[491,437],[283,191],[480,23],[397,23],[160,227],[159,20]]
            },

            {
                "imageName1": "S2.svg",
                "imageName2": "S1.svg",
                "coordinates": [[398,154],[470,150],[405,70],[271,46],[110,75],[64,150],[163,224],[359,259],[413,300],[343,356],[205,357],[129,319],[110,281],[42,287],[80,360],[214,401],[399,388],[484,309],[446,236],[277,192],[147,159],[144,113],[251,87],[350,100],[381,119],[398,154]]
            }
            ,
            {
                "imageName1": "P2.svg",
                "imageName2": "P1.svg",
                "coordinates":[[94,33],[399,40],[487,132],[433,243],[309,268],[162,270],[159,432],[91,432],[94,33]]
            },
            {
                "imageName1": "arth1.svg",
                "imageName2": "arth2.svg",
                "coordinates": [[452,128],[510,42],[646,17],[751,59],[762,181],[658,272],[531,367],[773,366],[776,408],[440,408],[490,328],[617,239],[702,160],[690,77],[563,65],[518,132],[452,128]] },
            {
                "imageName1": "arth3.svg",
                "imageName2": "arth4.svg",
                "coordinates": [[509,48],[789,49],[792,115],[703,248],[632,449],[573,452],[604,321],[677,182],[731,99],[508,94],[509,48]] }

        ]


//url to access sound & images
var url = "qrc:/gcompris/src/activities/nitish_drawletters/resource/"
var numberOfLevel = dataset.length




function start(items_, clickanddrawflag_) {
    items = items_
    clickanddrawflag = clickanddrawflag_
    currentLevel = 0
    initLevel()
}



function stop() {

}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.pointIndexToClick = 0
    loadCoordinates()
    loadBackgroundImage()
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




//function to draw segment
function drawSegment(pointIndex) {
    if (pointIndex === items.pointIndexToClick)
    {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/scroll.wav")
        items.pointImageRepeater.itemAt(pointIndex).opacity = 0

        if (clickanddrawflag) {
            if (pointIndex < items.pointImageRepeater.count-1) {
                 items.pointImageRepeater.itemAt(pointIndex+1).highlight = true
            }
        }

        // Draw the line from pointIndex - 1 to pointIndex
        if (pointIndex > 0) {
            items.segmentsRepeater.itemAt(pointIndex-1).opacity = 1
        }

        if (pointIndex === items.pointImageRepeater.count-1) {
            for (var i = 1; i < dataset[currentLevel].coordinates.length; i++) {
                items.segmentsRepeater.itemAt(i-1).opacity = 0
            }
            items.imageBack.source = url + dataset[currentLevel].imageName2
            won()
        }
        items.pointIndexToClick++
    }

}



// this function loads the coordinates according to length of coordinates array
function loadCoordinates() {

    // prepare points data
    pointPositions = dataset[currentLevel].coordinates
    items.pointImageRepeater.model = pointPositions

    if (clickanddrawflag) {
            items.pointImageRepeater.itemAt(0).highlight = true
    }



    // prepare segments data
    linePropertiesArray = []
    for (var i = 0; i < (pointPositions.length)-1; i++) {
        var lineProperties = []                   // properties are x1,y1,x2,y,angle rotation
        lineProperties[0] = pointPositions[i][0]                                    // x
        lineProperties[1] = pointPositions[i][1]                                    // y
        lineProperties[2] = pointPositions[i+1][0]                                  // x2
        lineProperties[3] = pointPositions[i+1][1]                                  // y2
        linePropertiesArray[i] = lineProperties
    }
    items.segmentsRepeater.model = linePropertiesArray

}

function loadBackgroundImage() {
    items.imageBack.source = url + dataset[currentLevel].imageName1
}

function won() {
    items.bonus.good("flower")
}
