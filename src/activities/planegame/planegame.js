/*
 gcompris - planegame.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port
 2014: Bruno Coudoin: Added support for dataset, smooth plane anim

 SPDX-License-Identifier: GPL-3.0-or-later
*/

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/planegame/"

var max_velocity = 500 * GCompris.ApplicationInfo.ratio
var numberOfLevel
var currentSubLevel
var numberOfSubLevels

var upPressed
var downPressed
var leftPressed
var rightPressed

var items
var dataset

var cloudComponent = Qt.createComponent(url + "Cloud.qml");
var clouds = new Array;
var cloudsErased = new Array;

var audioFileToPlay;
var levelComplete = false;

function start(items_, dataset_) {
    Core.checkForVoices(items_.activityPage);

    items = items_
    dataset = dataset_
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    if(items.showTutorial === false) {
      initLevel()
    }
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
    currentSubLevel = 0
    numberOfSubLevels = dataset[items.currentLevel].data.length

    items.movePlaneTimer.stop();
    items.cloudCreation.stop()

    items.score.message = dataset[items.currentLevel].data[currentSubLevel]
    items.score.visible = dataset[items.currentLevel].showNext

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

    levelComplete = false

    //Inject the first cloud now
    createCloud()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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
    if(levelComplete) {
        return
    }
    var cloud = cloudComponent.createObject(
                items.background, {
                    "background": items.background,
                    "x": items.background.width,
                    "heightRatio": 1.0 - 0.5 * items.currentLevel / 10
                });

    /* Random cloud number but at least one in 3 */
    if(cloudCounter++ % 3 == 0 || getRandomInt(0, 1) === 0) {
        /* Put the target */
        cloud.text = dataset[items.currentLevel].data[currentSubLevel];
        cloudCounter = 1
    } else {
        var min = Math.max(1, currentSubLevel - 1);
        var index = Math.min(min + getRandomInt(0, currentSubLevel - min + 3),
                             numberOfSubLevels - 1)
        cloud.text = dataset[items.currentLevel].data[index]
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

var speedX = 0
var speedY = 0
var speedFactor = 20

function computeVelocity() {

    if(rightPressed && speedX < 300)
        speedX += speedFactor

    if(leftPressed && speedX > -300)
        speedX -= speedFactor

    if(!rightPressed && speedX > 0)
        speedX = 0
    else if(!leftPressed && speedX < 0)
        speedX = 0
    else if(leftPressed || rightPressed)
        items.plane.x += speedX

    if(upPressed && speedY > -300)
        speedY -= speedFactor
    if(downPressed && speedY < 300)
        speedY += speedFactor

    if(!upPressed && speedY < 0)
        speedY = 0
    else if(!downPressed && speedY > 0)
        speedY = 0
    else if(upPressed || downPressed)
        items.plane.y += speedY

    items.plane.rotation = speedX * 10 / max_velocity
}

/* We move x/y of the plane to let its smooth animation track it */
function planeMove() {

    if(items.plane.x + items.plane.width > items.background.width) {
        items.plane.x = items.background.width - items.plane.width;
    }
    if(items.plane.x < 0) {
        items.plane.x = 0;
    }

    if(items.plane.y < 0) {
        items.plane.y = 0;
    }
    if(items.plane.y + items.plane.height > items.background.height - items.bar.height) {
        items.plane.y = items.background.height - (items.plane.height + items.bar.height);
    }

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
                if(cloud.text === dataset[items.currentLevel].data[currentSubLevel]) {
                    playLetterSound(cloud.text)
                    // Move the cloud to the erased list
                    cloud.done()
                    cloudsErased.push(cloud)
                    clouds.splice(i, 1)
                    currentSubLevel++

                    if(currentSubLevel === numberOfSubLevels) {
                        levelComplete = true
                        /* Try the next level */
                        if(items.audioVoices.hasAudio && items.fileChecker.exists(audioFileToPlay)) {
                            items.goToNextLevel = true
                        } else {
                            items.bonus.good("flower")
                        }
                    } else {
                        items.score.message = dataset[items.currentLevel].data[currentSubLevel]
                    }
                } else {
                    /* Touched the wrong cloud */
                    if(!cloud.touched)
                        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
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

function playLetterSound(number) {
    if(number > 9) {
        audioFileToPlay = GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + number + ".$CA")
    } else {
        audioFileToPlay = GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar(number))
    }
    items.audioVoices.play(audioFileToPlay)
}
