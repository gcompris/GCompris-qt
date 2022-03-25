/* GCompris - baby_wordprocessor.js
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
    focusTextInput();
}

function stop() {
    stopVoice();
}

function focusTextInput() {
    if (items && items.edit)
        items.edit.forceActiveFocus();
}

function playLetter(letter) {
    if (!items.audioMode) {
        return;
    }

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    var voiceFile = GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter))
    stopVoice();
    if(items.fileId.exists(voiceFile)) {
        items.audioVoices.append(voiceFile);
    }
}

function stopVoice() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}
