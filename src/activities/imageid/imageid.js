/* GCompris - imageid.js
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/imageid/lang_api.js" as Lang

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel;
var maxSubLevel;
var items;
var baseUrl = "qrc:/gcompris/src/activities/imageid/resource/";
var dataset = null;
var lessons
var goodWord

function init(items_) {
    items = items_;
    maxLevel = 0
    maxSubLevel = 0
    currentLevel = 0
    currentSubLevel = 0
}

function start() {
    currentLevel = 0;
    currentSubLevel = 0;

    dataset = Lang.load(items.parser, baseUrl + "words.json")
    lessons = Lang.getAllLessons(dataset)
    maxLevel = lessons.length

    initLevel();
}

function stop() {
}

function getCorrectAnswer()
{
    return goodWord.translatedTxt
}

function initLevel() {
    items.bar.level = currentLevel + 1;

    var currentLesson = lessons[currentLevel]
    var wordList = Lang.getLessonWords(dataset, currentLesson)

    maxSubLevel = wordList.length;
    items.score.numberOfSubLevels = maxSubLevel;

    // initialize sublevel
    items.score.currentSubLevel = currentSubLevel + 1;
    goodWord = wordList[currentSubLevel]

//    Core.shuffle(allWords);
    var selectedWords = []
    selectedWords.push(goodWord.translatedTxt)
    for (var i = 0; i < wordList.length; i++) {
        if(wordList[i].translatedTxt !== selectedWords[0])
            selectedWords.push(wordList[i].translatedTxt)

        if(selectedWords.length > 4)
            break
    }
    // Push the result in the model
    items.wordListModel.clear();
    Core.shuffle(selectedWords);
    for (var j = 0; j < selectedWords.length; j++) {
        items.wordListModel.append({"word": selectedWords[j] })
    }
    items.wordImage.source = "qrc:/" + goodWord.image;
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath(goodWord.voice))

}

function nextLevel() {
    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0;
        nextLevel();
    } else
        initLevel();
}
