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
.import QtQuick 2.9 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/erase/resource/"

var backgroundImages = [
    "alpaca.webp",
    "bee.webp",
    "butterfly.webp",
    "calf.webp",
    "camels.webp",
    "caterpillar.webp",
    "chamaeleon.webp",
    "cheetah.webp",
    "crab.webp",
    "dolphin.webp",
    "flying_fox.webp",
    "gibbon.webp",
    "giraffe.webp",
    "goat.webp",
    "gorilla.webp",
    "gosling.webp",
    "heron.webp",
    "horse.webp",
    "kingfisher.webp",
    "kitten.webp",
    "long_nosed_monkey.webp",
    "macaque.webp",
    "meerkats.webp",
    "northern_harrier.webp",
    "nubian_ibex.webp",
    "penguin.webp",
    "pika.webp",
    "red_panda.webp",
    "rhinoceros.webp",
    "spoonbills.webp",
    "squirrel.webp",
    "swans.webp",
    "toucan.webp"
]

var blockImages = [
    url + "transparent_square.svg",
    url + "transparent_square_yellow.svg",
    url + "transparent_square_green.svg"
]

var currentLevel
var currentImage
var main
var items
var type

// The counter of created blocks object
var createdBlocks
var killedBlocks

var nbLevel = 6
var imgIndex

function start(main_, items_, type_) {
    main = main_
    items = items_
    type = type_
    currentLevel = 0
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
    items.bar.level = currentLevel + 1
    items.background.source = url + backgroundImages[currentImage++]
    if(currentImage >= backgroundImages.length) {
        currentImage = 0
    }
    createdBlocks = 0
    killedBlocks = 0
    var nbx = Math.min((currentLevel % 2 * 3) + 5, main.width / (10 * GCompris.ApplicationInfo.ratio));
    var nby = Math.min((currentLevel % 2 * 3) + 5, main.height / (10 * GCompris.ApplicationInfo.ratio));
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
    if( ++currentLevel >= nbLevel ) {
        currentLevel = 0
    }
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
    if(--currentLevel < 0) {
        currentLevel = nbLevel - 1
    }
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
    return backgroundImages[0]
}
