.pragma library
.import QtQuick 2.0 as Quick

var maxNumberOfLevel = 9
var currentLevel = 0
var main
var background
var bar
var bonus

// The array of created hexagon object
var createdHexagon
var killedHexagon
var strawBerry
var nbx
var nby

function start(_main, _background, _bar, _bonus) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    currentLevel = 0
    initLevel()
}

function stop() {
    destroyHexagon()
}

function initLevel() {
    destroyHexagon();
    bar.level = currentLevel + 1
    createdHexagon = new Array()
    nbx = 10 + currentLevel
    nby = Math.floor(nbx * (main.height / main.width))
    var i = 0

    for(var ix = 0;  ix < nbx; ++ix) {
        for(var iy = 0;  iy < nby; ++iy) {
            if( (iy % 2 && ix < nbx - 1) || iy % 2 == 0)
                createdHexagon[i++] = createHexagon(ix, iy, nbx, nby)
        }
    }

    // Select a random place for the strawberry
    strawBerry = Math.floor(Math.random() * i)
    createdHexagon[strawBerry].hasStrawberry = true

}

function nextLevel() {
    if(maxNumberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxNumberOfLevel - 1
    }
    initLevel();
}

function createHexagon(ix, iy, nbx, nby) {
    var component = Qt.createComponent("qrc:/gcompris/src/activities/hexagon/Hexagon.qml");
    var hexagon = component.createObject(
                background,
                {
                    "main": main,
                    "ix": ix,
                    "iy": iy,
                    "nbx": nbx,
                    "nby": nby,
                    "color": "rgba(0,153,255,1.0)"
                });

    if (hexagon === null) {
        // Error Handling
        console.log("Error creating object");
    }
    return hexagon;
}

function destroyHexagon() {
    if (createdHexagon) {
        for(var i = 0;  i < createdHexagon.length; ++i) {
            createdHexagon[i].destroy()
        }
        createdHexagon.length = 0
    }
    killedHexagon = 0
}

function strawberryFound() {
    bonus.good("flower")
}

function getDistance(ix, iy) {
    var jx = createdHexagon[strawBerry].ix
    var jy = createdHexagon[strawBerry].iy
    return Math.sqrt(Math.pow((ix - jx), 2) + Math.pow((iy - jy), 2))
}

function getColor(dist) {
    var r = 0
    var b = 0
    var g = 0
    if (dist < 5) {
        r = 0xFF
        g = 0xFF * (dist / 5)
    } else if(dist < 10) {
        g = 0xFF
        r = 0xFF - 0xFF  * ((dist - 5) / 5)
    } else if (dist < 15) {
        g = 0xFF - 0xFF * ((dist - 10) / 5)
        b = 0xFF * ((dist - 10) / 5)
    } else {
        // Calc the max size
        var maxSize = Math.sqrt(Math.pow(nbx, 2) + Math.pow(nby, 2))
        b = 0xFF
        r = 0xFF * ((dist - 15) / maxSize)
    }
    return "rgba(" + Math.floor(r) + "," + Math.floor(g) + "," + Math.floor(b) + ",1.0)"
}
