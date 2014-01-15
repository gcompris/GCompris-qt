.pragma library
.import QtQuick 2.0 as Quick

var fishes = [
            {
              "imgName": "blueking2.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "butfish.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "cichlid1.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "cichlid4.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "collaris.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "discus2.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "discus3.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f00.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f01.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f02.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f03.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f04.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f05.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f06.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f07.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f08.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f09.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f10.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f11.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f12.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "f13.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "manta.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "newf1.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "QueenAngel.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "shark1.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "six_barred.png",
              "nbFrame": 2,
              "width": 128,
              "height": 126
            },
            {
              "imgName": "teeth.png",
              "nbFrame": 8,
              "width": 128,
              "height": 126
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
        ]
var currentImageId = 0;
var currentLevel = 0;
var background
var bar;
var bonus;

// The array of created fishes object
var createdFishes;
var killedFishes;

function start(_background, _bar, _bonus) {
    background = _background
    bar = _bar;
    bonus = _bonus;
    currentLevel = 0
    initLevel()
}

function stop() {
    destroyFishes();
}

function initLevel() {
    destroyFishes();
    bar.level = currentLevel + 1
    background.source = "qrc:/gcompris/src/activities/clickgame/resource/sea" +
            bar.level + ".jpg"
    createdFishes = new Array()
    for(var i = 0;  i < levelProperty[currentLevel].nbFish; ++i) {
         createdFishes[i] = createFish(levelProperty[currentLevel].minDuration, i)
    }
}

function nextLevel() {
    if(levelProperty.length <= ++currentLevel ) {
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

function leftClick() {
    if(currentHands[currentImageId].image.indexOf("gauche") !== -1) {
        displayNextHand()
    } else {
        bonus.bad("flower")
    }
}

function rightClick() {
    if(currentHands[currentImageId].image.indexOf("droit") !== -1) {
        displayNextHand()
    } else {
        bonus.bad("flower")
    }
}

function createFish(minDuration) {
    var component = Qt.createComponent("qrc:/gcompris/src/activities/clickgame/Fish.qml");
    var fishSource = fishes[Math.floor(Math.random() * fishes.length)]
    var fish = component.createObject(
                background,
                {
                    "x": Math.floor(Math.random() * 400) + 100,
                    "y": Math.floor(Math.random() * 500),
                    "width": fishSource.width,
                    "height": fishSource.height,
                    "source": "qrc:/gcompris/src/activities/clickgame/resource/" +
                              fishSource.imgName,
                    "frameCount": fishSource.nbFrame,
                    "duration": minDuration + Math.floor(Math.random() * 5000)
                });
    fish.restart()

    if (fish === null) {
        // Error Handling
        console.log("Error creating object");
    }
    return fish;
}

function destroyFishes() {
    if (createdFishes) {
        for(var i = 0;  i < createdFishes.length; ++i) {
            createdFishes[i].destroy()
        }
        createdFishes.length = 0
    }
    killedFishes = 0
}

function fishKilled() {
    killedFishes += 1
    if(killedFishes === createdFishes.length) {
        nextLevel()
    }
}

function getY(y) {
    if(currentLevel > 3) {
        return Math.floor(Math.random() * 500)
    }
    return y
}
