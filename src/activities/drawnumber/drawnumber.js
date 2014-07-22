/* GCompris - drawnumber.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
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
var numberOfLevel = 4
var items
var pointPositions = [[407,121],[489,369],[279,216],[537,214],[330,369],[407,121]]
//var pointPositions = [[407,121],[489,369]]

//var pointPositions = [];


var pointIndexToClick = 1



var figures = [
            {
                "imageName": "dn_fond1.svgz",
                "coordinates": "[407,121];[489,369];[279,216];[537,214];[330,369];[407,121]"
            },
            {
                "imageName": "dn_de1.svgz",
                "coordinates": "[404,375];[406,271];[503,233];[588,278];[588,337];[611,311];[727,320];[728,424];[682,486];[560,474];[560,397];[495,423];[404,375]"
            },
            {
                "imageName": "dn_house1.svgz",
                "coordinates": "[406,360];[512,360];[513,175];[456,120];[455,70];[430,70];[430,96];[372,40];[219,177];[220,361];[353,361];[352,276];[406,276];[406,360]"
            },
            {
                "imageName": "dn_sapin1.svgz",
                "coordinates": "[244,463];[341,361];[267,373];[361,238];[300,251];[377,127];[329,146];[399,52];[464,144];[416,128];[492,251];[435,239];[527,371];[458,362];[557,466];[422,453];[422,504];[374,504];[374,453];[244,463]"
            },
            {
                "imageName": "dn_epouvantail1.svgz",
                "coordinates": "[255,449];[340,340];[340,224];[212,233];[208,168];[395,160];[368,135];[367,77];[340,79];[339,68];[363,65];[359,18];[460,9];[464,56];[488,54];[489,66];[463,68];[462,135];[434,161];[612,163];[607,223];[477,221];[477,337];[561,457];[507,487];[413,377];[309,491];[255,449]"
            },
            {
                "imageName": "dn_plane1.svgz",
                "coordinates": "[342,312];[163,317];[141,309];[128,285];[141,256];[165,236];[246,212];[170,127];[149,86];[165,70];[190,69];[234,92];[369,200];[500,198];[577,188];[534,161];[533,147];[545,141];[567,144];[604,163];[631,116];[649,105];[664,117];[671,197];[708,212];[718,227];[712,238];[688,238];[652,224];[576,263];[459,288];[533,334];[575,380];[573,398];[551,407];[404,343];[342,312]"
            },
            {
                "imageName": "dn_poisson1.svgz",
                "coordinates": "[33,338];[78,238];[152,172];[320,158];[378,84];[423,70];[450,83];[463,117];[448,154];[453,164];[478,174];[526,144];[552,158];[555,168];[545,188];[557,215];[623,241];[685,222];[712,188];[739,176];[761,194];[766,274];[740,380];[721,422];[678,408];[654,362];[558,349];[488,367];[498,394];[495,427];[461,448];[414,443];[350,389];[312,387];[320,404];[315,431];[291,433];[267,400];[78,400];[55,384];[47,340];[33,338]"
            },
            {
                "imageName": "dn_fou1.svgz",
                "coordinates": "[285,204];[342,143];[374,180];[396,118];[415,188];[419,120];[427,179];[462,154];[514,203];[465,188];[436,224];[436,236];[434,296];[429,315];[470,306];[514,262];[534,184];[554,186];[536,279];[463,366];[454,473];[462,518];[358,518];[370,473];[352,365];[327,402];[350,468];[330,483];[298,407];[330,333];[377,317];[369,295];[364,235];[363,223];[333,189];[285,204]"
            },
            {
                "imageName": "dn_bear1.svgz",
                "coordinates": "[304,256];[262,240];[216,206];[192,174];[195,159];[216,154];[257,167];[300,188];[334,220];[352,206];[370,200];[342,185];[321,154];[319,117];[337,90];[320,76];[315,55];[335,38];[360,40];[376,52];[377,66];[400,59];[431,60];[450,66];[451,48];[468,37];[490,36];[507,48];[510,70];[501,82];[486,86];[502,110];[506,136];[499,164];[479,189];[458,200];[480,212];[522,180];[578,158];[611,154];[622,164];[618,184];[592,213];[550,236];[515,251];[529,286];[532,329];[526,364];[548,354];[566,360];[576,384];[571,417];[548,455];[520,470];[493,456];[490,419];[461,440];[414,453];[360,441];[330,422];[331,450];[317,471];[284,467];[255,434];[242,402];[248,366];[271,354];[296,364];[288,326];[292,282];[304,256]"
            },
            {
                "imageName": "dn_hibou1.svgz",
                "coordonates": "[304,256];[262,240];[216,206];[192,174];[195,159];[216,154];[257,167];[300,188];[334,220];[352,206];[370,200];[342,185];[321,154];[319,117];[337,90];[320,76];[315,55];[335,38];[360,40];[376,52];[377,66];[400,59];[431,60];[450,66];[451,48];[468,37];[490,36];[507,48];[510,70];[501,82];[486,86];[502,110];[506,136];[499,164];[479,189];[458,200];[480,212];[522,180];[578,158];[611,154];[622,164];[618,184];[592,213];[550,236];[515,251];[529,286];[532,329];[526,364];[548,354];[566,360];[576,384];[571,417];[548,455];[520,470];[493,456];[490,419];[461,440];[414,453];[360,441];[330,422];[331,450];[317,471];[284,467];[255,434];[242,402];[248,366];[271,354];[296,364];[288,326];[292,282];[304,256]"
            },
            {
                "imageName": "dn_bear1.svgz",
                "coordinates": "[304,256];[262,240];[216,206];[192,174];[195,159];[216,154];[257,167];[300,188];[334,220];[352,206];[370,200];[342,185];[321,154];[319,117];[337,90];[320,76];[315,55];[335,38];[360,40];[376,52];[377,66];[400,59];[431,60];[450,66];[451,48];[468,37];[490,36];[507,48];[510,70];[501,82];[486,86];[502,110];[506,136];[499,164];[479,189];[458,200];[480,212];[522,180];[578,158];[611,154];[622,164];[618,184];[592,213];[550,236];[515,251];[529,286];[532,329];[526,364];[548,354];[566,360];[576,384];[571,417];[548,455];[520,470];[493,456];[490,419];[461,440];[414,453];[360,441];[330,422];[331,450];[317,471];[284,467];[255,434];[242,402];[248,366];[271,354];[296,364];[288,326];[292,282];[304,256]"
            },
            {
                "imageName": "dn_bear1.svgz",
                "coordinates": "[443,133];[423,11];[434,10];[472,56];[458,20];[467,19];[495,71];[491,30];[501,33];[522,116];[519,72];[529,75];[537,153];[539,119];[546,125];[547,159];[555,154];[556,208];[583,169];[724,98];[739,99];[703,137];[743,109];[742,121];[691,165];[742,143];[741,155];[654,200];[716,182];[713,195];[650,215];[689,212];[680,219];[615,235];[661,229];[653,238];[604,250];[622,250];[615,255];[582,260];[600,263];[590,268];[577,268];[606,300];[644,294];[643,302];[599,314];[625,311];[623,318];[593,323];[615,323];[611,327];[586,329];[599,332];[591,336];[553,335];[535,357];[534,377];[527,368];[511,367];[493,375];[501,366];[485,371];[493,363];[482,365];[492,355];[514,354];[532,332];[520,331];[505,317];[500,291];[501,303];[490,289];[486,297];[479,282];[473,287];[466,269];[448,252];[446,224];[460,201];[456,191];[459,182];[467,197];[479,196];[443,133]"
            },

        ]


var url = "qrc:/gcompris/src/activities/drawnumber/resource/"
var numberOfLevel = figures.length


function start(items_) {
    console.log("drawnumber activity: start")
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("drawnumber activity: stop")
}

function initLevel() {
    console.log("drawnumber activity: create some content in my activity")
    items.bar.level = currentLevel + 1
    pointIndexToClick = 1
    loadCoordinates()

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
    console.log("POINT INDEX: " + pointIndex)
    console.log("pointIndexToClick " + pointIndexToClick)
    pointIndexToClick

    if (pointIndex == pointIndexToClick) {

        if (pointIndex == 1 && pointIndexToClick == 1) {
            console.log("COLOR IN GREEN: " + pointIndex)
            items.pointImageRepeater.itemAt(1).source = url + "greenpoint.svgz"
            items.pointNumberTextRepeater.itemAt(1).text = pointPositions.length
        }

        if (pointIndex != 1) {
            items.canvas.pointOrigin = pointPositions[pointIndex-1]
            items.canvas.pointToClick = pointPositions[pointIndex]
            items.pointImageRepeater.itemAt(pointIndex).source = url + "greenpoint.svgz"
            items.canvas.requestPaint()
        }
        pointIndexToClick++
     }
    // draw the last segment
    if (pointIndex == 1 && pointIndexToClick == pointPositions.length) {
        items.canvas.pointOrigin = pointPositions[pointPositions.length-1]
        items.canvas.pointToClick = pointPositions[pointIndex]
        items.canvas.requestPaint()
        items.pointImageRepeater.itemAt(pointIndex).source = url + "greenpoint.svgz"

    }
    // change color of the first point and replace number 1 by last number of the list
    //if (pointIndex == 1 && pointIndexToClick == 1) {


}

function loadCoordinates() {

 /*   var str = figures[0].coordinates
    console.log(str)
    str = str.replace(/\[/g,"")
    str = str.replace(/\]/g,"")
    console.log(str)
    var coordinatesxy = str.split(";");
    for (var i = 0; i < coordinatesxy.length; i++) {
        console.log(i + ": " + coordinatesxy[i])
        var coordinates = coordinatesxy[i].split(",")
        console.log(coordinates)
        pointPositions.push(coordinates)
    }*/
    pointPositions = [[407,121],[489,369],[279,216],[537,214],[330,369],[407,121]]
}
