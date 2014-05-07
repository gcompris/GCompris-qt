.pragma library
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var backgroundImages = [
    "Adelie_Penguin2.jpg",
    "Adelie_Penguin.jpg",
    "Asian_Elephant_and_Baby.jpg",
    "bear001.jpg",
    "black-headed-gull.jpg",
    "butterfly.jpg",
    "cape_petrel.jpg",
    "cat1.jpg",
    "cat2.jpg",
    "cow.jpg",
    "donkey.jpg",
    "earless_seal2.jpg",
    "earless_seal.jpg",
    "elephanteauxgc.jpg",
    "emperor_penguin.jpg",
    "flamentrosegc.jpg",
    "fulmar_antarctic.jpg",
    "gazelle.jpg",
    "giant_panda.jpg",
    "girafegc.jpg",
    "golden_toad.jpg",
    "Helioconius_sp_Richard_Bartz.jpg",
    "honey_bee.jpg",
    "horses2.jpg",
    "horses.jpg",
    "hypogc.jpg",
    "joybear002.jpg",
    "jumentmulassieregc.jpg",
    "maki1.jpg",
    "maki2.jpg",
    "maki3.jpg",
    "maki4.jpg",
    "maki5.jpg",
    "maki6.jpg",
    "malaybear002.jpg",
    "papilio_demodocus.jpg",
    "polabear011.jpg",
    "polarbear001.jpg",
    "poolbears001.jpg",
    "Pteroglossus-torquatus-001.jpg",
    "rhinogc.jpg",
    "sheep_irish2.jpg",
    "sheep_irish.jpg",
    "singegc.jpg",
    "skua.jpg",
    "snow_petrels.jpg",
    "spectbear001.jpg",
    "Spider_vdg.jpg",
    "squirrel.jpg",
    "tetegorillegc.jpg",
    "tiger1_by_Ralf_Schmode.jpg",
    "tigercub003.jpg",
    "tigerdrink001.jpg",
    "tigerplay001.jpg",
    "White_shark.jpg"
]

var blockImages = [
    "qrc:/gcompris/src/activities/erase/resource/transparent_square.svgz",
    "qrc:/gcompris/src/activities/erase/resource/transparent_square_yellow.svgz",
    "qrc:/gcompris/src/activities/erase/resource/transparent_square_green.svgz"
]

var currentLevel
var currentSubLevel
var currentImage
var main
var items
var type

// The array of created blocks object
var createdBlocks
var killedBlocks

var nbLevel = 6
var nbSubLevel = 8

function start(main_, items_, type_) {
    main = main_
    items = items_
    type = type_
    currentLevel = 0
    currentSubLevel = 0
    currentImage = 0
    initLevel()
}

function stop() {
    destroyBlocks();
}

function initLevel() {
    destroyBlocks();
    items.bar.level = currentLevel + 1
    items.background.source = "qrc:/gcompris/src/activities/erase/resource/" +
            backgroundImages[currentImage++]
    if(currentImage >= backgroundImages.length) {
        currentImage = 0
    }
    createdBlocks = new Array()
    var nbx = (currentLevel % 2 * 3) + 5;
    var nby = (currentLevel % 2 * 3) + 5;
    var w = main.width / nbx
    var h = (main.height - items.bar.height) / nby
    var i = 0

    for(var imgIndex = 0; imgIndex <= Math.floor(currentLevel / 2) ; imgIndex++) {
        for(var x = 0;  x < nbx; ++x) {
            for(var y = 0;  y < nby; ++y) {
             createdBlocks[i++] = createBlock(x, y, nbx, nby, blockImages[imgIndex])
            }
        }
    }
}

function nextLevel() {
    if( ++currentLevel >= nbLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= nbSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = nbLevel - 1
    }
    initLevel();
}

function createBlock(ix, iy, nbx, nby, img) {
    var component = Qt.createComponent("qrc:/gcompris/src/activities/erase/Block.qml");
    var block = component.createObject(
                items.background,
                {
                    "main": main,
                    "bar": items.bar,
                    "ix": ix,
                    "iy": iy,
                    "nbx": nbx,
                    "nby": nby,
                    "opacity": 0.0,
                    "source": img,
                    "type": type
                });

    block.opacity = 1.0
    if (block === null) {
        // Error Handling
        console.log("Error creating object");
    }
    return block;
}

function destroyBlocks() {
    if (createdBlocks) {
        for(var i = 0;  i < createdBlocks.length; ++i) {
            createdBlocks[i].destroy()
        }
        createdBlocks.length = 0
    }
    killedBlocks = 0
}

function blockKilled() {
    if(++killedBlocks === createdBlocks.length) {
        items.bonus.good("flower")
    }
}

function getFirstImage() {
    backgroundImages = Core.shuffle(backgroundImages)
    return backgroundImages[0]
}
