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
.import QtQuick 2.2 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var items
var mode
var pointPositions = []
var linePropertiesArray = []
//array to play sound of different alphabets in different levels
var soundplay = ["d","c","l","a","o","p","m","n","r","w","s","z","u"]

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
// array of datasets
var dataset2 = [

            {
                "imageName1": "D2.svg",
                "imageName2": "D1.svg",
                "coordinates": [[134,43],[178,43],[217,42],[271,43],[322,43],[372,51],[411,67],[451,100],[468,135],[478,169],[484,214],[477,262],[458,302],[426,334],[379,351],[328,366],[262,369],[211,369],[169,363],[134,362],[134,310],[138,258],[138,220],[137,172],[138,119],[135,80],[134,43]]
            },
            {
                "imageName1": "C2.svg",
                "imageName2": "C1.svg",
                "coordinates":   [[413,127],[381,83],[335,61],[284,54],[240,58],[194,74],[160,97],[138,128],[128,170],[125,202],[137,254],[156,293],[199,318],[245,332],[287,334],[327,329],[372,310],[399,278],[421,245]]
            },
            {
                "imageName1": "L2.svg",
                "imageName2": "L1.svg",
                "coordinates": [[176,35],[176,67],[176,105],[176,153],[176,199],[173,236],[176,272],[176,312],[176,345],[176,379],[198,394],[237,394],[275,394],[310,394],[341,394],[382,394],[421,394],[462,394],[502,394]]
            },
            {
                "imageName1": "A2.svg",
                "imageName2": "A1.svg",
                "coordinates": [[147,394],[172,350],[197,299],[221,245],[259,169],[296,94],[337,39],[367,91],[397,151],[429,214],[462,278],[496,338],[521,394],[430,271],[362,270],[305,265],[246,264],[216,312],[194,351],[153,394]]
            },
            {
                "imageName1": "O2.svg",
                "imageName2": "O1.svg",
                "coordinates":  [[294,51],[316,54],[345,58],[378,72],[416,96],[430,119],[445,145],[451,178],[458,205],[458,237],[452,281],[443,313],[417,350],[386,375],[356,389],[316,398],[289,402],[251,391],[211,376],[178,353],[156,322],[138,291],[132,233],[135,179],[150,135],[175,99],[205,78],[242,59],[294,51]]
            },
            {
                "imageName1": "P2.svg",
                "imageName2": "P1.svg",
                "coordinates":  [[129,414],[129,379],[129,335],[129,283],[129,227],[129,176],[129,125],[129,83],[129,48],[159,39],[197,42],[239,42],[284,42],[335,42],[385,58],[427,81],[452,110],[464,141],[462,183],[435,224],[392,240],[340,252],[296,255],[248,254],[211,254],[173,249],[150,249]]
            },
            {
                "imageName1": "M2.svg",
                "imageName2": "M1.svg",
                "coordinates": [[129,392],[128,357],[129,328],[129,297],[129,259],[129,220],[129,182],[129,145],[129,115],[132,84],[147,64],[172,96],[186,125],[195,151],[205,176],[217,208],[229,236],[242,270],[255,305],[268,343],[290,375],[313,341],[325,313],[337,278],[348,249],[362,214],[378,178],[394,137],[411,102],[437,70],[442,103],[445,154],[445,195],[445,226],[443,262],[443,300],[443,332],[445,366],[445,392]]
            },
            {
                "imageName1": "N2.svg",
                "imageName2": "N1.svg",
                "coordinates": [[216,351],[216,324],[216,299],[216,277],[216,254],[216,230],[216,201],[216,170],[216,147],[216,121],[216,102],[216,71],[236,93],[249,105],[264,125],[280,143],[293,160],[310,176],[325,198],[343,218],[357,235],[375,262],[398,287],[420,309],[440,324],[461,343],[461,318],[461,293],[461,271],[461,242],[461,220],[461,195],[461,169],[461,138],[461,112],[461,90],[461,65]]
            },
            {
                "imageName1": "R2.svg",
                "imageName2": "R1.svg",
                "coordinates": [[169,392],[169,366],[169,331],[169,287],[169,254],[169,217],[169,183],[169,154],[169,115],[169,82],[169,52],[201,49],[241,47],[276,47],[308,49],[341,49],[380,52],[404,64],[432,78],[451,112],[455,159],[439,189],[399,208],[357,222],[318,225],[283,224],[250,224],[229,224],[206,222],[225,245],[259,245],[285,247],[325,254],[353,276],[376,304],[394,324],[413,345],[427,362],[441,378],[455,394]]
            },
            {
                "imageName1": "W2.svg",
                "imageName2": "W1.svg",
                "coordinates": [[154,69],[159,92],[168,113],[175,143],[182,165],[187,187],[190,208],[197,231],[203,252],[210,278],[215,303],[220,329],[231,350],[243,320],[254,290],[261,266],[266,245],[273,222],[278,201],[283,178],[292,155],[297,133],[304,106],[318,75],[329,99],[336,122],[343,143],[348,165],[357,187],[362,210],[371,240],[380,269],[388,292],[397,318],[408,348],[418,318],[425,294],[434,264],[439,236],[450,201],[457,173],[465,138],[474,106],[480,82],[486,60]]
            },
            {
                "imageName1": "S2.svg",
                "imageName2": "S1.svg",
                "coordinates": [[442,138],[424,100],[379,71],[334,65],[293,61],[252,65],[214,78],[173,106],[167,144],[201,173],[258,194],[309,205],[372,216],[427,236],[456,275],[442,313],[399,340],[354,348],[294,353],[246,340],[195,324],[166,300],[143,264]]
            },
            {
                "imageName1": "Z2.svg",
                "imageName2": "Z1.svg",
                "coordinates": [[182,77],[206,77],[231,77],[255,77],[280,77],[304,77],[332,77],[359,77],[387,77],[418,77],[443,77],[480,77],[508,77],[487,101],[464,124],[436,141],[420,159],[395,173],[374,187],[346,215],[320,231],[296,254],[266,275],[243,290],[213,309],[196,324],[167,352],[190,350],[210,350],[232,350],[254,350],[282,350],[310,350],[331,350],[357,350],[376,350],[397,350],[420,350],[444,350],[474,350],[497,350],[530,350]]
            },
            {
                "imageName1": "U2.svg",
                "imageName2": "U1.svg",
                "coordinates":[[172,54],[172,90],[169,121],[169,156],[170,188],[169,224],[172,256],[175,287],[186,319],[211,345],[240,363],[271,373],[300,376],[327,375],[356,367],[389,363],[416,347],[435,325],[445,294],[449,267],[449,221],[449,186],[448,157],[448,131],[448,99],[448,74],[448,47]]
            }
        ]

