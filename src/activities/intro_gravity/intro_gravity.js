/* GCompris - intro_gravity.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var numberOfLevel = 4;
var items;
var currentImageId = 0


//variables for calculating the crash and safe travel
var distLeft
var distRight
var scaleLeft
var scaleRight
var forceLeft
var forceRight

var x
var y
var move
var collision
var right_force_intensity
var left_force_intensity
var url = "qrc:/gcompris/src/activities/intro_gravity/resource/"
var dataset

//array of created asteroids
var asteroidComponent = Qt.createComponent("qrc:/gcompris/src/activities/intro_gravity/Asteroid.qml");
var asteroids = new Array;
var asteroidsErased = new Array;

function start(items_,dataset_) {
    items = items_
    dataset = dataset_
    currentLevel = 0
    initLevel()
}

function stop() {
    destroyAsteroids(asteroids)
    destroyAsteroids(asteroidsErased)
    items.timer.stop()
    items.asteroidCreation.stop()
}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.timer.stop()
    items.asteroidCreation.stop()

    items.shuttle.x = items.background.width/2

    x = items.shuttle.x;
    y = items.shuttle.y;
    collision = false
    move = 0

    destroyAsteroids(asteroids)
    destroyAsteroids(asteroidsErased)

    items.timer.start()
    items.asteroidCreation.start()

    createAsteroid()
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


// functions to handle asteroids
var asteroidCounter = 1

function createAsteroid() {

    // to take a random asteroid from all
    currentImageId = Math.floor( (Math.random()*100) %5 )
    var ImageUrl = url + "asteroid" +currentImageId+ ".jpg"
    var asteroid = asteroidComponent.createObject(
                items.background, {
                    "background": items.background,
                    "x": (Math.random()*100)/items.background.width,
                    "source" : ImageUrl
                });
    console.log(asteroid);

    asteroids.push(asteroid);
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


function moveShuttle(){
    scaleLeft = items.scaleLeft;
    scaleRight = items.scaleRight;

    distLeft = Math.abs(x - items.planetLeft.x);
    distRight = Math.abs(items.planetRight.x - x);

    move += ( (scaleRight / Math.pow(distRight,2) ) -
                    ( scaleLeft / Math.pow(distLeft,2) ) ) * 200.0 * items.bar.level


    items.shuttle.x += move

    forceLeft = (scaleLeft / Math.pow(distLeft,2) ) * Math.pow(10,5)
    forceRight = (scaleRight / Math.pow(distRight,2) ) * Math.pow(10,5)

//    Manage force direction and intensity and show line

    if (forceRight > forceLeft){
      if (forceRight < 3)
        right_force_intensity = forceRight *2
      else
        right_force_intensity = 6

      drawArrow(items.shuttle.x + items.shuttle.width-10 ,items.shuttle.y ,move,"right")
     }
    else{
      if (forceLeft < 3)
        left_force_intensity = forceLeft *2
      else
        left_force_intensity = 6

      drawArrow(items.shuttle.x+10 ,items.shuttle.y ,move,"left")
    }

// Manage the crash case

    if(items.shuttle.x-items.planetLeft.x < 50)
            crash()
    else if(items.planetRight.x - items.shuttle.x < 50)
            crash()

}

function moveAsteroid(){
        if(asteroids !== undefined){
         for(var i = asteroids.length ; i>0 ; --i){
             var asteroid = asteroids[i];
             var x = asteroid.x
             var y = asteroid.y
             if(y > items.background.width- asteroid.width){
                     asteroid.destroy()
                     asteroids.splice(i,1)
                 }
             else if(y == items.shuttle.y && x == items.shuttle.x){
                     asteroid.done()
                     asteroidsErased.push(asteroid)
                     asteroid.splice(i,1)
                     asteroidCounter++
             }

             if(asteroidCounter == 5) {
                 items.bonus.good("flower")
             }
         }
     }

}

//to draw the line and set width according to intensity of force

function drawArrow(x1,y1,scaling,direction){
    if(direction=="left"){
        items.arrow.x = x1 - 20
        items.arrow.source = url + "arrowleft.svg"
    }
    else{
        items.arrow.x = x1
        items.arrow.source = url + "arrowright.svg"
    }
    items.arrow.y = y1-20
    items.arrow.scale += (0.01*scaling)
}


function crash(){
        collision = true
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
        items.shuttle.source = "qrc:/gcompris/src/activities/intro_gravity/resource/crash.png"
        items.timer.stop()
}
