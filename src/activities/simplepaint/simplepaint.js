/* GCompris - simplepaint.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

var colorShortcut = {
    0: 'white',
    1: 'red',
    2: 'orange',
    3: 'green',
    4: 'blue',
    5: 'yellow',
    6: 'black'
}
var colors = {
    0: '#FFFFFFFF',
    1: '#FFEE0000',
    2: '#FFFFBA00',
    3: '#FF53D537',
    4: '#FF3759D5',
    5: '#FFF5F357',
    6: '#FF3D2626'
}

var backgrounds = [
    'qrc:/gcompris/src/activities/menu/resource/background.svg',
    'qrc:/gcompris/src/activities/colors/resource/background.svg',
    'qrc:/gcompris/src/activities/wordsgame/resource/background.svg',
    'qrc:/gcompris/src/activities/sudoku/resource/background.svg',
    'qrc:/gcompris/src/activities/mosaic/resource/background.svg',
    'qrc:/gcompris/src/activities/algebra_by/resource/background.svg',
    'qrc:/gcompris/src/activities/scalesboard/resource/background.svg',
    'qrc:/gcompris/src/activities/redraw/resource/background.svg',
    'qrc:/gcompris/src/activities/color_mix/resource/background.svg',
    'qrc:/gcompris/src/activities/missing-letter/resource/background.svg',
    'qrc:/gcompris/src/activities/enumerate/resource/background.svg',
    'qrc:/gcompris/src/activities/football/resource/background.svg',
    'qrc:/gcompris/src/activities/hanoi_real/resource/background.svg',
    'qrc:/gcompris/src/activities/intro_gravity/resource/background.svg',
    'qrc:/gcompris/src/activities/instruments/resource/background.svg',
    'qrc:/gcompris/src/activities/gletters/resource/background.svg',
    'qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg',
    'qrc:/gcompris/src/activities/followline/resource/background.svg',
    'qrc:/gcompris/src/activities/money/resource/background.svg',
    'qrc:/gcompris/src/activities/menu/resource/background.svg',
    'qrc:/gcompris/src/activities/smallnumbers2/resource/background.svg',
    'qrc:/gcompris/src/activities/align4-2players/resource/background.svg',
    'qrc:/gcompris/src/activities/smallnumbers/resource/background.svg',
    'qrc:/gcompris/src/activities/magic-hat-minus/resource/background.svg',
    'qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg',
    'qrc:/gcompris/src/activities/click_on_letter/resource/background.svg',
    'qrc:/gcompris/src/activities/fifteen/resource/background.svg'
]

var main
var items

// The size of the array
var nbx
var nby

var currentLevel = 0
var numberOfLevel = backgrounds.length

function start(main_, items_) {
    main = main_
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.paintModel.clear()
    nbx = 20 + currentLevel
    nby = Math.floor(nbx * (main.height / main.width))

    if(currentLevel == 0)
        colors[0] = '#FFFFFFFF'
    else
        colors[0] = '#00FFFFFF'

    var model = []
    for(var ix = 0;  ix < nbx; ++ix) {
        for(var iy = 0;  iy < nby; ++iy) {
            items.paintModel.append( {
               "m_ix": ix, "m_iy": iy, "m_nbx": nbx, "m_nby": nby,
            } )
        }
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

function getColor() {
    return colors[items.colorSelector]
}
