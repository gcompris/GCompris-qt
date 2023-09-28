/* GCompris - balancebox.js
 *
 * SPDX-FileCopyrightText: 2014-2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/* ToDo:
  - make sensitivity configurable
  - editor: add 'clear' button
  - editor: allow going back: level 1 -> last level
  - add new item: unordered contact, that has to be collected but in an
    arbitrary order
*/
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import Box2D 2.0 as Box2D
.import "qrc:/gcompris/src/core/core.js" as Core
.import QtQml 2.12 as Qml

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
var wallComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/Wall.qml");
var contactComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/BalanceContact.qml");
var balanceItemComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/BalanceItem.qml");
var goalComponent = Qt.createComponent("qrc:/gcompris/src/activities/balancebox/Goal.qml");
var contactIndex = -1;
var pendingObjects = 0;
var pendingReconfigure = false;
var finishRunning = false;
var createLevelsMsg = qsTr("Either create your levels by starting the level editor in the activity settings menu and then load your file, or choose the 'built-in' level set.")

function start(items_) {
    items = items_;

    if (items.mode === "play") {
        if (GCompris.ApplicationInfo.isMobile) {
            // we don't have many touch events, therefore disable screensaver on android:
            GCompris.ApplicationInfo.setKeepScreenOn(true);
            // lock screen orientation to landscape:
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
        var levelsFile;
        if (items.levelSet === "user" && items.file.exists(items.filePath)) {
            levelsFile = items.filePath;
            items.currentLevel = 0
        }
        else {
            if(items.levelSet === "user") {
                Core.showMessageDialog(items.background,
                                        // The argument represents the file path name to be loaded.
                                       qsTr("The file '%1' is missing!<br>Falling back to builtin levels.").arg(items.filePath) + "<br>" + createLevelsMsg,
                                       "", null,
                                       "", null,
                                       null);
            }
            levelsFile = builtinFile;
            items.currentLevel = GCompris.ApplicationSettings.loadActivityProgress(
                        "balancebox");
        }

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

    if(GCompris.ActivityInfoTree.startingLevel != -1) {
        items.currentLevel = Core.getInitialLevel(numberOfLevel);
    }

    reconfigureScene();
}

function reconfigureScene()
{
    if (items === undefined || items.mapWrapper === undefined)
        return;
    if (pendingObjects > 0) {
        pendingReconfigure = true;
        return;
    }

    // set up dynamic variables for movement:
    pixelsPerMeter = (items.mapWrapper.length / boardSizeBase) * boardSizePix / boardSizeM;
    vFactor = pixelsPerMeter / box2dPpm;

//    console.log("Starting: mode=" + items.mode
//            + " pixelsPerM=" + items.world.pixelsPerMeter
//            + " timeStep=" + items.world.timeStep
//            + " posIterations=" + items.world.positionIterations
//            + " velIterations=" + items.world.velocityIterations
//            + " boardSizePix" + boardSizePix  + " (real " + items.mapWrapper.length + ")"
//            + " pixelsPerMeter=" + pixelsPerMeter
//            + " vFactor=" + vFactor
//            + " dpi=" + items.dpi
//            + " nativeOrientation=" + GCompris.ApplicationInfo.getNativeOrientation());
    initLevel();
}

function sinDeg(num)
{
    return Math.sin(num/180*Math.PI);
}

function moveBall()
{
    var dt = step / 1000;
    var dvx = g*dt * sinDeg(items.tilt.yRotation);
    var dvy = g*dt * sinDeg(items.tilt.xRotation);

//    console.log("moving ball: dv: " + items.ball.body.linearVelocity.x
//            + "/" + items.ball.body.linearVelocity.y
//            +  " -> " + (items.ball.body.linearVelocity.x+dvx)
//            + "/" + (items.ball.body.linearVelocity.y+dvy));

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
            if (ballContacts[k].categories === items.holeType)
                finishBall(false, ballContacts[k].x, ballContacts[k].y);
            else if (ballContacts[k].categories === items.goalType && goalUnlocked)
                finishBall(true,
                           ballContacts[k].x + (items.cellSize - items.wallSize - items.ballSize)/2,
                           ballContacts[k].y + (items.cellSize - items.wallSize - items.ballSize)/2);
            else if (ballContacts[k].categories === items.buttonType) {
                if (!ballContacts[k].pressed
                    && ballContacts[k].orderNum === lastContact + 1)
                {
                    ballContacts[k].pressed = true;
                    lastContact = ballContacts[k].orderNum;
                    if (lastContact === contacts.length) {
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
    finishRunning = true;
    items.timer.stop();
    items.keyboardTimer.stop();
    items.ball.x = x;
    items.ball.y = y;
    items.ball.scale = 0.4;
    items.ball.body.linearVelocity = Qt.point(0, 0);
    if (won) {
        items.bonus.good("flower");
        if (items.levelSet === "builtin" && items.mode === "play") {
            GCompris.ApplicationSettings.saveActivityProgress("balancebox",
                        items.currentLevel+1 >= numberOfLevel ? 0 : items.currentLevel+1);
        }
    } else
        items.bonus.bad("flower");
}

function stop() {
    // reset everything
    tearDown();

    if(goal) {
        goal.destroy()
        goal = null
    }
    // unlock screen orientation
    if (GCompris.ApplicationInfo.isMobile) {
        GCompris.ApplicationInfo.setKeepScreenOn(false);
        GCompris.ApplicationInfo.setRequestedOrientation(-1);
    }
    // make sure loading overlay is really stopped
    items.loading.stop();
}

function createObject(component, properties)
{
    var p = properties;
    p.world = items.world;
    var object = component.createObject(items.mapWrapper, p);
    return object;
}

var incubators;  // need to reference all returned incubators in global scope
                 // or things don't work
function incubateObject(targetArr, component, properties)
{
    var p = properties;
    p.world = items.world;
    var incubator = component.incubateObject(items.mapWrapper, p);
    if (incubator === null) {
        console.error("Error during object incubation!");
        items.loading.stop();
        return;
    }
    incubators.push(incubator);
    if (incubator.status === Qml.Component.Ready)
        targetArr.push(incubator.object);
    else if (incubator.status === Qml.Component.Loading) {
        pendingObjects++;
        incubator.onStatusChanged = function(status) {
            if (status === Qml.Component.Ready)
                targetArr.push(incubator.object);
            else
                console.error("Error during object creation!");
            if (--pendingObjects === 0) {
                // initMap completed
                if (pendingReconfigure) {
                    pendingReconfigure = false;
                    reconfigureScene();
                } else {
                    items.timer.start();
                    items.loading.stop();
                }
            }
        }
    } else
        console.error("Error during object creation!");
}

function initMap()
{
    incubators = new Array();
    goalUnlocked = true;
    finishRunning = false;
    items.mapWrapper.rows = map.length;
    items.mapWrapper.columns = map[0].length;
    pendingObjects = 0;
    for (var row = 0; row < map.length; row++) {
        for (var col = 0; col < map[row].length; col++) {
            var x = col * items.cellSize;
            var y = row * items.cellSize;
            var currentCase = map[row][col];
            var orderNum = (currentCase & 0xFF00) >> 8;
            // debugging:
            if (debugDraw) {
                try {
                    var rect = Qt.createQmlObject(
                                "import QtQuick 2.12;Rectangle{"
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
            if (currentCase & NORTH) {
                incubateObject(walls, wallComponent, {
                                   x: x-items.wallSize/2,
                                   y: y-items.wallSize/2,
                                   width: items.cellSize + items.wallSize,
                                   height: items.wallSize,
                                   shadow: false});
            }
            if (currentCase & SOUTH) {
                incubateObject(walls, wallComponent, {
                                   x: x-items.wallSize/2,
                                   y: y+items.cellSize-items.wallSize/2,
                                   width: items.cellSize+items.wallSize,
                                   height: items.wallSize,
                                   shadow: false});
            }
            if (currentCase & EAST) {
                incubateObject(walls, wallComponent, {
                                   x: x+items.cellSize-items.wallSize/2,
                                   y: y-items.wallSize/2,
                                   width: items.wallSize,
                                   height: items.cellSize+items.wallSize,
                                   shadow: false});
            }
            if (currentCase & WEST) {
                incubateObject(walls, wallComponent, {
                                   x: x-items.wallSize/2,
                                   y: y-items.wallSize/2,
                                   width: items.wallSize,
                                   height: items.cellSize+items.wallSize,
                                   shadow: false});
            }

            if (currentCase & START) {
                items.ball.x = col * items.cellSize + items.wallSize;
                items.ball.y = row * items.cellSize + items.wallSize;
                items.ball.visible = true;
            }

            if (currentCase & GOAL) {
                var goalX = col * items.cellSize + items.wallSize/2;
                var goalY = row * items.cellSize + items.wallSize/2;
                if(goal === null) {
                    goal = createObject(goalComponent, {
                                        x: goalX,
                                        y: goalY,
                                        width: items.cellSize - items.wallSize,
                                        height: items.cellSize - items.wallSize,
                                        imageSource: baseUrl + "/door_closed.svg",
                                        categories: items.goalType,
                                        sensor: true});
                }
                else {
                    goal.x = goalX;
                    goal.y = goalY;
                    goal.width = items.cellSize - items.wallSize;
                    goal.height = goal.width;
                    goal.imageSource = baseUrl + "/door_closed.svg";
                }
            }

            if (currentCase & HOLE) {
                var holeX = col * items.cellSize + items.wallSize;
                var holeY = row * items.cellSize + items.wallSize;
                incubateObject(holes, balanceItemComponent, {
                                   x: holeX,
                                   y: holeY,
                                   width: items.ballSize,
                                   height: items.ballSize,
                                   imageSource: baseUrl + "/hole.svg",
                                   density: 0,
                                   friction: 0,
                                   restitution: 0,
                                   categories: items.holeType,
                                   sensor: true});
            }

            if (orderNum > 0) {
                var contactX = col * items.cellSize + items.wallSize/2;
                var contactY = row * items.cellSize + items.wallSize/2;
                goalUnlocked = false;
                incubateObject(contacts, contactComponent, {
                                   x: contactX,
                                   y: contactY,
                                   width: items.cellSize - items.wallSize,
                                   height: items.cellSize - items.wallSize,
                                   pressed: false,
                                   density: 0,
                                   friction: 0,
                                   restitution: 0,
                                   categories: items.buttonType,
                                   sensor: true,
                                   orderNum: orderNum,
                                   text: level.targets[orderNum-1]});
            }
        }
    }
    if (goalUnlocked && goal)  // if we have no contacts at all
        goal.imageSource = baseUrl + "/door.svg";

    if (pendingObjects === 0) {
        // don't have any pending objects (e.g. empty map!): stop overlay
        items.timer.start();
        items.loading.stop();
    }
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
    items.tilt.xRotation = 0;
    items.tilt.yRotation = 0;
    ballContacts = new Array();
}

function initLevel(testLevel) {
    items.loading.start();

    // reset everything
    tearDown();

    level = dataset[items.currentLevel];
    map = level.map
    initMap();
}

// keyboard tilting stuff:
function keyboardHandler()
{
    var MAX_TILT = 5

    if (keyboardIsTilting) {
        if (lastKey == Qt.Key_Left && items.tilt.yRotation > -MAX_TILT)
            items.tilt.yRotation -= keyboardTiltStep;
        else if (lastKey == Qt.Key_Right && items.tilt.yRotation < MAX_TILT)
            items.tilt.yRotation += keyboardTiltStep;
        else if (lastKey == Qt.Key_Up && items.tilt.xRotation > -MAX_TILT)
            items.tilt.xRotation -= keyboardTiltStep;
        else if (lastKey == Qt.Key_Down && items.tilt.xRotation < MAX_TILT)
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
