/* GCompris - drawnumber.js
 *
 * Copyright (C) 2014 Emmanuel Charruau
 *
 * Authors:
 *   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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
var pointIndexToClick

var dataset = [
            {
                "imageName1": "dn_fond1.svg",
                "imageName2": "dn_fond2.svg",
                "coordinates": [[407,121],[489,369],[279,216],[537,214],[330,369],[407,121]]

            },
            {
                "imageName1": "de1.svg",
                "imageName2": "de2.svg",
                "coordinates": [[404,375],[406,271],[503,233],[588,278],[588,337],[611,311],[727,320],[728,424],[682,486],[560,474],[560,397],[495,423],[404,375]]
            },
            {
                "imageName1": "house1.svg",
                "imageName2": "house2.svg",
                "coordinates": [[406,360],[512,360],[513,175],[456,120],[455,70],[430,70],[430,96],[372,40],[219,177],[220,361],[353,361],[352,276],[406,276],[406,360]]
            },
            {
                "imageName1": "sapin1.svg",
                "imageName2": "sapin2.svg",
                "coordinates": [[244,463],[341,361],[267,373],[361,238],[300,251],[377,127],[329,146],[399,52],[464,144],[416,128],[492,251],[435,239],[527,371],[458,362],[557,466],[422,453],[422,504],[374,504],[374,453],[244,463]]
            },
            {
                "imageName1": "epouvantail1.svg",
                "imageName2": "epouvantail2.svg",

              //"coordinates": "[255,449],[340,340],[340,224],[212,233],[208,168],[395,160],[368,135],[367,77],[340,79],[339,68],[363,65],[359,30],[460,30],[464,56],[488,54],[489,66],[463,68],[462,135],[434,161],[612,163],[607,223],[477,221],[477,337],[561,457],[507,487],[413,377],[309,491],[255,449]"
                "coordinates": [[255,449],[340,340],[340,224],[212,233],[208,168],[395,160],[368,135],[367,77],[340,79],[339,68],[363,65],[359,30],[460,30],[464,56],[488,54],[489,66],[463,68],[462,135],[434,161],[612,163],[607,223],[477,221],[477,337],[561,457],[507,487],[413,377],[309,491],[255,449]]
            },
            {
                "imageName1": "plane1.svg",
                "imageName2": "plane2.svg",
                "coordinates": [[342,312],[163,317],[141,309],[128,285],[141,256],[165,236],[246,212],[170,127],[149,86],[165,70],[190,69],[234,92],[369,200],[500,198],[577,188],[534,161],[533,147],[545,141],[567,144],[604,163],[631,116],[671,197],[708,212],[718,227],[712,238],[688,238],[652,224],[576,263],[459,288],[533,334],[575,380],[573,398],[551,407],[404,343],[342,312]]
            },
            {
                "imageName1": "fish1.svg",
                "imageName2": "fish2.svg",
                "coordinates": [[33,338],[78,238],[152,172],[320,158],[378,84],[423,70],[450,83],[463,117],[448,154],[453,164],[478,174],[526,144],[552,158],[555,168],[545,188],[557,215],[623,241],[685,222],[712,188],[739,176],[761,194],[766,274],[740,380],[721,422],[678,408],[654,362],[558,349],[488,367],[498,394],[495,427],[461,448],[414,443],[350,389],[312,387],[320,404],[315,431],[291,433],[267,400],[78,400],[55,384],[47,340],[33,338]]
            },
            {
                "imageName1": "carnaval1.svg",
                "imageName2": "carnaval2.svg",
                "coordinates": [[285,204],[342,143],[374,180],[396,118],[415,188],[419,120],[427,179],[462,154],[514,203],[465,188],[436,224],[436,236],[434,296],[429,315],[470,306],[514,262],[534,184],[554,186],[536,279],[463,366],[454,473],[462,518],[358,518],[370,473],[352,365],[327,402],[350,468],[330,483],[298,407],[330,333],[377,317],[369,295],[364,235],[363,223],[333,189],[285,204]]
            },
            {
                "imageName1": "bear1.svg",
                "imageName2": "bear2.svg",
                "coordinates": [[304,256],[262,240],[216,206],[192,174],[195,159],[216,154],[257,167],[300,188],[334,220],[352,206],[370,200],[342,185],[321,154],[319,117],[337,90],[320,76],[315,55],[335,38],[360,40],[376,52],[377,66],[400,59],[431,60],[450,66],[451,48],[468,37],[490,36],[507,48],[510,70],[501,82],[486,86],[502,110],[506,136],[499,164],[479,189],[458,200],[480,212],[522,180],[578,158],[611,154],[622,164],[618,184],[592,213],[550,236],[515,251],[529,286],[532,329],[526,364],[548,354],[566,360],[576,384],[571,417],[548,455],[520,470],[493,456],[490,419],[461,440],[414,453],[360,441],[330,422],[331,450],[317,471],[284,467],[255,434],[242,402],[248,366],[271,354],[296,364],[288,326],[292,282],[304,256]]
            },
        ]



var url = "qrc:/gcompris/src/activities/drawnumber/resource/"
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
    pointIndexToClick = 0
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


function drawSegment(pointIndex) {

    if (pointIndex == pointIndexToClick)
    {
        items.pointImageRepeater.itemAt(pointIndex).opacity = 0
        items.pointImageRepeater.itemAt(pointIndex).z = 0

        if (clickanddrawflag) {
            if (pointIndex < items.pointImageRepeater.count-1) {
                 items.pointImageRepeater.itemAt(pointIndex+1).source = url + "greenpoint.svg"
            }
        }

        if (pointIndex > 0) {
            items.segmentsRepeater.itemAt(pointIndex-1).opacity = 1
        }

        if (pointIndex == items.pointImageRepeater.count-1) {
            items.imageBack.source = url + dataset[currentLevel].imageName2
            won()
        }
        pointIndexToClick++
    }

}


function loadCoordinates() {

    // prepare points data
    pointPositions = dataset[currentLevel].coordinates
    items.pointImageRepeater.model = pointPositions

    if (clickanddrawflag) {
            items.pointImageRepeater.itemAt(0).source = url + "greenpoint.svg"
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




