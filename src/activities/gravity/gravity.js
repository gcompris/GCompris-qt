/* GCompris - gravity.js
*
* SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/gravity/resource/"

var levels = [
            { // Level 1
                planetFrequency: 12000,
                planetCount: 5
            },
            { // Level 2
                planetFrequency: 10000,
                planetCount: 10
            },
            { // Level 3
                planetFrequency: 8000,
                planetCount: 15
            },
            { // Level 4
                planetFrequency: 7000,
                planetCount: 20
            },
            { // Level 5
                planetFrequency: 6000,
                planetCount: 25
            },
            { // Level 6
                planetFrequency: 5000,
                planetCount: 30
            }
        ]

var numberOfLevel = levels.length;
var items;
var message;

// delta move
var move = 0;
// control move
var controlMove = 0;
// gravity of current planet
var planetGravity = 0;
// speed for key controls
var controlSpeed = 0.2;

var currentPlanet;
var planetsCounter = 0;

function start(items_,message_) {
    items = items_;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    message = message_;
    initLevel();
}

function stop() {
    items.processTimer.stop();
    items.planetCreation.stop();
    destroyPlanet();
    planetsCounter = 0;
    controlMove = 0;
    move = 0;
}

function initLevel() {
    stop();
    items.planetFrequency = levels[items.currentLevel].planetFrequency;
    items.background.initSpace();
    items.explosion.hide();
    items.spaceship.opacity = 100;
    items.spaceshipX = items.background.width * 0.5;
    items.stationDown.stop();
    items.station.y = -items.station.height;
    controlSpeed = 0.2 * (items.currentLevel * 0.25 + 1);
    if(!items.startMessage) {
        items.processTimer.start();
        createPlanet();
        items.planetCreation.start();
        message.index = -1;
    } else {
        message.index = 0;
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

function processKeyPress(event) {
    var key = event.key;
    event.accepted = true;
    if(key === Qt.Key_Left) {
        controlMove += -controlSpeed;
    } else if(key === Qt.Key_Right) {
        controlMove += controlSpeed;
    }
}

function processKeyRelease(event) {
    var key = event.key;
    event.accepted = true;
    if(key === Qt.Key_Left || key === Qt.Key_Right) {
        controlMove = 0;
    }
}

function createPlanet() {
    if(planetsCounter < levels[items.currentLevel].planetCount) {
        var planetSide = Math.floor( Math.random() * 2);  
        var planetSize = Math.max(Math.random() * items.maxPlanetSize, items.minPlanetSize);
        if(planetSide == 0) {
            currentPlanet = items.planet0;
        } else if(planetSide == 1) {
            currentPlanet = items.planet1;
        }
        currentPlanet.source = url + "planet" + Math.floor(Math.random() * 2) + ".webp";
        currentPlanet.fallDuration = levels[items.currentLevel].planetFrequency;
        currentPlanet.height = planetSize;
        currentPlanet.width = planetSize;
        currentPlanet.y = currentPlanet.height * -2;
        currentPlanet.visible = true;
        currentPlanet.startMoving();
        planetGravity = currentPlanet.leftSide ? -currentPlanet.width * 0.5: currentPlanet.width * 0.5;
        planetsCounter++;
    } else {
        items.stationDown.restart();
    }
}

function moveSpaceship() {
    // calculate gravity
    if(planetsCounter > 0) {
        // calculate distance between planet center and spaceship center
        var hypothenuse = Math.sqrt(
            Math.pow((currentPlanet.x + (currentPlanet.width * 0.5)) - items.spaceshipX, 2) +
            Math.pow((currentPlanet.y + (currentPlanet.height * 0.5)) - items.spaceshipY, 2));
        items.gravity = (planetGravity * (items.currentLevel * 0.33 + 1)) / Math.pow(hypothenuse, 2) * 100;
    } else {
        items.gravity = 0;
    }
    move += controlMove + (items.gravity);
    items.spaceshipX += move;

    // Check for crash
    computeOverlap();

    // Don't go out of the screen or stay stuck on the borders
    if(items.spaceshipX > items.background.width - items.borderMargin) {
        move = 0;
        controlMove = 0;
        items.spaceshipX -= 1;
    } else if(items.spaceshipX < items.borderMargin) {
        move = 0;
        controlMove = 0;
        items.spaceshipX += 1;
    }
}

function computeOverlap() {
    if(planetsCounter > 0) {
        // compute overlap with a little margin on the planets to not hit too much on corners
        var xOverlap = Math.min(items.spaceship.x + items.spaceship.width,
                                currentPlanet.x + currentPlanet.width * 0.9) - 
                       Math.max(items.spaceship.x, currentPlanet.x + currentPlanet.width * 0.1);
        var yOverlap = Math.min(items.spaceship.y + items.spaceship.height,
                                currentPlanet.y + currentPlanet.height * 0.9) - 
                       Math.max(items.spaceship.y, currentPlanet.y +
                                currentPlanet.height * 0.1);
        // again add a safety margin to avoid hitting on corners
        if(xOverlap > items.spaceship.width * 0.2 && yOverlap > items.spaceship.height * 0.2) {
            crash();
            items.bonus.bad("lion");
        }
    }
}

function destroyPlanet() {
    planetGravity = 0;
    items.gravity = 0;
    if(planetsCounter > 0) {
        currentPlanet.visible = false;
    }
}

function crash() {
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav");
    items.explosion.show();
    items.spaceship.hide();
    stop();
}
