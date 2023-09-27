/* GCompris - football.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/football/resource/"

var numberOfLevel = 8
var items
var flag = 0
var friction = 0.995
var velocityX
var velocityY
var tuxCollision

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.timer.stop();
}

function initLevel() {
    items.ball.x = items.border.width * 0.2
    items.ball.y = items.border.height / 2 - items.ball.height / 2
    velocityX = 0
    velocityY = 0
    tuxCollision = false
    /* Increase size of TUX for each level */
    items.tux.sourceSize.height = 10 * (5 + 2 * items.bar.level) * GCompris.ApplicationInfo.ratio
    moveTux(items.background.height)
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function startMotion(x1, y1) {
    var velocity = Math.sqrt(Math.pow(x1, 2) +
                          Math.pow(y1, 2))
    velocity = Math.min(10, velocity * 0.5)
    /* Modify speed of ball here */
    velocityX = velocity * x1 * 0.01 * -1 / 5
    velocityY = velocity * y1 * 0.01 * -1 / 5
    tuxCollision = false
    items.timer.start()
}

/* Calculates the angle between the two points */
function getAngle(sx1, sy1, sx2, sy2)
{
        var dy, slope, angle;
        var dx = sx2 - sx1;
        if (dx === 0)
            return 0;
        dy = sy2 - sy1;
        slope = dy / dx;
        angle = Math.atan(slope) * 180 / Math.PI;

        if (dy < 0 && dx < 0){
            return angle;
        }
        else if (dy >= 0 && dx >= 0){
            return angle + 180;
        }
        else if (dy < 0 && dx >= 0){
            return angle + 180;
        }
        else if (dy >= 0 && dx < 0){
            return angle;
        }
        else
            return 0;
    }

/* Draw a line dynamically to display the drag */
function drawLine(x1, y1, x2, y2){
    items.line.height = 5
    items.line.rotation = getAngle(x1, y1, x2, y2);
    items.line.width = Math.sqrt(Math.pow((x1 - x2), 2) + Math.pow((y1- y2), 2));
    items.line.x = x2
    items.line.y = y2
}

/* Tux moves up and down, called in initlevel() */
function moveTux(height){
    items.moveUp.to = 0
    items.moveDown.to = items.background.height * 0.75 - items.tux.height
    items.moveTux.restart()
}


function ballMotion() {
    items.ball.x += velocityX
    items.ball.y += velocityY

    if(items.ball.y > (items.border.height - items.ball.height)) { //bottom
        velocityY *= -1
        items.ball.y = items.border.height - items.ball.height
        tuxCollision = false
    } else if(items.ball.x > (items.border.width)) { //right ---- GOAL!
        velocityX *= 0
        velocityY *= 0
        items.ball.x = items.border.width// - items.ball.width
        items.bonus.good("smiley")
    } else if(items.ball.x < 0) { // left
        velocityX *= -1
        items.ball.x = 0
        tuxCollision = false
    } else if(items.ball.y < 0) { //top
        velocityY *= -1
        items.ball.y = 0
        tuxCollision = false
    }
    /* Collision with TUX */
    else if(items.ball.y > items.tux.y &&
            items.ball.y <= items.tux.y + items.tux.height/2 &&
            items.ball.x > items.tux.x &&
            items.ball.x <= items.tux.x + items.tux.width/2 &&
            !tuxCollision) {
        velocityY *= -2
        velocityX *= -2
        tuxCollision = true
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
    }

    // Friction
    velocityX *= friction
    velocityY *= friction

    // Ball stop
    if(Math.abs(velocityX) < 0.2 && Math.abs(velocityY) < 0.2) {
        velocityX = 0
        velocityY = 0
        items.timer.stop()
    }
}
