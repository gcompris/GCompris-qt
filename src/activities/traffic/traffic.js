/* GCompris - traffic.js
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import QtQml 2.12 as Qml
.import "qrc:/gcompris/src/core/core.js" as Core

/* The format and the dataset for the traffic game in gcompris
 * is taken from
 * http://www.javascript-games.org/puzzle/rushhour/
 *
 * [LevelX]
 * CardY=string describing card 1
 * CardY=string describing card 2
 * ...
 * Where X is the Gcompris Level (in the control bar)
 * Where Y is the sublevel.
 *
 * This is followed by a comma separated list defining the cars on the
 * grid. So the string looks as follows:
 *
 * 'ID''X''Y'
 *
 * - 'ID' is one char in the range A-R and X
 *   A-K Specify a different car color of size 2
 *   O-R Specify a different car color of size 3
 *   X   Always Red, the goal car of size 2
 *
 * - 'X' xpos numbers between
 *    1 to 6 for Vertical car
 *    A to F for Horizontal car
 *
 * - 'Y' ypos numbers between
 *    1 to 6 for Horizontal car
 *    A to F for Vertical car
 *
 */
var dataList = [
  /* [Level1] */
  "XD3,O2F",
  "XD3,A4C,O2F,PD5",
  "XC3,A2E,BE5,O2F,P4B",
  "XB3,AB1,B2E,C2F,D4C,OD1,PD4",
  "XC3,A3F,BE6,O2E,PD5,Q2B",
  /* [Level2] */
  "XB3,AE5,O2F,P4D",
  "XB3,A2F,B4C,OD4,PB6,QA1,RD1",
  "XC3,AC2,B3B,C4C,O2F,PD5",
  "XD3,AB2,B4D,CE5,O2F",
  "XC3,A1F,B2E,CD4,DE6,E5D,O3F",
  /* [Level3] */
  "XC3,A2E,BB4,C5B,OA1,PD1,QC5",
  "XC3,AB2,B3B,C4D,DE5,O1E",
  "XD3,AE2,BE6,C5B,O3F,P4D",
  "XD3,AD2,BE5,C4D,OA1,PD1,Q2F",
  "XC3,AB4,CE6,D5B,OC5,P1E",
  /* [Level4] */
  "XC3,AA1,BC2,CE5,D2B,E4C,O1E",
  "XA3,AB1,B2C,CD4,E3F,OD1,F4C,QD5",
  "XA3,AE4,BC6,CE6,D2C,E2F,F4C,G4D,OD1,P4A",
  "XC3,AB2,BD2,CC4,D5B,E3E,FC6,GE6,O2F,PD5",
  "XD3,A2C,BD2,C2F,DE4,E4D,F5B,OA1,PD1,QC6",
  /* [Level5] */
  "XC3,A1C,B2F,C4C,D4D,EE4,FC6,GE6,OD1,P4B",
  "XD3,A2B,B4C,CE6,O2F,P4D,Q1A,R4A",
  "XD3,A1D,BC5,CC6,DE6,E4E,F5B,GE1,O2F,PB4",
  "XB3,AD2,BB4,C3E,DE5,EE6,O2F,P3D",
  "XB3,AD2,B3E,CB4,DE5,EE6,OA1,PD1,Q2F,R3D",
  /* [Level6] */
  "XC3,AC2,BE2,C3E,D3F,EB4,FE5,GE6,HA6,O4D,P3A,QD1",
  "XB3,AA1,B5A,CE5,O1F,P2A,Q2D,RC6",
  "XA3,A1A,B2D,C3E,D5C,EE5,FA6,GD6,OD1,P2F,QA4",
  "XB3,AB4,B5B,CC6,O3D,P4F",
  "XB3,A4C,B5F,O1A,P1D,QD4,RC6",
  /* [Level7] */
  "XB3,AA1,B1D,CA2,DA4,E4C,F5A,O2E,P2F,Q3D,RD6",
  "XB3,A1B,BC1,C1E,D1F,E2D,F3F,IC4,H5D",
  "XA3,AD1,BC2,C2E,D3C,E3D,FA4,GE4,HA5,I5C,KA6,O1F,PD5,QD6",
  "XA3,A1B,BC1,CE1,D2D,EE2,F3F,G5C,H5F,O3E,P4A,QB4",
  "XB3,AA1,B1C,CE1,DA2,E5D,FE5,GA6,HE6,O2F,P3A,QB4",
  /* [Level8] */
  "XB3,AB1,B4C,E5F,O1A,P1D,QD4,RC6",
  "XA3,A1A,BB1,C5E,O1F,P2C,QD4,RA6",
  "XD3,AA1,BC1,C1E,D2C,E3B,FD4,G5D,HE5,IB6,KE6,O2F,P4A",
  "XC3,AA1,B1C,CE2,D3A,E3B,F3E,G3F,HC4,I5C,JE5,KA6",
  "XC3,AB1,BD1,CA2,DC2,E4C,F4D,GE5,HB6,ID6,O2E,P2F,Q3A,R3B",
  /* [Level9] */
  "XD3,AA1,BC1,C1E,D2A,EC2,F3B,GA6,O1F,P3C,QD4",
  "XA3,A1A,BC2,CE2,D3C,EA4,F5E,G5F,OB1,P4D,QA5,RA6",
  "XB3,AA1,B1C,CA2,DB5,O1D,P3A,QB4,RA6",
  "XC3,A1C,BD1,D3B,EC4,F4E,J2E,OB5",
  "XA3,A1A,BB2,C2D,D3C,E5C,FD5,OD1,P3F,QD6",
  /* [Level10] */
  "XB3,AA1,B1C,O1D,P2A,QB4,RD6",
  "XB3,A1C,B2A,CE2,D4B,EE4,F5A,GC5,H5F,OD1,P2D,QB6",
  "XD3,A2C,BD2,C4C,D4D,EE4,FE5,OC1,P1F,QC6",
  "XC3,A1C,BD1,C2B,D3A,E3E,FB4,G5E,HA6,OA5",
  "XB3,AA1,B1C,CE1,DA2,E3E,F5B,G5D,HE5,IE6,O2F,P3A,QB4",
  /* [Level11] */
  "XB3,A1B,B2A,C2D,D3F,E4A,F5C,G5F,HD6,OD1,P2E,RB4",
  "XA3,A1A,BB1,CB2,D3C,ED4,F5C,O1D,P3F,RD6",
  "XA3,A1D,BE2,C4A,D4B,ED4,FA6,GC6,OA1,P2C,Q4F,RC5",
  "XA3,A2C,B3F,C4A,DB4,ED4,FB5,G5D,H5F,OA1,P1E,RA6",
  "XB3,A1C,B2D,CA4,DC4,EA6,FC6,O1A,PD1,Q4F",
  /* [Level12] */
  "XB3,AA1,B2D,CE2,D3A,ED4,FA5,OD1,P3F,Q4C,RD6",
  "XA3,AA1,B1D,CE1,D4A,EB4,FD4,HA6,K5D,O1C,P4F",
  "XA3,A1B,BE1,DB4,ED4,FB5,G5D,H5E,I4A,P4F,QA6,R1C", 
  "XA3,A1A,B2D,C3E,D4D,E5C,FE5,HD6,IA6,P2F,QA4,RD1",
  "XA3,AD1,B2D,DB5,E5D,F5E,GA6,K4A,O1C,P1F,QB4",
  /* [Level13] */
  "XC3,AE1,B2B,CC2,D4D,E5C,FE5,GA6,O1A,PB1,Q2F,RA4",
  "XB3,AA1,B1C,CE1,DA2,E5D,FE5,GA6,HE6,O2E,P2F,Q3A,RB4",
  "XA3,A1A,BB2,C2D,D3C,ED4,F5C,GD5,OD1,QD6,R3F",
  "XA3,A1C,B2D,C3C,DA4,ED4,F5A,G5B,HC5,IC6,OD1,R3F",
  "XD3,AB1,B1E,C2B,D2C,E4D,F5C,GE5,HA6,ID6,O1A,P2F,QA4"
];

