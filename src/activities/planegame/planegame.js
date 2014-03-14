/*
 gcompris - planegame.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo

var max_speed = 8
var currentLevel
var numberOfLevel = 2

var upPressed
var downPressed
var leftPressed
var rightPressed

var planeLastTarget = 10;
var main
var items

var cloudComponent = Qt.createComponent("qrc:/gcompris/src/activities/planegame/Cloud.qml");
var clouds = new Array;

function start(main_, items_) {
    main = main_
    items = items_
    currentLevel = 0
    initLevel()

    items.movePlaneTimer.start();
    items.cloudCreation.start()

    items.score.numberOfSubLevels = planeLastTarget
}

function stop() {
    items.movePlaneTimer.stop()
    items.cloudCreation.stop()
}

function increaseSpeedX() {
    if(items.plane.speedX < max_speed)
        items.plane.speedX++;
}

function decreaseSpeedX() {
    if(items.plane.speedX > -max_speed)
        items.plane.speedX--;
}

function increaseSpeedY() {
    if(items.plane.speedY < max_speed)
        items.plane.speedY++;
}

function decreaseSpeedY() {
    if(items.plane.speedY > - max_speed)
        items.plane.speedY--;
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.score.currentSubLevel = 1

    if(currentLevel === 0)
        items.score.visible = true

    upPressed = false
    downPressed = false
    leftPressed = false
    rightPressed = false

    items.plane.x = 100
    items.plane.y = items.background.height/2 - items.plane.height/2
    items.plane.speedX = 0
    items.plane.speedY = 0

    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        // Remove the cloud
        cloud.destroy()
        // Remove the element from the list
        clouds.splice(i, 1)
    }
}

function nextLevel() {
    if(numberOfLevel-1 <= ++currentLevel) {
        currentLevel = numberOfLevel-1
    }

    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {

    items.plane.x *= factor
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        //cloud.x *= factor
    }
}

function repositionObjectsOnHeightChanged(factor) {
    items.plane.y *= factor
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        cloud.y *= factor
    }
}

function createCloud() {
    console.log("createCloud")
    var cloud = cloudComponent.createObject(
                items.background, {
                    "background": items.background,
                    "x": items.background.width
                });

    /* Random cloud number */
    if(getRandomInt(0, 1) === 0) {
        /* Put the target */
        cloud.number = items.score.currentSubLevel;
    }
    else {
        var min = Math.max(1, items.score.currentSubLevel - 1);
        cloud.number = min + getRandomInt(0, items.score.currentSubLevel - min + 3);
    }

    clouds.push(cloud);
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function processPressedKey(event) {
    switch(event.key) {
    case Qt.Key_Right:
        rightPressed = true;
        event.accepted = true;
        break;
    case Qt.Key_Left:
        leftPressed = true;
        event.accepted = true;
        break;
    case Qt.Key_Up:
        upPressed = true;
        event.accepted = true;
        break;
    case Qt.Key_Down:
        downPressed = true;
        event.accepted = true;
    }
}

function processReleasedKey(event) {
    switch(event.key) {
    case Qt.Key_Right:
        rightPressed = false;
        event.accepted = true;
        break;
    case Qt.Key_Left:
        leftPressed = false;
        event.accepted = true;
        break;
    case Qt.Key_Up:
        upPressed = false;
        event.accepted = true;
        break;
    case Qt.Key_Down:
        downPressed = false;
        event.accepted = true;
    }
}

function computeSpeed() {
    if(rightPressed) {
        increaseSpeedX()
    }
    if(leftPressed) {
        decreaseSpeedX()
    }
    if(upPressed) {
        decreaseSpeedY()
    }
    if(downPressed) {
        increaseSpeedY()
    }
}

function move() {
    if(items.plane.x + items.plane.width > items.background.width &&
            items.plane.speedX > 0) {
        items.plane.speedX = 0;
    }
    if(items.plane.x < 0 && items.plane.speedX < 0) {
        items.plane.speedX = 0;
    }
    items.plane.x += items.plane.speedX;

    if(items.plane.y < 0 && items.plane.speedY < 0) {
        items.plane.speedY = 0;
    }
    if(items.plane.y + items.plane.height > items.background.height &&
            items.plane.speedY > 0) {
        items.plane.speedY = 0;
    }
    items.plane.y += items.plane.speedY;
}

function isIn(x1, y1, px1, py1, px2, py2) {
    return (x1>px1 && x1<px2 && y1>py1 && y1<py2)
}

function handleCollisionsWithCloud() {
    var planeX1 = items.plane.x
    var planeX2 = items.plane.x + items.plane.width
    var planeY1 = items.plane.y
    var planeY2 = items.plane.y + items.plane.height

    if(clouds !== undefined) {
        for(var i = clouds.length - 1; i >= 0 ; --i) {
            var cloud = clouds[i];
            var x1 = cloud.x
            var x2 = cloud.x + cloud.width
            var y1 = cloud.y
            var y2 = cloud.y + cloud.height

            if(x2 < 0) {
                // Remove the cloud
                cloud.destroy()
                clouds.splice(i, 1)
            }
            else if(isIn(x1, y1, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x2, y1, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x1, y2, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x2, y2, planeX1, planeY1, planeX2, planeY2)) {

                // Collision, look for id
                if(cloud.number == items.score.currentSubLevel) {
                    playSound(cloud.number)
                    // Remove the cloud
                    cloud.destroy()
                    clouds.splice(i, 1)

                    items.score.currentSubLevel++

                    if(items.score.currentSubLevel == items.score.numberOfSubLevels
                            && currentLevel === 0) {
                        /* Try the next level */
                        nextLevel()
                        items.bonusSound.play();
                        break;
                    }
                }
            }
        }
    }
}

function playSound(number) {
    /* TODO Use QTextCodec or QString toUnicode instead */
    items.audioNumber.source =
            GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U003" +
                                                      number + ".ogg")
    items.audioNumber.play()
}
