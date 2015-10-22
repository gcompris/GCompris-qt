/* GCompris - balancebox.js
 *
 * Copyright (C) 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
  - make sensitivity configurable
  - add rectangular fixture for goal
  - editor: add 'clear' button
  - editor: allow going back: level 1 -> last level
  - add sound effects
  - add new item: unordered contact, that has to be collected but in an
    arbitrary order
*/
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import Box2D 2.0 as Box2D

Qt.include("balancebox_common.js")

var dataset = null;

// Parameters that control the ball's dynamics
var m = 0.2; // without ppm-correction: 10
var g = 9.81; // without ppm-correction: 50.8
var box2dPpm = 32;    // pixelsPerMeter used in Box2D's world
var boardSizeM = 0.9; // board's real edge length, fixed to 90 cm
var boardSizePix = 500;  // board's current size in pix (acquired dynamically)
var dpiBase=139;
var boardSizeBase = 760;
var curDpi = null;
var pixelsPerMeter = null;
var vFactor = pixelsPerMeter / box2dPpm; // FIXME: calculate!

var step = 20;   // time step (in ms)
var friction = 0.15;
var restitution = 0.3;  // rebounce factor

// stuff for keyboard based tilting
var keyboardTiltStep = 0.5;   // degrees
var keyboardTimeStep = 20;    // ms
var lastKey;
var keyboardIsTilting = false;  // tilting or resetting to horizontal

var debugDraw = false;
var currentLevel = 0;
var numberOfLevel = 0;
var items;
var level;
var map; // current map

var goal = null;
var holes = new Array();
var walls = new Array();
var contacts = new Array();
var ballContacts = new Array();
var goalUnlocked;
var lastContact;
var ballContacts;
var wallComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/Wall.qml");
var contactComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/BalanceContact.qml");
var balanceItemComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/BalanceItem.qml");
var contactIndex = -1;

function start(items_) {
    items = items_;

    currentLevel = 0;

    reconfigureScene();

    if (items.mode === "play") {
        if (GCompris.ApplicationInfo.isMobile) {
            // lock screen orientation
            GCompris.ApplicationInfo.setRequestedOrientation(0);
            if (GCompris.ApplicationInfo.getNativeOrientation() === Qt.PortraitOrientation) {
                /*
                 * Adjust tilting if native orientation != landscape.
                 *
                 * Note: As of Qt 5.4.1 QTiltSensor as well as QRotationSensor
                 * report on Android
                 *   isFeatureSupported(AxesOrientation) == false.
                 * Therefore we honour rotation manually.
                 */
                items.tilt.swapAxes = true;
                items.tilt.invertX = true;
            }
        }
        var levelsFile = builtinFile;
        if (items.levelSet === "user")
            levelsFile = userFile;
        dataset = items.parser.parseFromUrl(levelsFile, validateLevels);
        if (dataset == null) {
            console.error("Balancebox: Error loading levels from " + levelsFile
                          + ", can't continue!");
            return;
        }
    } else {
        // testmode:
        dataset = [items.testLevel];
    }
    numberOfLevel = dataset.length;
    initLevel();
}

function reconfigureScene()
{
    if (items === undefined || items.mapWrapper === undefined)
        return;
    // set up dynamic variables for movement:
    pixelsPerMeter = (items.mapWrapper.length / boardSizeBase) * boardSizePix / boardSizeM;
    vFactor = pixelsPerMeter / box2dPpm;

    console.log("Starting: mode=" + items.mode
            + " pixelsPerM=" + items.world.pixelsPerMeter
            + " timeStep=" + items.world.timeStep
            + " posIterations=" + items.world.positionIterations
            + " velIterations=" + items.world.velocityIterations
            + " boardSizePix" + boardSizePix  + " (real " + items.mapWrapper.length + ")"
            + " pixelsPerMeter=" + pixelsPerMeter
            + " vFactor=" + vFactor
            + " dpi=" + items.dpi
            + " nativeOrientation=" + GCompris.ApplicationInfo.getNativeOrientation());
}

function sinDeg(num)
{
    return Math.sin(num/180*Math.PI);
}

function moveBall()
{
    var dt = step / 1000;
    var dvx = ((m*g*dt) * sinDeg(items.tilt.yRotation)) / m;
    var dvy = ((m*g*dt) * sinDeg(items.tilt.xRotation)) / m;

/*    console.log("moving ball: dv: " + items.ball.body.linearVelocity.x
            + "/" + items.ball.body.linearVelocity.y 
            +  " -> " + (items.ball.body.linearVelocity.x+dvx) 
            + "/" + (items.ball.body.linearVelocity.y+dvy));
  */
    
    items.ball.body.linearVelocity.x += dvx * vFactor;
    items.ball.body.linearVelocity.y += dvy * vFactor;
    
    checkBallContacts();

}