var url = "qrc:/gcompris/src/activities/drawnumber/resource/"
var numberOfLevel = dataset.length
var numberOfLevel2 = dataset2.length


function start(_items, _mode) {
    items = _items
    mode = _mode
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

    if(mode=="drawletters"){
    //function to play letter sound at start
        playLetterSound(soundplay[currentLevel])
    }
}

function nextLevel() {

    if(mode == "drawletters"){

        if(numberOfLevel2 <= ++currentLevel ) {
            currentLevel = 0
        }
        initLevel();
    }
    else{
        if(numberOfLevel <= ++currentLevel ) {
            currentLevel = 0
        }
        initLevel();
    }
}

function previousLevel() {

    if(mode=="drawletters"){
        if(--currentLevel < 0) {
            currentLevel = numberOfLevel2 - 1
        }
        initLevel();
    }

    else{
        if(--currentLevel < 0) {
            currentLevel = numberOfLevel - 1
        }
        initLevel();
    }
}


//function to play the sound of chararcter at start & end
function playLetterSound(number) {
        items.audioVoices.play(
            GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar(number)))
}


function drawSegment(pointIndex) {

    if (pointIndex == items.pointIndexToClick)
    {

        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/scroll.wav")
        items.pointImageRepeater.itemAt(pointIndex).opacity = 0

        if (mode=="clickanddraw" || mode=="drawletters") {
            if (pointIndex < items.pointImageRepeater.count-1) {
                 items.pointImageRepeater.itemAt(pointIndex+1).highlight = true
            }
        }

        // Draw the line from pointIndex - 1 to pointIndex
        if (pointIndex > 0) {
            items.segmentsRepeater.itemAt(pointIndex-1).opacity = 1
        }

        if (pointIndex == items.pointImageRepeater.count-1) {

            if(mode == "drawletters"){
                for (var i = 1; i < dataset2[currentLevel].coordinates.length; i++) {
                    items.segmentsRepeater.itemAt(i-1).opacity = 0
                }
                items.imageBack.source = url + dataset2[currentLevel].imageName2
                won()
            }
            else if(mode == "drawnumber"){
                for (var i = 1; i < dataset[currentLevel].coordinates.length; i++) {
                    items.segmentsRepeater.itemAt(i-1).opacity = 0
                }
                items.imageBack.source = url + dataset[currentLevel].imageName2
                won()
            }

            else if(mode == "clickanddraw"){
                for (var i = 1; i < dataset[currentLevel].coordinates.length; i++) {
                    items.segmentsRepeater.itemAt(i-1).opacity = 0
                }
                items.imageBack.source = url + dataset[currentLevel].imageName2
                won()
            }
        }
        items.pointIndexToClick++
    }
}

function loadCoordinates() {

    if(mode == "drawletters"){
        // prepare points data
        pointPositions = dataset2[currentLevel].coordinates
        items.pointImageRepeater.model = pointPositions
        items.pointImageRepeater.itemAt(0).highlight = true
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

    else if(mode=="clickanddraw" || mode=="drawnumber"){

        // prepare points data
        pointPositions = dataset[currentLevel].coordinates
        items.pointImageRepeater.model = pointPositions

        if(mode == "clickanddraw"){
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
}

function loadBackgroundImage() {

    if(mode == "drawletters"){
        items.imageBack.source = url + dataset2[currentLevel].imageName1
    }

    else if(mode == "clickanddraw" || mode == "drawnumber"){
        items.imageBack.source = url + dataset[currentLevel].imageName1

    }
}

function won() {
    if(mode == "drawletters"){
        playLetterSound(soundplay[currentLevel])
    }
    items.bonus.good("flower")
}
