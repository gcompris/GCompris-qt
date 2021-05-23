/* GCompris - clickgame.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.9 as Quick
.import GCompris 1.0 as GCompris

var fishes = [
            {
              "imgName": "blueking2.png",
              "nbFrame": 2,
              "width": 118,
              "height": 76
            },
            {
              "imgName": "butfish.png",
              "nbFrame": 2,
              "width": 98,
              "height": 82
            },
            {
              "imgName": "cichlid1.png",
              "nbFrame": 2,
              "width": 63,
              "height": 37
            },
            {
              "imgName": "cichlid4.png",
              "nbFrame": 2,
              "width": 73,
              "height": 44
            },
            {
              "imgName": "collaris.png",
              "nbFrame": 2,
              "width": 62,
              "height": 50
            },
            {
              "imgName": "discus2.png",
              "nbFrame": 2,
              "width": 100,
              "height": 100
            },
            {
              "imgName": "discus3.png",
              "nbFrame": 2,
              "width": 63,
              "height": 57
            },
            {
              "imgName": "f00.png",
              "nbFrame": 2,
              "width": 64,
              "height": 59
            },
            {
              "imgName": "f01.png",
              "nbFrame": 2,
              "width": 63,
              "height": 50
            },
            {
              "imgName": "f02.png",
              "nbFrame": 2,
              "width": 71,
              "height": 44
            },
            {
              "imgName": "f03.png",
              "nbFrame": 2,
              "width": 83,
              "height": 52
            },
            {
              "imgName": "f04.png",
              "nbFrame": 2,
              "width": 93,
              "height": 62
            },
            {
              "imgName": "f05.png",
              "nbFrame": 2,
              "width": 90,
              "height": 49
            },
            {
              "imgName": "f06.png",
              "nbFrame": 2,
              "width": 93,
              "height": 44
            },
            {
              "imgName": "f07.png",
              "nbFrame": 2,
              "width": 82,
              "height": 75
            },
            {
              "imgName": "f08.png",
              "nbFrame": 2,
              "width": 91,
              "height": 70
            },
            {
              "imgName": "f09.png",
              "nbFrame": 2,
              "width": 108,
              "height": 86
            },
            {
              "imgName": "f10.png",
              "nbFrame": 2,
              "width": 97,
              "height": 60
            },
            {
              "imgName": "f11.png",
              "nbFrame": 2,
              "width": 116,
              "height": 42
            },
            {
              "imgName": "f12.png",
              "nbFrame": 2,
              "width": 100,
              "height": 35
            },
            {
              "imgName": "f13.png",
              "nbFrame": 2,
              "width": 116,
              "height": 73
            },
            {
              "imgName": "manta.png",
              "nbFrame": 2,
              "width": 266,
              "height": 91
            },
            {
              "imgName": "newf1.png",
              "nbFrame": 2,
              "width": 118,
              "height": 81
            },
            {
              "imgName": "QueenAngel.png",
              "nbFrame": 2,
              "width": 78,
              "height": 54
            },
            {
              "imgName": "shark1.png",
              "nbFrame": 2,
              "width": 187,
              "height": 53
            },
            {
              "imgName": "six_barred.png",
              "nbFrame": 2,
              "width": 76,
              "height": 63
            },
            {
              "imgName": "teeth.png",
              "nbFrame": 8,
              "width": 64,
              "height": 64
            },
        ]

var levelProperty = [
            {
                "nbFish": 5,
                "minDuration": 20000
            },
            {
                "nbFish": 7,
                "minDuration": 15000
            },
            {
                "nbFish": 10,
                "minDuration": 10000
            },
            {
                "nbFish": 12,
                "minDuration": 8000
            },
            {
                "nbFish": 15,
                "minDuration": 6000
            },
            {
                "nbFish": 18,
                "minDuration": 4000
            }
        ]
var currentImageId = 0
var currentLevel = 0
var items
var activity
var background
var bar
var bonus

var isActivityStopped = false

// The array of created fishes object
var createdFishes
var component = Qt.createComponent("qrc:/gcompris/src/activities/clickgame/Fish.qml");

function start(activity_, background_, bar_, bonus_, items_) {
    activity = activity_
    background = background_
    bar = bar_
    bonus = bonus_
    items = items_
    currentLevel = 0
    isActivityStopped = false
    initLevel()
    items.killedFishes = 0
}

function stop() {
    isActivityStopped = true
    destroyFishes();
}

function initLevel() {
    if(isActivityStopped)
        return;

    destroyFishes();
    bar.level = currentLevel + 1
    background.source = "qrc:/gcompris/src/activities/clickgame/resource/sea" +
            bar.level + ".jpg"
    var nbFish = levelProperty[currentLevel].nbFish
    createdFishes = new Array(nbFish)
    for(var i = 0;  i < nbFish; ++i) {
         createdFishes[i] = createFish(levelProperty[currentLevel].minDuration)
    }
    items.score.numberOfSubLevels = nbFish
}

function nextLevel() {
    if(levelProperty.length <= ++currentLevel) {
        currentLevel = 0
    }
    
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = levelProperty.length - 1
    }

    initLevel();
}

function createFish(minDuration) {
    var fishSource = fishes[Math.floor(Math.random() * fishes.length)]
    var minY = items.score.y + items.score.height
    var maxY = bar.y - fishSource.height - bar.height
    var fish = component.createObject(
                background,
                {
                    "activity": activity,
                    "background": background,
                    "bar": bar,
                    "y": (Math.random() * (maxY - minY + 1)) + minY,
                    "width": fishSource.width * 1.1 * GCompris.ApplicationInfo.ratio,
                    "height": fishSource.height * 1.1 * GCompris.ApplicationInfo.ratio,
                    "source": "qrc:/gcompris/src/activities/clickgame/resource/" +
                              fishSource.imgName,
                    "frameCount": fishSource.nbFrame,
                    "duration": minDuration + Math.floor(Math.random() * 5000)
                });
    if (fish === null) {
        // Error Handling
        console.log("Error creating object");
    }
    else
        fish.restart()
    return fish;
}

function destroyFishes() {
    if (createdFishes) {
        for(var i = 0;  i < createdFishes.length; ++i) {
            createdFishes[i].destroy()
        }
        createdFishes.length = 0
    }
    items.killedFishes = 0
}

function fishKilled() {
    if(++items.killedFishes === createdFishes.length) {
        bonus.good("flower")
    }
    items.score.playWinAnimation();
}