var colorMap = {
    'X': "#DA3131",
    'A': "#E9CA39",
    'B': "#467EEA",
    'C': "#4BD754",
    'D': "#D8813C",
    'E': "#BF36C8",
    'F': "#4B59D7",
    'G': "#36C8C5",
    'H': "#C8B336",
    'I': "#D9D9D9",
    'J': "#66D83C",
    'K': "#6D36C8",
    'O': "#3A8FC2",
    'P': "#CE9161",
    'Q': "#CDCDCD",
    'R': "#7BCE61"
};

var baseUrl="qrc:/gcompris/src/activities/traffic/resource/";

var carList = [
  baseUrl + "car1.svg",
  baseUrl + "car2.svg",
  baseUrl + "car3.svg",
  baseUrl + "car4.svg",
  baseUrl + "car5.svg",
  baseUrl + "car6.svg",
  baseUrl + "car7.svg",
  baseUrl + "car8.svg",
  baseUrl + "car9.svg",
  baseUrl + "car10.svg",
  baseUrl + "car11.svg",
  baseUrl + "car12.svg"
];

var truckList = [
  baseUrl + "truck1.svg",
  baseUrl + "truck2.svg",
  baseUrl + "truck3.svg",
  baseUrl + "truck4.svg"
];

var currentSubLevel = 0;
var level = null;
var maxLevel = 13;
var maxSubLevel = 5;
var items;
var cars;
var numCars;
var carComponent = null;
var activeCars = new Array();
var haveWon = false;
var mode = null;
var truckIndex = 0;
var carIndex = 0;
var isMoving = false;

