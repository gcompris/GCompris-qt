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
                "imageName1": "D2.svg",
                "imageName2": "D1.svg",
                "coordinates": [[134,43],[178,43],[217,42],[271,43],[322,43],[372,51],[411,67],[451,100],[468,135],[478,169],[484,214],[477,262],[458,302],[426,334],[379,351],[328,366],[262,369],[211,369],[169,363],[134,362],[134,310],[138,258],[138,220],[137,172],[138,119],[135,80],[134,43]]
            },

            {
                "imageName1": "C2.svg",
                "imageName2": "C1.svg",
                "coordinates":   [[413,127],[381,83],[335,61],[284,54],[240,58],[194,74],[160,97],[138,128],[128,170],[125,202],[137,254],[156,293],[199,318],[245,332],[287,334],[327,329],[372,310],[399,278],[421,245]]   }
            ,



            {
                "imageName1": "L2.svg",
                "imageName2": "L1.svg",
                "coordinates": [[176,35],[176,67],[176,105],[176,153],[176,199],[173,236],[176,272],[176,312],[176,345],[176,379],[198,394],[237,394],[275,394],[310,394],[341,394],[382,394],[421,394],[462,394],[502,394]] },

            {
                "imageName1": "A2.svg",
                "imageName2": "A1.svg",
                "coordinates": [[147,394],[172,350],[197,299],[221,245],[259,169],[296,94],[337,39],[367,91],[397,151],[429,214],[462,278],[496,338],[521,394],[430,271],[362,270],[305,265],[246,264],[213,312],[191,351],[150,394]]
            },



            {
                "imageName1": "O2.svg",
                "imageName2": "O1.svg",
                "coordinates":  [[294,51],[316,54],[345,58],[378,72],[416,96],[430,119],[445,145],[451,178],[458,205],[458,237],[452,281],[443,313],[417,350],[386,375],[356,389],[316,398],[289,402],[251,391],[211,376],[178,353],[156,322],[138,291],[132,233],[135,179],[150,135],[175,99],[205,78],[242,59],[294,51]]
            },
            {
                "imageName1": "P2.svg",
                "imageName2": "P1.svg",
                "coordinates":  [[129,414],[129,379],[129,335],[129,283],[129,227],[129,176],[129,125],[129,83],[129,48],[159,39],[197,42],[239,42],[284,42],[335,42],[385,58],[427,81],[452,110],[464,141],[462,183],[435,224],[392,240],[340,252],[296,255],[248,254],[211,254],[173,249],[150,249]]}
            ,



            {
                "imageName1": "M2.svg",
                "imageName2": "M1.svg",
                "coordinates": [[129,392],[128,357],[129,328],[129,297],[129,259],[129,220],[129,182],[129,145],[129,115],[132,84],[147,64],[172,96],[186,125],[195,151],[205,176],[217,208],[229,236],[242,270],[255,305],[268,343],[290,375],[313,341],[325,313],[337,278],[348,249],[362,214],[378,178],[394,137],[411,102],[437,70],[442,103],[445,154],[445,195],[445,226],[443,262],[443,300],[443,332],[445,366],[445,392]]
            },

            {
                "imageName1": "U2.svg",
                "imageName2": "U1.svg",
                "coordinates":[[172,54],[172,90],[169,121],[169,156],[170,188],[169,224],[172,256],[175,287],[186,319],[211,345],[240,363],[271,373],[300,376],[327,375],[356,367],[389,363],[416,347],[435,325],[445,294],[449,267],[449,221],[449,186],[448,157],[451,131],[448,99],[448,65],[448,59],[448,55]] },
            {
                "imageName1": "arth1.svg",
                "imageName2": "arth2.svg",
                "coordinates":  [[481,132],[489,99],[512,70],[540,55],[572,43],[610,43],[645,43],[680,51],[710,71],[735,108],[734,153],[715,194],[683,226],[645,252],[611,277],[576,297],[541,324],[515,343],[489,369],[484,397],[515,397],[544,395],[582,395],[613,394],[655,394],[691,395],[722,392],[763,395]] }
,
            {
                "imageName1": "arth3.svg",
                "imageName2": "arth4.svg",
                "coordinates":  [[512,77],[535,75],[566,75],[594,77],[623,77],[664,75],[705,75],[741,78],[779,75],[781,102],[753,141],[728,173],[697,207],[678,237],[658,267],[640,303],[624,341],[611,382],[601,413],[594,448]]}



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
