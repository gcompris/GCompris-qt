/* GCompris - land_safe.js
 *
 * SPDX-FileCopyrightText: 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/* ToDo:
 * - check for shader availability
 * - test more generic on-screen controls
 * (- use polygon fixture for rocket)
 *
 * Some gravitational forces:
 * !- Ceres 0,27
 * !- Pluto: 0,62 m/s²
 * !- Titan: 1,352 m/s²
 * - Ganymed: 1,428
 * !- Moon: 1,622 m/s²
 * - Io: 1,796 m/s²
 * !- Mars: 3,711 m/s²
 * - Merkur: 3,7 m/s²
 * !- Venus: 8,87 m/s²
 * !- Earth: 9,807 m/s²
 * - Jupiter: 24,79 m/s²
 */

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var levels;
var numberOfLevel;
var items = null;
var baseUrl = "qrc:/gcompris/src/activities/land_safe/resource";
var startingAltitudeReal = 100.0;
var startingOffsetPx = 10;  // y-value for setting rocket initially
var maxLandingVelocity = 10;
var leftRightAccel = 0.1;   // accel force set on horizontal accel
//var minAccel = 0.1;
var maxAccel = 0.15;
var accelSteps = 3;
var dAccel = maxAccel / accelSteps;//- minAccel;
var barAtStart;
var maxFuel = 100.0;
var currentFuel = 0.0;
var lastLevel = -1;
var debugDraw = false;
var zoomStack = new Array;

function start(items_) {
    items = items_;
    lastLevel = -1;
    levels = items_.levels;
    numberOfLevel = levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);

    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel();
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    if (items === null)
        return;


    items.zoom = 1;
    zoomStack = [];
    // init level:
    items.accelerometer.min = -levels[items.currentLevel].gravity;
    items.accelerometer.max = levels[items.currentLevel].maxAccel*10-levels[items.currentLevel].gravity;
    maxAccel = levels[items.currentLevel].maxAccel;
    accelSteps = levels[items.currentLevel].accelSteps;
    dAccel = maxAccel / accelSteps;//- minAccel;
    startingAltitudeReal = levels[items.currentLevel].alt;
    items.gravity = levels[items.currentLevel].gravity;
    items.mode = levels[items.currentLevel].mode;
    maxFuel = levels[items.currentLevel].fuel;
    currentFuel = (maxFuel == -1 ? 1 : maxFuel); // -1 means unlimited fuel

    // reset everything:
    items.explosion.hide();
    items.rocket.show();
    // place rocket randomly:
    var max = items.background.width - items.accelerometer.width - items.landing.width - items.rocket.width;
    var min = 20;
    items.rocket.x = Math.random() * (max- min) + min;
    items.rocket.y = startingOffsetPx;
    items.rocket.rotation = 0;
    items.rocket.accel = 0;
    items.rocket.leftAccel = 0;
    items.rocket.rightAccel = 0;
    items.rocket.body.linearVelocity = Qt.point(0,0)
    // for landing random placement shall not intersect with bar -- or osd
    // controls on mobile:
    min = items.onScreenControls ? items.leftRightControl.width : items.bar.fullButton * items.bar.barZoom;
    max = items.onScreenControls ? items.background.width - items.upDownControl.width - items.landing.width : max;
    items.landing.anchors.leftMargin = Math.random() * (max- min) + min;
    items.landing.overlayColor = "-g";
    items.leftEngine.reset();
    items.rightEngine.reset();
    items.bottomEngine.reset();

    // initialize world:
    items.world.pixelsPerMeter = pxYToAltitude(items.rocket.y) / startingAltitudeReal;
    items.world.gravity = Qt.point(0, items.gravity)
    items.world.running = false;

//    console.log("Starting level (surfaceOff=" + items.ground.surfaceOffset + ", ppm=" + items.world.pixelsPerMeter + ")");

    if (levels[items.currentLevel].intro !== undefined) {
        items.ok.visible = false;
        items.intro.intro = [levels[items.currentLevel].intro];
        items.intro.index = 0;
    } else {
        // go
        items.intro.intro = [];
        items.intro.index = -1;
        items.ok.visible = true;
    }
    lastLevel = items.currentLevel;
}

function pxAltitudeToY(alt)
{
    var y = items.background.height - items.ground.height + items.ground.surfaceOffset
            - items.rocket.height - 1 - alt;
    return y;
}

