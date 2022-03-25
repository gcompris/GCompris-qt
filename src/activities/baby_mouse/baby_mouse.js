/* GCompris - baby_mouse.js
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick

var items;
var duckImages = ["pink_duck", "green_duck", "yellow_duck", "orange_duck"];
var clickSounds = ["bleep", "smudge", "flip", "completetask", "scroll"];

var audioURL = "qrc:/gcompris/src/core/resource/sounds/";
var arrowImageURL = "qrc:/gcompris/src/activities/baby_mouse/resource/arrow.svg";
var duckColorURL = "qrc:/gcompris/src/activities/colors/resource/";

function start(items_) {
    items = items_;
    initLevel();
}

function stop() {
}

function initLevel() {
    for(var i = 0; i < duckImages.length; i++) {
        items.duckModel.append({"image" : duckImages[i]});
    }
}

function playSound(index) {
    items.audioEffects.play(audioURL + clickSounds[index] + '.wav');
}
