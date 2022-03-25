/* GCompris - baby_keyboard.js
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
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