function pxYToAltitude(y)
{
    var altPx = items.background.height - items.ground.height + items.ground.surfaceOffset
            - y - items.rocket.height
            - 1;  // landing is 1 pixel above ground surface
    return altPx;
}

// calc real height of rocket in meters above surface
function getAltitudeReal()
{
    var altPx = pxYToAltitude(items.rocket.y);
    var altReal = altPx / items.world.pixelsPerMeter;
    return altReal;
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function processKeyPress(event)
{
    var key = event.key;
    event.accepted = true;
    if(!items.world.running) {
        if(key === Qt.Key_Enter || key === Qt.Key_Return || key == Qt.Key_Space)
            items.ok.clicked();
        else
            return;
    }

    if(items.bonus.isPlaying) {
        return;
    }
    var newAccel = 0;
    if(key === Qt.Key_Up || key === Qt.Key_Down) {
        if (key === Qt.Key_Up) {
            if(items.rocket.accel === 0)
                newAccel = dAccel;
            else
                newAccel = items.rocket.accel + dAccel;
        } else if(key === Qt.Key_Down)
            newAccel = items.rocket.accel - dAccel;

        if (newAccel < 0)
            newAccel = 0;
        if (newAccel > maxAccel)
            newAccel = maxAccel;

        if(newAccel !== items.rocket.accel && currentFuel > 0)
            items.rocket.accel = newAccel;
    } else if(key === Qt.Key_Right || key === Qt.Key_Left) {
        if (items.mode === "simple") {
            if(key === Qt.Key_Right && !event.isAutoRepeat && currentFuel > 0) {
                items.rocket.leftAccel = leftRightAccel;
                items.rocket.rightAccel = 0.0;
            } else if(key === Qt.Key_Left && !event.isAutoRepeat && currentFuel > 0) {
                items.rocket.rightAccel = leftRightAccel;
                items.rocket.leftAccel = 0.0;
            }
        } else { // "rotation"
            if(key === Qt.Key_Right)
                items.rocket.rotation += 10;
            else if(key === Qt.Key_Left)
                items.rocket.rotation -= 10;
            //console.log("XXX rotation=" + items.rocket.rotation + " bodyRot=" + items.rocket.body.rotation);
        }
    }
}

function processKeyRelease(event)
{
    if (!items.world.running) {
        event.accepted = false;
        return;
    }
    if(items.bonus.isPlaying) {
        event.accepted = false;
        return;
    }

    var key = event.key;
    event.accepted = true;
    //console.log("XXX release " + key + " = " + event.isAutoRepeat + " = " + Qt.Key_Right);
    if (key === Qt.Key_Right && !event.isAutoRepeat) {
        items.rocket.leftAccel = 0;
    } else if (key === Qt.Key_Left && !event.isAutoRepeat) {
        items.rocket.rightAccel = 0;
    } else
        event.accepted = false;
}

function finishLevel(success)
{
    items.rocket.accel = 0;
    if (success) {
        items.rocket.leftAccel = 0;
        items.rocket.rightAccel = 0;
        items.rocket.body.linearVelocity = Qt.point(0,0)

        items.bonus.good("lion");
    } else {
        // don't reset physics on a crash so the explosion rolls along landscape.

        items.explosion.show();
        items.rocket.hide();
        items.bonus.bad("lion");
    }
}

function degToRad(degrees) {
  return degrees * Math.PI / 180;
}

//note: using 0 with transparent font color instead of space to keep consistent spacing
//simple function for the fuel and altitude values
function minimum3Chars(number_) {
    var numberTxt = number_.toString();
    if(number_ < 100 && number_ >= 10)
        numberTxt = "<font color=\"#00FFFFFF\">0</font>" + numberTxt;
    else if(number_ < 10)
        numberTxt = "<font color=\"#00FFFFFF\">00</font>" + numberTxt;
    return numberTxt;
}

//function for the velocity and acceleration values
function fixedSizeString(number_, multiplier_, chars_, emptyDecimal_) {
    var numberRound = Math.round(number_ * multiplier_) / multiplier_;
    var numberTxt = numberRound.toString();
    if(numberRound % 1 === 0)
        numberTxt = numberTxt + emptyDecimal_;
    var charsToAdd = chars_ - numberTxt.length;
    if(numberRound >= 0) {
        numberTxt = "<font color=\"#00FFFFFF\">-</font>" + numberTxt;
        charsToAdd--;
    }
    for(; charsToAdd > 0; charsToAdd--)
        numberTxt = "<font color=\"#00FFFFFF\">0</font>" + numberTxt;
    return numberTxt;
}
