/* GCompris - simplepaint.js
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
    'qrc:/gcompris/src/activities/gravity/resource/background.svg',
    'qrc:/gcompris/src/activities/instruments/resource/background.svg',
    'qrc:/gcompris/src/activities/gletters/resource/background.svg',
    'qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg',
    'qrc:/gcompris/src/activities/followline/resource/background.svg',
    'qrc:/gcompris/src/activities/bargame/resource/background.svg',
    'qrc:/gcompris/src/activities/menu/resource/background.svg',
    'qrc:/gcompris/src/activities/smallnumbers2/resource/background.svg',
    'qrc:/gcompris/src/activities/align4_2players/resource/background.svg',
    'qrc:/gcompris/src/activities/smallnumbers/resource/background.svg',
    'qrc:/gcompris/src/activities/magic-hat-minus/resource/background.svg',
    'qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg',
    'qrc:/gcompris/src/activities/click_on_letter/resource/background.svg',
    'qrc:/gcompris/src/activities/fifteen/resource/background.svg',
    'qrc:/gcompris/src/activities/crane/resource/background.svg',
    'qrc:/gcompris/src/activities/hangman/resource/background.svg',
    'qrc:/gcompris/src/activities/land_safe/resource/background.svg',
    'qrc:/gcompris/src/activities/target/resource/target_background.svg',
]

var items

// The size of the array
var nbx
var nby

var numberOfLevel = backgrounds.length

var background

function start(items_, _background) {
    background = _background
    items = items_
    Core.getInitialLevel(numberOfLevel);
    initLevel()
}

function stop() {
}

function initLevel() {
    items.paintModel.clear()
    items.current_color = 1
    items.selectedColor = items.colors[1]
    items.colorSelector.positionViewAtBeginning()
    nbx = 20 + items.currentLevel
    nby = Math.floor(nbx * (items.gridLayout.height / items.gridLayout.width))
    background.refreshCursor()

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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function getColor() {
    return items.selectedColor
}
