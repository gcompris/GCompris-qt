/*
 gcompris - planegame.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port
 2014: Bruno Coudoin: Added support for dataset, smooth plane anim

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

var max_velocity = 500 * GCompris.ApplicationInfo.ratio
var currentLevel
var numberOfLevel
var currentSubLevel
var numberOfSubLevels

var upPressed
var downPressed
var leftPressed
var rightPressed

var items
var dataset

var cloudComponent = Qt.createComponent("qrc:/gcompris/src/activities/planegame/Cloud.qml");
var clouds = new Array;
var cloudsErased = new Array;

function start(items_, dataset_) {
    items = items_
    dataset = dataset_
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel()
}

function stop() {
    cloudDestroy(clouds)
    cloudDestroy(cloudsErased)
    items.movePlaneTimer.stop()
    items.cloudCreation.stop()
}

function cloudDestroy(clouds) {
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        // Remove the cloud
        cloud.destroy()
        // Remove the element from the list
        clouds.splice(i, 1)
    }
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    currentSubLevel = 0
    numberOfSubLevels = dataset[currentLevel].data.length

    items.movePlaneTimer.stop();
    items.cloudCreation.stop()

    items.score.visible = dataset[currentLevel].showNext
    items.score.message = dataset[currentLevel].data[currentSubLevel]

    upPressed = false
    downPressed = false
    leftPressed = false
    rightPressed = false

    cloudDestroy(clouds)
    cloudDestroy(cloudsErased)

    // Tend towards 0.5 ratio
    items.plane.state = "init"
    items.movePlaneTimer.interval = 1000
    items.movePlaneTimer.start();
    items.cloudCreation.start()
    // Inject the first cloud now
    createCloud()
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
    if(items && items.plane) {
        items.movePlaneTimer.interval = 1000
        items.plane.state = "init"
    }
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
    }
}

function repositionObjectsOnHeightChanged(factor) {
    if(items && items.plane) {
        items.movePlaneTimer.interval = 1000
        items.plane.state = "init"
    }
    for(var i = clouds.length - 1; i >= 0 ; --i) {
        var cloud = clouds[i];
        cloud.y *= factor
    }
}

var cloudCounter = 1
function createCloud() {
    var cloud = cloudComponent.createObject(
                items.background, {
                    "background": items.background,
                    "x": items.background.width,
                    "heightRatio": 1.0 - 0.5 * currentLevel / 10
                });

    /* Random cloud number but at least one in 3 */
    if(cloudCounter++ % 3 == 0 || getRandomInt(0, 1) === 0) {
        /* Put the target */
        cloud.text = dataset[currentLevel].data[currentSubLevel];
        cloudCounter = 1
    } else {
        var min = Math.max(1, currentSubLevel - 1);
        var index = Math.min(min + getRandomInt(0, currentSubLevel - min + 3),
                             numberOfSubLevels - 1)
        cloud.text = dataset[currentLevel].data[index]
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

var VELOCITY_STEP = 50
function increaseVelocityX() {
    if(items.plane.velocityX < max_velocity)
        items.plane.velocityX += VELOCITY_STEP;
}

function decreaseVelocityX() {
    if(items.plane.velocityX > -max_velocity)
        items.plane.velocityX -= VELOCITY_STEP;
}

function increaseVelocityY() {
    if(items.plane.velocityY < max_velocity)
        items.plane.velocityY += VELOCITY_STEP;
}

function decreaseVelocityY() {
    if(items.plane.velocityY > - max_velocity)
        items.plane.velocityY -= VELOCITY_STEP;
}

function computeVelocity() {
    if(rightPressed) {
        increaseVelocityX()
    }
    if(leftPressed) {
        decreaseVelocityX()
    }
    if(upPressed) {
        decreaseVelocityY()
    }
    if(downPressed) {
        increaseVelocityY()
    }

    if(!rightPressed && !leftPressed && !upPressed && !downPressed) {
        // Speed auto decreasing
        if(items.plane.velocityX > 10)
            items.plane.velocityX -= 10
        else if(items.plane.velocityX < -10)
            items.plane.velocityX += 10
        else
            items.plane.velocityX = 0

        if(items.plane.velocityY > 10)
            items.plane.velocityY -= 10
        else if(items.plane.velocityY < -10)
            items.plane.velocityY += 10
        else
            items.plane.velocityY = 0
    }
}

/* We move x/y of the plane to let its smooth animation track it */
function planeMove() {

    if(items.plane.x + items.plane.width > items.background.width &&
            items.plane.velocityX > 0) {
        items.plane.velocityX = 0;
    }
    if(items.plane.x < 0 && items.plane.velocityX < 0) {
        items.plane.velocityX = 0;
    }
    if(items.plane.velocityX)
        if(items.plane.velocityX > 0)
            items.plane.x += 10
        else
            items.plane.x -= 10

    if(items.plane.y < 0 && items.plane.velocityY < 0) {
        items.plane.velocityY = 0;
    }
    if(items.plane.y + items.plane.height > items.background.height &&
            items.plane.velocityY > 0) {
        items.plane.velocityY = 0;
    }
    if(items.plane.velocityY)
        if(items.plane.velocityY > 0)
            items.plane.y += 10
        else
            items.plane.y -= 10

}

function isIn(x1, y1, px1, py1, px2, py2) {
    return (x1>px1 && x1<px2 && y1>py1 && y1<py2)
}

function handleCollisionsWithCloud() {
    var planeX1 = items.plane.x
    var planeX2 = items.plane.x + items.plane.width
    var planeY1 = items.plane.y
    var planeY2 = items.plane.y + items.plane.height

    var gotOne = false
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

                gotOne = true
                // Collision, look for id
                if(cloud.text === dataset[currentLevel].data[currentSubLevel]) {
                    playLetterSound(cloud.text)
                    // Move the cloud to the erased list
                    cloud.done()
                    cloudsErased.push(cloud)
                    clouds.splice(i, 1)
                    currentSubLevel++

                    if(currentSubLevel === numberOfSubLevels) {
                        /* Try the next level */
                        nextLevel()
                        playSound("qrc:/gcompris/src/core/resource/sounds/bonus.wav")
                    } else {
                        items.score.message = dataset[currentLevel].data[currentSubLevel]
                    }
                } else {
                    /* Touched the wrong cloud */
                    if(!cloud.touched)
                        playSound("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                    cloud.touch()
                }
                break;
            }
        }

        // Reset the touched state on the clouds
        if(!gotOne) {
            for(var i = clouds.length - 1; i >= 0 ; --i) {
                clouds[i].touched = false
            }
        }
    }
}

function playSound(sound) {
    items.audio.source = sound
    items.audio.play()
}

function playLetterSound(number) {
    /* TODO Use QTextCodec or QString toUnicode instead */
    items.audio.source =
            GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U003" +
                                                      number + ".ogg")
    items.audio.play()
}
