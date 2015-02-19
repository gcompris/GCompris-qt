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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var numberOfLevel = 4;

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
var right_force_intensity
var left_force_intensity
var url = "qrc:/gcompris/src/activities/intro_gravity/resource/"

//array of created asteroids
var asteroids = new Array;
var asteroidsErased = new Array;

var fallDuration
var minDuration = 2000
var asteroidCounter = 1
var randomX
var currentImageId = 0

var items;
var activity
var background
var bar
var bonus

function start(items_,activity_, background_, bar_, bonus_) {
    items = items_
    activity = activity_
    background = background_
    bar = bar_
    bonus = bonus_
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

    items.scaleLeft = 1.5 ; items.scaleRight = 1.5
    items.shuttle.x = items.background.width/2
    items.arrow.scale = 1

    x = items.shuttle.x;
    y = items.shuttle.y;
    move = 0

    fallDuration = minDuration
    asteroidCounter = 1
    destroyAsteroids(asteroids)
    destroyAsteroids(asteroidsErased)

    items.shuttle.source = url + "tux_spaceship.png"

    if(items.bar.level !==1){    // no instructions on these levels directly start the game
            items.timer.start()
            items.asteroidCreation.start()
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


// functions to create and handle asteroids

function createAsteroid() {

    var asteroidComponent = Qt.createComponent("qrc:/gcompris/src/activities/intro_gravity/Asteroid.qml");
    currentImageId = Math.floor( Math.random()*5  )
    console.log(currentImageId)
    var ImageUrl = url+"asteroid"+currentImageId+".jpg"

    randomX = Math.floor(Math.random() * (items.background.width-200))
    console.log(randomX)
    if(randomX < 200){
        randomX += 200
    }
    console.log("change happens"+randomX)

    fallDuration = minDuration + Math.floor(Math.random()* 10000 * (currentLevel + 1))
    console.log(currentLevel+ fallDuration)
    var asteroid = asteroidComponent.createObject(
                items.background,
                {
                    "activity": activity,
                    "background": items.background,
                    "bar": bar,
                    "source" : ImageUrl,
                    "x": randomX,
                    "y": 0,
                    "fallDuration": fallDuration
                });

    if(asteroid== null){
        console.log("error creating asteroid object")
    }
    else{
        console.log("successfully created asteroid")
    }

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

      drawArrow(items.shuttle.x + items.shuttle.width-10 ,items.shuttle.y ,right_force_intensity,"right")
     }
    else{
      if (forceLeft < 3)
        left_force_intensity = forceLeft *2
      else
        left_force_intensity = 6

      drawArrow(items.shuttle.x+10 ,items.shuttle.y ,left_force_intensity,"left")
    }

// Manage the crash case

    if(items.shuttle.x-items.planetLeft.x < 50)
            crash()
    else if(items.planetRight.x - items.shuttle.x < 50)
            crash()

}

function moveAsteroid(){
        if(asteroids !== undefined){
         for(var i = asteroids.length -1 ; i>=0 ; --i){
             var asteroid = asteroids[i];
             var x = asteroid.x
             var y = asteroid.y

             asteroid.startMoving(asteroid.fallDuration)
             if(y > items.background.height + asteroid.height){
                     asteroid.destroy()
                     asteroids.splice(i,1)
                    asteroidCounter++
                 }
             else if(y > items.shuttle.y -80 && y < items.shuttle.y +40
                     && x>items.shuttle.x -40 && x< items.shuttle.x + 80 ){
                     asteroids.splice(i,1)
                     asteroidsErased.push(asteroid)

                    crash()
             }

             if(asteroidCounter == 5) {
                 items.asteroidCreation.stop()
                 items.bonus.good("flower")
             }
         }
     }

}


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
    items.arrow.scale = scaling *(background.width/2)
}


function crash(){
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
        items.shuttle.source = "qrc:/gcompris/src/activities/intro_gravity/resource/crash.png"
        stop()
}
