/* GCompris - baby_keyboard.js
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var items;

function start(items_) {
    items = items_;
}

function stop() {
    stopVoice();
}

function processKeyPress(text) {
    items.typedText.text = text.toLocaleUpperCase();
    playLetter(text);
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    var voiceFile = GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter))
    stopVoice();
    if(items.fileId.exists(voiceFile)) {
        items.audioVoices.append(voiceFile);
    } else {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/bleep.wav");
    }
}

function stopVoice() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function playSound() {
    stopVoice();
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/audioclick.wav");
    items.typedText.text = "";
}

function focusTextInput() {
    if (items && items.textinput)
        items.textinput.forceActiveFocus();
}
