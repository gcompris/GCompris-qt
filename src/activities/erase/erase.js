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
.import core 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core
.import QtQuick 2.12 as Quick

var url = "qrc:/gcompris/src/activities/erase/resource/"

//array of array, each with filename, horizontalAlignment and verticalAlignment
var backgroundImages = [
    ["alpaca.webp", Quick.Image.AlignLeft, Quick.Image.AlignTop],
    ["bee.webp", Quick.Image.AlignLeft, Quick.Image.AlignVCenter],
    ["butterfly.webp", Quick.Image.AlignLeft, Quick.Image.AlignVCenter],
    ["calf.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["camels.webp", Quick.Image.AlignRight, Quick.Image.AlignVCenter],
    ["caterpillar.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["chamaeleon.webp", Quick.Image.AlignLeft, Quick.Image.AlignVCenter],
    ["cheetah.webp", Quick.Image.AlignRight, Quick.Image.AlignTop],
    ["crab.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["dolphin.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["flying_fox.webp", Quick.Image.AlignHCenter, Quick.Image.AlignBottom],
    ["gibbon.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["giraffe.webp", Quick.Image.AlignRight, Quick.Image.AlignVCenter],
    ["goat.webp", Quick.Image.AlignRight, Quick.Image.AlignTop],
    ["gorilla.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["gosling.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["heron.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["horse.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["kingfisher.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["kitten.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["long_nosed_monkey.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["macaque.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["meerkats.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["northern_harrier.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["nubian_ibex.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["penguin.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["pika.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["red_panda.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["rhinoceros.webp", Quick.Image.AlignHCenter, Quick.Image.AlignVCenter],
    ["spoonbills.webp", Quick.Image.AlignLeft, Quick.Image.AlignTop],
    ["squirrel.webp", Quick.Image.AlignHCenter, Quick.Image.AlignTop],
    ["swans.webp", Quick.Image.AlignRight, Quick.Image.AlignTop],
    ["toucan.webp", Quick.Image.AlignLeft, Quick.Image.AlignTop]
]

var blockImages = [
    url + "transparent_square.svg",
    url + "transparent_square_yellow.svg",
    url + "transparent_square_green.svg"
]

var currentImage
var items

// The counter of created blocks object
var createdBlocks
var killedBlocks

var numberOfLevel = 6
var blockImagesIndex

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items_.currentSubLevel = 0
    currentImage = 0
    blockImagesIndex = 0
    backgroundImages = Core.shuffle(backgroundImages)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.blocks.clear()
    blockImagesIndex++
    if(blockImagesIndex >= blockImages.length) {
        blockImagesIndex = 0
    }
    currentImage++
    if(currentImage >= backgroundImages.length) {
        currentImage = 0
    }
    items.activityBackground.source = url + backgroundImages[currentImage][0]
    items.activityBackground.alignBackground()
    createdBlocks = 0
    killedBlocks = 0
    var nbx = Math.min((items.currentLevel % 2 * 3) + 5, items.activityBackground.width / (10 * GCompris.ApplicationInfo.ratio));
    var nby = Math.min((items.currentLevel % 2 * 3) + 5, items.activityBackground.height / (10 * GCompris.ApplicationInfo.ratio));
    var data

    for(var x = 0;  x < nbx; ++x) {
        for(var y = 0;  y < nby; ++y) {
            data = {
                'nx': nbx, 'ny': nby, 'a': x, 'b': y,
                'img': blockImages[blockImagesIndex]
            }
            items.blocks.append(data)
        }
    }
    createdBlocks = nbx * nby;
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( items.currentSubLevel >= items.nbSubLevel) {
        items.bonus.good("flower")
        return;
    }
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function blockKilled() {
    if(++killedBlocks === createdBlocks) {
        items.currentSubLevel += 1
        items.winSound.play()
        items.score.playWinAnimation()
        if(items.mode === 2) {
            items.okButton.levelFinished = true
        }
    }
}
