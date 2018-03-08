/* GCompris - intro_gravity.js
*
* Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/intro_gravity/resource/"

var currentLevel = 0;
var numberOfLevel = 4;

// delta move
var move

//array of created asteroids
var asteroids = new Array;
var asteroidsErased = new Array;

var minDuration = 20000
var asteroidCounter

var items;
var message;

function start(items_,message_) {
    items = items_
    currentLevel = 0
    message = message_
    initLevel()
}


function stop() {
    items.timer.stop()
    items.asteroidCreation.stop()
    items.shuttleMotion.stop()
    destroyAsteroids(asteroids)
    destroyAsteroids(asteroidsErased)
    asteroidCounter = 0
}

function initLevel() {
    items.bar.level = currentLevel + 1

    stop()

    items.scaleLeft = items.planetLeft.minimumValue + 0.2 * currentLevel
    items.scaleRight = items.planetRight.minimumValue + 0.2 * currentLevel
    items.spaceship.source = url + "tux_spaceship.svg"
    items.spaceshipX = items.background.width / 2

    move = 0

    items.shuttle.x =  Math.random() > 0.5 ?
                items.background.width * 0.2 : items.background.width * 0.7
    items.shuttle.y = items.background.height + items.shuttle.height

    if(items.bar.level != 1) {
        items.timer.start()
        items.asteroidCreation.start()
        items.shuttleMotion.restart()
        message.index = -1
    } else {
        message.index = 0
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


function repositionObjectsOnWidthChanged(factor) {
    if(items) {
        initLevel()
    }
    for(var i = asteroids.length - 1; i >= 0 ; --i) {
        var asteroid = asteroids[i];
    }
}

function repositionObjectsOnHeightChanged(factor) {
    if(items ) {
        initLevel()
    }
    for(var i = asteroids.length - 1; i >= 0 ; --i) {
        var asteroid = asteroids[i];
    }
}


// functions to create and handle asteroids
function createAsteroid() {
    var asteroidComponent = Qt.createComponent("qrc:/gcompris/src/activities/intro_gravity/Asteroid.qml");
    var ImageUrl = url + "asteroid" + Math.floor( Math.random() * 5  ) + ".png"

    var randomX = items.background.width * 0.2 +
            Math.random() * (items.background.width - items.background.width * 0.4)

    var fallDuration = minDuration - Math.floor(Math.random()* 1000 *(currentLevel+1))

    var asteroid = asteroidComponent.createObject(
                items.background,
                {
                    "source" : ImageUrl,
                    "x": randomX,
                    "y": 50,
                    "fallDuration": fallDuration,
                    "scale": GCompris.ApplicationInfo.ratio
                });

    if(asteroid === null) {
        console.log("error in creating the asteroid object")
    }

    asteroids.push(asteroid);
    asteroid.startMoving()
    asteroidCounter++
}

function destroyAsteroids(asteroids) {
    for(var i = asteroids.length - 1; i >= 0 ; --i) {
        var asteroid = asteroids[i];
        // Remove the asteroid
        asteroid.destroy()
        // Remove the element from list
        asteroids.splice(i,1)
    }
}


function moveSpaceship() {
    move += (items.forceRight - items.forceLeft) / 10000 * items.bar.level
    items.spaceshipX += move

    // Manage the crash case
    if(items.spaceshipX < 200 * GCompris.ApplicationInfo.ratio)
        crash()
    else if(items.spaceshipX > items.background.width - 200 * GCompris.ApplicationInfo.ratio)
        crash()

    // Manage to get into shuttle
    var shuttleY = items.shuttle.y + items.shuttle.height / 2
    var shuttleX = items.shuttle.x + items.shuttle.width / 2
    if(shuttleY > items.spaceshipY - items.spaceship.height / 2 &&
            shuttleY < items.spaceshipY + items.spaceship.height / 2 &&
            shuttleX > items.spaceshipX -items.spaceship.width / 2 &&
            shuttleX < items.spaceshipX + items.spaceship.width / 2) {
        items.bonus.good("flower")
        items.spaceship.source = ""
        stop()
    }
}

function handleCollisionWithAsteroid() {
    if(asteroids !== undefined) {
        for(var i = asteroids.length -1 ; i >= 0 ; --i) {
            var asteroid = asteroids[i];
            var x = asteroid.x + asteroid.width / 2
            var y = asteroid.y + asteroid.height / 2

            if(y > items.background.height) {
                asteroid.destroy()
                asteroids.splice(i,1)
            } else if(y > items.spaceshipY - items.spaceship.height / 2 &&
                      y < items.spaceshipY + items.spaceship.height / 2 &&
                      x > items.spaceshipX - items.spaceship.width / 2 &&
                      x < items.spaceshipX + items.spaceship.width / 2 ) {
                asteroid.destroy()
                asteroids.splice(i,1)
                crash()
                return
            }
            if(asteroidCounter == 4) {
                items.bonus.good("flower")
                stop()
                return
            }

        }
    }
}

function crash() {
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
    items.spaceship.source = url + "crash.svg"
    stop()
}