function start(items_, mode_) {
    items = items_;
    mode = mode_;
    items.currentLevel = Core.getInitialLevel(maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function stop() {
    cleanupActiveCars();
}

function findYBounds(car)
{
    if (car.yBounds !== undefined)
        return;
    var bounds = { "lower": 0, "upper": items.jamGrid.height };

    for (var i = 0; i < activeCars.length; i++) {
        if (activeCars[i] != car &&
            ((activeCars[i].xPos == car.xPos)
             || (activeCars[i].isHorizontal && activeCars[i].xPos < car.xPos 
                 && activeCars[i].xPos+activeCars[i].size > car.xPos)))
        {
            // y intersects
            if (activeCars[i].effY < car.effY &&
                activeCars[i].effY + activeCars[i].effHeight > bounds.lower) {
                bounds.lower = activeCars[i].effY + activeCars[i].effHeight;
            }
            else if (activeCars[i].effY > car.effY && activeCars[i].effY < bounds.upper)
                bounds.upper = activeCars[i].effY;
        }
    }
    car.yBounds = bounds;
}

function findXBounds(car)
{
    if (car.xBounds !== undefined)
        return;
    var bounds = { "lower": 0, "upper": items.jamGrid.width + (car.goal ? car.blockSize : 0)};
    for (var i = 0; i < activeCars.length; i++) {
        if (activeCars[i] != car &&
            ((activeCars[i].yPos == car.yPos)
             || (!activeCars[i].isHorizontal && activeCars[i].yPos < car.yPos 
                 && activeCars[i].yPos+activeCars[i].size > car.yPos)))
        {
            // y intersects
            if (activeCars[i].effX < car.effX &&
                activeCars[i].effX + activeCars[i].effWidth > bounds.lower) {
                bounds.lower = activeCars[i].effX + activeCars[i].effWidth;
            }
            else if (activeCars[i].effX > car.effX && activeCars[i].effX < bounds.upper)
                bounds.upper = activeCars[i].effX;
        }
    }
    car.xBounds = bounds;
}

function updateCarPosition(car, newX, newY)
{
    if (car.isHorizontal) {
        findXBounds(car);
        var deltaX = Math.min(car.xBounds.upper - car.effWidth, Math.max(car.xBounds.lower, newX)) - car.effX;
        car.x += deltaX;
        car.effX += deltaX;
        // check for reached goal:
        if (car.goal && car.effX + car.width >= items.jamGrid.width) {
            haveWon = true;
            items.bonus.good("smiley");
            return;
        }
    } else {
        findYBounds(car)
        var deltaY = Math.min(car.yBounds.upper - car.effHeight, Math.max(car.yBounds.lower, newY)) - car.effY;
        car.y += deltaY;
        car.effY += deltaY;
    }
}

function snapCarToGrid(car)
{
    if (car.isHorizontal) {
        car.xPos = Math.min(5, Math.max(0, Math.round(car.x / car.blockSize)));
        car.x = car.effX = Qt.binding(function() { return car.xPos * car.blockSize; });
    } else {
        car.yPos = Math.min(5, Math.max(0, Math.round(car.y / car.blockSize)));
        car.y = car.effY = Qt.binding(function() { return car.yPos * car.blockSize; });
    }
    car.xBounds = car.yBounds = undefined;
}

function drawCar(car)
{
    if (!carComponent) {
        carComponent = Qt.createComponent("qrc:/gcompris/src/activities/traffic/Car.qml");
        if (carComponent.status != Qml.Component.Ready) {
            console.error("Error creating Rectangle component (" 
                    + carComponent.status + "): " + carComponent.errorString());
            carComponent = null;
            return;
        }
    }
    
    var id = car[0];
    var x = car[1];
    var y = car[2];
    var xPos;
    var yPos;
    xPos = 0;
    yPos = y.charCodeAt(0) - '1'.charCodeAt(0);
    var isHorizontal = true;
    var size = 0;
    var source;
    
    if (id == 'O' || id == 'P' || id == 'Q' || id == 'R') { 
        size = 3;
        source = truckList[Math.floor(truckIndex++ % truckList.length)];
    } else {
        size = 2;
        source = carList[Math.floor(carIndex++ % (carList.length-1)) + 1];
    }
    
    if (x == 'A') xPos = 0;
    else if (x == 'B') xPos = 1;
    else if (x == 'C') xPos = 2;
    else if (x == 'D') xPos = 3;
    else if (x == 'E') xPos = 4;
    else if (x == 'F') xPos = 5;
    else { // vertical
        yPos = x.charCodeAt(0) - '1'.charCodeAt(0); //vertical
        isHorizontal = false;

        if (y == 'A') xPos = 0;
        else if (y == 'B') xPos = 1;
        else if (y == 'C') xPos = 2;
        else if (y == 'D') xPos = 3;
        else if (y == 'E') xPos = 4;
        else if (y == 'F') xPos = 5;
    }
    
    var color = colorMap[id];
    var goal;
    if (id == 'X') {
        goal = 1;
        source = carList[0];
    }

    var carObject = carComponent.createObject( items.jamGrid, {
        "xPos": xPos,
        "yPos": yPos,
        "size": size,
        "goal": goal,
        "color": color,
        "source": source,
        "isHorizontal": isHorizontal,
        "audioEffects": items.audioEffects

    });
    if (carObject == null)
        console.error("traffic: Error creating Car object!");
    else
        activeCars.push(carObject);
}

function drawJam()
{
    for (var i = 0; i < cars.length; i++)
        drawCar(cars[i]);
}

function cleanupActiveCars()
{
    while (activeCars.length > 0)
        activeCars.pop().destroy();
}

function initLevel() {
    // destroy old cars
    isMoving = false;
    cleanupActiveCars();
    truckIndex = 0;
    carIndex = 0;
    if (currentSubLevel == 0) {
        // initialize level
        items.score.numberOfSubLevels = maxSubLevel;
    }
    // initialize sublevel
    haveWon = false;
    items.score.currentSubLevel = currentSubLevel + 1;
    cars = dataList[(items.currentLevel * maxSubLevel) + currentSubLevel].split(",");
    drawJam();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0;
        nextLevel();
    } else
        initLevel();
}
