/* GCompris - Hexagon.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/hexagon/resource/"
var numberOfLevel = 12;
var main
var items

// The size of the array
var nbx
var nby
// The strawberry position
var strawBerryX
var strawBerryY

function start(main_, items_) {
    main = main_
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.hexagonModel.clear()
    nbx = 10 + items.currentLevel
    nby = Math.floor(nbx * (main.height / main.width))

    // Select a random place for the strawberry
    strawBerryX = Math.floor(Math.random() * (nbx -1))
    strawBerryY = Math.floor(Math.random() * nby)

    var model = []
    for(var ix = 0;  ix < nbx; ++ix) {
        for(var iy = 0;  iy < nby; ++iy) {
            if( (iy % 2 && ix < nbx - 1) || iy % 2 == 0)
                items.hexagonModel.append( {
                   "m_ix": ix, "m_iy": iy, "m_nbx": nbx, "m_nby": nby,
                   "m_hasStrawberry":  (strawBerryX === ix && strawBerryY === iy) ? true : false
                } )
        }
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function strawberryFound() {
    items.bonus.good("flower")
}

function getDistance(ix, iy) {
    return Math.sqrt(Math.pow((ix - strawBerryX), 2) + Math.pow((iy - strawBerryY), 2))
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
    return Qt.rgba(r/255, g/255, b/255, 1)
}
