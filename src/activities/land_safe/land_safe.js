/* GCompris - land_safe.js
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris

var levels = [
                                /**  simple  **/
            {   "planet": qsTr("Ceres"),    "gravity":  0.27,   "maxAccel": 0.054,
                "accelSteps": 2,            "alt": 75.0 ,       "mode": "simple",
                "fuel" : -1 },
            {   "planet": qsTr("Pluto"),    "gravity":  0.62,   "maxAccel": 0.186,
                "accelSteps": 3,            "alt": 100.0,       "mode": "simple",
                "fuel" : -1 },
            {   "planet": qsTr("Titan"),    "gravity": 1.352,   "maxAccel": 0.406,
                "accelSteps": 3,            "alt": 100.0,       "mode": "simple",
                "fuel" : -1 },
            {   "planet": qsTr("Moon"),     "gravity": 1.622,   "maxAccel": 0.324,
                "accelSteps": 4,            "alt": 150.0,       "mode": "simple",
                "fuel" : 10 },
            {   "planet": qsTr("Mars"),     "gravity": 3.711,   "maxAccel": 0.619,
                "accelSteps": 5,            "alt": 200.0,       "mode": "simple",
                "fuel" : 20 },
            {   "planet": qsTr("Venus"),    "gravity":  8.87,   "maxAccel": 1.331,
                "accelSteps": 6,            "alt": 300.0,       "mode": "simple",
                "fuel" : 70 },
            {   "planet": qsTr("Earth"),    "gravity": 9.807,   "maxAccel": 1.373,
                "accelSteps": 7,            "alt": 350.0,       "mode": "simple",
                "fuel" : 70 },

                                /**  rotation  **/
            {   "planet": qsTr("Ceres"),    "gravity":  0.27,   "maxAccel": 0.054,
                "accelSteps": 2,            "alt": 75.0 ,       "mode": "rotation",
                "fuel" : -1 },
            {   "planet": qsTr("Pluto"),    "gravity":  0.62,   "maxAccel": 0.186,
                "accelSteps": 3,            "alt": 100.0,       "mode": "rotation",
                "fuel" : -1 },
            {   "planet": qsTr("Titan"),    "gravity": 1.352,   "maxAccel": 0.406,
                "accelSteps": 3,            "alt": 100.0,       "mode": "rotation",
                "fuel" : -1 },
            {   "planet": qsTr("Moon"),     "gravity":  1.62,   "maxAccel": 0.324,
                "accelSteps": 4,            "alt": 150.0,       "mode": "rotation",
                "fuel" : 10 },
            {   "planet": qsTr("Mars"),     "gravity":  3.71,   "maxAccel": 0.619,
                "accelSteps": 5,            "alt": 200.0,       "mode": "rotation",
                "fuel" : 20 },
            {   "planet": qsTr("Venus"),    "gravity":  8.87,   "maxAccel": 1.331,
                "accelSteps": 5,            "alt": 300.0,       "mode": "rotation",
                "fuel" : 70 },
            {   "planet": qsTr("Earth"),    "gravity": 9.807,   "maxAccel": 1.373,
                "accelSteps": 7,            "alt": 350.0,       "mode": "rotation",
                "fuel" : 70 }

];

var introTextSimple = qsTr("Use the up and down keys to control the thrust."
                           + "<br/>Use the right and left keys to control direction."
                           + "<br/>You must drive Tux's ship towards the landing platform."
                           + "<br/>The landing platform turns green when the velocity is safe to land.")

var introTextRotate = qsTr("The up and down keys control the thrust of the rear engine."
                           + "<br/>The right and left keys now control the rotation of the ship."
                           + "<br/>To move the ship in horizontal direction you must first rotate and then accelerate it.")

var currentLevel = 0;
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
    currentLevel = 0;
    lastLevel = -1;
    numberOfLevel = levels.length;
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    if (items === null)
        return;

    items.bar.level = currentLevel + 1

    items.zoom = 1;
    zoomStack = [];
    // init level:
    items.accelerometer.min = -levels[currentLevel].gravity;
    items.accelerometer.max = levels[currentLevel].maxAccel*10-levels[currentLevel].gravity;
    maxAccel = levels[currentLevel].maxAccel;
    accelSteps = levels[currentLevel].accelSteps;
    dAccel = maxAccel / accelSteps;//- minAccel;
    startingAltitudeReal = levels[currentLevel].alt;
    items.gravity = levels[currentLevel].gravity;
    items.mode = levels[currentLevel].mode;
    maxFuel = levels[currentLevel].fuel;
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

    // initialize world:
    items.world.pixelsPerMeter = pxYToAltitude(items.rocket.y) / startingAltitudeReal;
    items.world.gravity = Qt.point(0, items.gravity)
    items.world.running = false;

//    console.log("Starting level (surfaceOff=" + items.ground.surfaceOffset + ", ppm=" + items.world.pixelsPerMeter + ")");

    if (currentLevel === 0 && lastLevel !== 0) {
        items.ok.visible = false;
        items.intro.intro = [introTextSimple];
        items.intro.index = 0;
    } else if (currentLevel === levels.length / 2 && lastLevel !== 0) {
        items.ok.visible = false;
        items.intro.intro = [introTextRotate];
        items.intro.index = 0;
    } else {
        // go
        items.intro.index = -1;
        items.ok.visible = true;
    }
    lastLevel = currentLevel;
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

function processKeyPress(event)
{
    var key = event.key;
    event.accepted = true;
    if (!items.world.running) {
        return;
    }
    var newAccel = 0;
    if (key === Qt.Key_Up || key === Qt.Key_Down) {
        if (key === Qt.Key_Up) {
            if (items.rocket.accel === 0)
                newAccel = dAccel;
            else
                newAccel = items.rocket.accel + dAccel;
        } else if (key === Qt.Key_Down)
            newAccel = items.rocket.accel - dAccel;

        if (newAccel < 0)
            newAccel = 0;
        if (newAccel > maxAccel)
            newAccel = maxAccel;

        if (newAccel !== items.rocket.accel && currentFuel > 0)
            items.rocket.accel = newAccel;
    } else if (key === Qt.Key_Right || key === Qt.Key_Left) {
        if (items.mode === "simple") {
            if (key === Qt.Key_Right && !event.isAutoRepeat && currentFuel > 0) {
                items.rocket.leftAccel = leftRightAccel;
                items.rocket.rightAccel = 0.0;
            } else if (key === Qt.Key_Left && !event.isAutoRepeat && currentFuel > 0) {
                items.rocket.rightAccel = leftRightAccel;
                items.rocket.leftAccel = 0.0;
            }
        } else { // "rotation"
            if (key === Qt.Key_Right)
                items.rocket.rotation += 10;
            else if (key === Qt.Key_Left)
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
    items.rocket.leftAccel = 0;
    items.rocket.rightAccel = 0;
    items.rocket.body.linearVelocity = Qt.point(0,0)
    if (success)
        items.bonus.good("lion");
    else {
        items.explosion.show();
        items.rocket.hide();
        items.bonus.bad("lion");
    }
}

function degToRad(degrees) {
  return degrees * Math.PI / 180;
}
