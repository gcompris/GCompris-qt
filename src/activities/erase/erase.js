/* GCompris - erase.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/erase/resource/"

//array of array, each with filename, horizontalAlignment and verticalAlignment
var backgroundImages = [
    ["alpaca.webp", "left", "top"],
    ["bee.webp", "left", "center"],
    ["butterfly.webp", "left", "center"],
    ["calf.webp", "center", "center"],
    ["camels.webp", "right", "center"],
    ["caterpillar.webp", "center", "center"],
    ["chamaeleon.webp", "left", "center"],
    ["cheetah.webp", "right", "top"],
    ["crab.webp", "center", "center"],
    ["dolphin.webp", "center", "top"],
    ["flying_fox.webp", "center", "bottom"],
    ["gibbon.webp", "center", "center"],
    ["giraffe.webp", "right", "center"],
    ["goat.webp", "right", "top"],
    ["gorilla.webp", "center", "center"],
    ["gosling.webp", "center", "top"],
    ["heron.webp", "center", "center"],
    ["horse.webp", "center", "top"],
    ["kingfisher.webp", "center", "top"],
    ["kitten.webp", "center", "center"],
    ["long_nosed_monkey.webp", "center", "top"],
    ["macaque.webp", "center", "center"],
    ["meerkats.webp", "center", "top"],
    ["northern_harrier.webp", "center", "center"],
    ["nubian_ibex.webp", "center", "top"],
    ["penguin.webp", "center", "top"],
    ["pika.webp", "center", "top"],
    ["red_panda.webp", "center", "center"],
    ["rhinoceros.webp", "center", "center"],
    ["spoonbills.webp", "left", "top"],
    ["squirrel.webp", "center", "top"],
    ["swans.webp", "right", "top"],
    ["toucan.webp", "left", "top"]
]

var blockImages = [
    url + "transparent_square.svg",
    url + "transparent_square_yellow.svg",
    url + "transparent_square_green.svg"
]

var currentImage
var main
var items
var type

// The counter of created blocks object
var createdBlocks
var killedBlocks

var numberOfLevel = 6
var imgIndex

function start(main_, items_, type_) {
    main = main_
    items = items_
    type = type_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items_.currentSubLevel = 0
    currentImage = 0
    imgIndex = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.blocks.clear()
    imgIndex++
    currentImage++
    if(currentImage >= backgroundImages.length) {
        currentImage = 0
    }
    items.background.source = url + backgroundImages[currentImage][0]
    items.background.alignBackground()
    createdBlocks = 0
    killedBlocks = 0
    var nbx = Math.min((items.currentLevel % 2 * 3) + 5, main.width / (10 * GCompris.ApplicationInfo.ratio));
    var nby = Math.min((items.currentLevel % 2 * 3) + 5, main.height / (10 * GCompris.ApplicationInfo.ratio));
    var data

        for(var x = 0;  x < nbx; ++x) {
            for(var y = 0;  y < nby; ++y) {
                data = {
                    'nx': nbx, 'ny': nby, 'a': x, 'b': y,
                    'op': 1.0, 'MAIN': main, 'BAR': items.bar,
                    'img': blockImages[imgIndex % blockImages.length]
                }
                items.blocks.append(data)
                createdBlocks++
            }
        }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++items.currentSubLevel >= items.nbSubLevel) {
        items.currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function blockKilled() {
    if(++killedBlocks === createdBlocks) {
        items.bonus.good("flower")
    }
}

function getFirstImage() {
    backgroundImages = Core.shuffle(backgroundImages)
    return backgroundImages[0][0]
}
