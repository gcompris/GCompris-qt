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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick

var url = "qrc:/gcompris/src/activities/simplepaint/resource/"

var colorsSimple = [
            '#00FFFFFF',
            '#FF550000',
            '#FFaa0000',
            '#FFffaaaa',
            '#FFffdd55',
            '#FF918a6f',
            '#FFccff00',
            '#FFe5ff80',
            '#FF330080',
            '#FF9955ff',
            '#FFe9afdd',
            '#FFff2a7f'
]

var colorsAdvanced = [
            '#00FFFFFF',
            '#FF550000',
            '#FF800000',
            '#FFaa0000',
            '#FFd40000',
            '#FFff0000',
            '#FFff2a2a',
            '#FFff8080',
            '#FFffaaaa',
            '#FFffd5d5',
            '#FFc83737',
            '#FFd35f5f',
            '#FFde8787',
            '#FFaa4400',
            '#FFd45500',
            '#FFff7f2a',
            '#FFff9955',
            '#FFffccaa',
            '#FFaa8800',
            '#FFffcc00',
            '#FFffdd55',
            '#FFffe680',
            '#FFc8ab37',
            '#FFd3bc5f',
            '#FF918a6f',
            '#FFaca793',
            '#FFaad400',
            '#FFccff00',
            '#FFe5ff80',
            '#FFf6ffd5',
            '#FF00d455',
            '#FF80ffb3',
            '#FF00ffcc',
            '#FF80ffe6',
            '#FF2ad4ff',
            '#FFaaeeff',
            '#FF0066ff',
            '#FF5555ff',
            '#FF87aade',
            '#FF80b3ff',
            '#FF0000ff',
            '#FF330080',
            '#FF9955ff',
            '#FFdd55ff',
            '#FFff2ad4',
            '#FFe9afdd',
            '#FFff2a7f',
            '#FFff80b2',
            '#FFd35f8d'
]

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
    return items.colorSelector
}