function checkBallContacts()
{
    for (var k = 0; k < ballContacts.length; k++) {
        if (items.ball.x > ballContacts[k].x - items.ballSize/2 &&
            items.ball.x < ballContacts[k].x + items.ballSize/2 &&
            items.ball.y > ballContacts[k].y - items.ballSize/2 &&
            items.ball.y < ballContacts[k].y + items.ballSize/2) {
            // collision
            if (ballContacts[k].categories == items.holeType)
                finishBall(false, ballContacts[k].x, ballContacts[k].y);
            else if (ballContacts[k].categories == items.goalType && goalUnlocked)
                finishBall(true, ballContacts[k].x, ballContacts[k].y);
            else if (ballContacts[k].categories == items.buttonType) {
                if (!ballContacts[k].pressed
                    && ballContacts[k].orderNum == lastContact + 1)
                {
                    ballContacts[k].pressed = true;
                    lastContact = ballContacts[k].orderNum;
                    if (lastContact == contacts.length) {
                        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav");
                        goalUnlocked = true;
                        goal.imageSource = baseUrl + "/door.svg";
                    } else
                        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/scroll.wav"); // bleep
                }
            }
        }
    }
}

function finishBall(won, x, y)
{
    items.timer.stop();
    items.keyboardTimer.stop();
    items.ball.x = x;
    items.ball.y = y;
    items.ball.scale = 0.4;
    items.ball.body.linearVelocity = Qt.point(0, 0);
    if (won)
        items.bonus.good("flower");
    else
        items.bonus.bad("flower");
}

function stop() {
    // reset everything
    tearDown();
    // unlock screen orientation
    if (GCompris.ApplicationInfo.isMobile)
        GCompris.ApplicationInfo.setRequestedOrientation(-1);
}

function createObject(component, properties)
{
    var p = properties;
    p.world = items.world;
    var object = component.createObject(items.mapWrapper, p);
    return object;
}

function initMap()
{
    var modelMap = new Array();
    goalUnlocked = true;
    items.mapWrapper.rows = map.length;
    items.mapWrapper.columns = map[0].length;
    for (var row = 0; row < map.length; row++) {
        for (var col = 0; col < map[row].length; col++) {
            var x = col * items.cellSize;
            var y = row * items.cellSize;
            var orderNum = (map[row][col] & 0xFF00) >> 8;
            // debugging:
            if (debugDraw) {
                try {
                    var rect = Qt.createQmlObject(
                            "import QtQuick 2.0;Rectangle{"
                           +"width:" + items.cellSize +";"
                           +"height:" + items.cellSize+";"
                           +"x:" + x + ";"
                           +"y:" + y +";"
                           +"color: \"transparent\";"
                           +"border.color: \"blue\";"
                           +"border.width: 1;"
                           +"}", items.mapWrapper);
                } catch (e) {
                    console.error("Error creating object: " + e);
                }
            }
            if (map[row][col] & NORTH) {
                walls.push(createObject(wallComponent, {x: x-items.wallSize/2, 
                    y: y-items.wallSize/2, width: items.cellSize + items.wallSize,
                    height: items.wallSize,
                    shadow: false}));
            }
            if (map[row][col] & SOUTH) {
                walls.push(createObject(wallComponent, {x: x-items.wallSize/2,
                    y: y+items.cellSize-items.wallSize/2,
                    width: items.cellSize+items.wallSize, height: items.wallSize,
                    shadow: false}));
            }
            if (map[row][col] & EAST) {
                walls.push(createObject(wallComponent, {x: x+items.cellSize-items.wallSize/2,
                    y: y-items.wallSize/2, width: items.wallSize, 
                    height: items.cellSize+items.wallSize, shadow: false}));
            }
            if (map[row][col] & WEST) {
                walls.push(createObject(wallComponent, {x: x-items.wallSize/2,
                    y: y-items.wallSize/2, width: items.wallSize,
                    height: items.cellSize+items.wallSize, shadow: false}));
            }

            if (map[row][col] & START) {
                items.ball.x = col * items.cellSize + items.wallSize;
                items.ball.y = row * items.cellSize + items.wallSize;
                items.ball.visible = true;
            }
            
            if (map[row][col] & GOAL) {
                var goalX = col * items.cellSize + items.wallSize/2;
                var goalY = row * items.cellSize + items.wallSize/2;
                goal = createObject(balanceItemComponent, {
                        x: goalX, y: goalY,
                        width: items.cellSize - items.wallSize,
                        height: items.cellSize - items.wallSize,
                        imageSource: baseUrl + "/door_closed.svg",
                        categories: items.goalType,
                        sensor: true});
            }
            
            if (map[row][col] & HOLE) {
                var holeX = col * items.cellSize + items.wallSize;
                var holeY = row * items.cellSize + items.wallSize;
                holes.push(createObject(balanceItemComponent, {
                    x: holeX, y: holeY,
                    width: items.ballSize, height: items.ballSize,
                    imageSource: baseUrl + "/hole.svg",
                    density: 0, friction: 0, restitution: 0,
                    categories: items.holeType,
                    sensor: true}));
            }
            
            if (orderNum > 0) {
                var contactX = col * items.cellSize + items.wallSize/2;
                var contactY = row * items.cellSize + items.wallSize/2;
                goalUnlocked = false;
                contacts.push(createObject(contactComponent, {
                    x: contactX, y: contactY,
                    width: items.cellSize - items.wallSize, 
                    height: items.cellSize - items.wallSize,
                    pressed: false,
                    density: 0, friction: 0, restitution: 0,
                    categories: items.buttonType,
                    sensor: true,
                    orderNum: orderNum,
                    text: level.targets[orderNum-1]}));
            }
        }
    }
    if (goalUnlocked && goal)  // if we have no contacts at all
        goal.imageSource = baseUrl + "/door.svg";

}

function addBallContact(item)
{
    if (ballContacts.indexOf(item) !== -1)
        return;
    ballContacts.push(item);
}

function removeBallContact(item)
{
    var index = ballContacts.indexOf(item);
    if (index > -1)
        ballContacts.splice(index, 1);
}

function tearDown()
{
    items.ball.body.linearVelocity = Qt.point(0, 0);
    items.ball.scale = 1;
    items.ball.visible = false;
    items.timer.stop();
    items.keyboardTimer.stop();
    if (holes.length > 0) {
        for (var i = 0; i< holes.length; i++)
            holes[i].destroy();
        holes.length = 0;
    }
    if (walls.length > 0) {
        for (var i = 0; i< walls.length; i++)
            walls[i].destroy();
        walls.length = 0;
    }
    if (contacts.length > 0) {
        for (var i = 0; i< contacts.length; i++)
            contacts[i].destroy();
        contacts.length = 0;
    }
    lastContact = 0;
    if (goal)
        goal.destroy();
    goal = null;
    items.tilt.xRotation = 0;
    items.tilt.yRotation = 0;
    ballContacts = new Array();
}

function initLevel(testLevel) {
    items.bar.level = currentLevel + 1;

    // reset everything
    tearDown();

    level = dataset[currentLevel];
    map = level.map
    initMap();
    items.timer.start();
}

// keyboard tilting stuff:
function keyboardHandler()
{
    if (keyboardIsTilting) {
        if (lastKey == Qt.Key_Left)
            items.tilt.yRotation -= keyboardTiltStep;
        else if (lastKey == Qt.Key_Right)
            items.tilt.yRotation += keyboardTiltStep;
        else if (lastKey == Qt.Key_Up)
            items.tilt.xRotation -= keyboardTiltStep;
        else if (lastKey == Qt.Key_Down)
            items.tilt.xRotation += keyboardTiltStep;
        items.keyboardTimer.start();
    } else {// is resetting
        // yRotation:
        if (items.tilt.yRotation < 0)
            items.tilt.yRotation = Math.min(items.tilt.yRotation + keyboardTiltStep, 0);
        else if (items.tilt.yRotation > 0)
            items.tilt.yRotation = Math.max(items.tilt.yRotation - keyboardTiltStep, 0);
        // xRotation:
        if (items.tilt.xRotation < 0)
            items.tilt.xRotation = Math.min(items.tilt.xRotation + keyboardTiltStep, 0);
        else if (items.tilt.xRotation > 0)
            items.tilt.xRotation = Math.max(items.tilt.xRotation - keyboardTiltStep, 0);
        // resetting done?
        if (items.tilt.yRotation != 0 || items.tilt.xRotation != 0)
            items.keyboardTimer.start();
    }
}

function processKeyPress(key)
{
    if (key == Qt.Key_Left
        || key == Qt.Key_Right
        || key == Qt.Key_Up
        || key == Qt.Key_Down) {
        lastKey = key;
        keyboardIsTilting = true;
        items.keyboardTimer.stop();
        keyboardHandler();
    }
}

function processKeyRelease(key)
{
    if (key == Qt.Key_Left
            || key == Qt.Key_Right
            || key == Qt.Key_Up
            || key == Qt.Key_Down) {
            lastKey = key;
            keyboardIsTilting = false;
            items.keyboardTimer.stop();
            keyboardHandler();
        }
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
