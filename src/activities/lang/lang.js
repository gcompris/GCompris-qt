/* GCompris - lang.js
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
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
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var lessonModelIndex = 0;
var currentSubLevel = 0;
var items;
var baseUrl = "qrc:/gcompris/src/activities/lang/resource/";
var dataset
var lessons
var maxWordInLesson = 12

function init(items_) {
    items = items_
    lessonModelIndex = 0
    currentSubLevel = 0
}

function start() {
    lessonModelIndex = 0;
    currentSubLevel = 0;
    items.imageReview.stop()

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(GCompris.DownloadManager.getVoicesResourceForLocale(locale))

    var data = Lang.loadDataset(items.parser, baseUrl, locale);
    dataset = data["dataset"];
    items.background.englishFallback = data["englishFallback"];

    // We have to keep it because we can't access content from the model
    lessons = Lang.getAllLessons(dataset)
    addPropertiesToLessons(lessons)

    items.menuModel.clear()
    items.menuModel.append(lessons)
    savedPropertiesToLessons(items.dialogActivityConfig.dataToSave)
    sortByFavorites();

    items.menuScreen.start()
}

// Insert our specific properties in the lessons
function addPropertiesToLessons(lessons) {
    for (var i in lessons) {
        // Ceil the wordCount to a maxWordInLesson count
        lessons[i]['wordCount'] =
                Math.ceil(Lang.getLessonWords(dataset, lessons[i]).length / maxWordInLesson)
                * maxWordInLesson
        lessons[i]['image'] = lessons[i].content[0].image
        lessons[i]['progress'] = 0
        lessons[i]['favorite'] = false
        // We need to keep a back reference from the model to the lessons array
        lessons[i]['lessonIndex'] = i
    }
}

// Return a new json that contains all the properties we have to save
function lessonsToSavedProperties() {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    var props = {}
    for(var i = 0; i < items.menuModel.count; i++) {
        var lesson = items.menuModel.get(i)
        props[lesson.name] = {
            'favorite': lesson['favorite'],
            'progress': lesson['progress']
        }
    }
    return props
}

// Update the lessons based on a previous saving
function savedPropertiesToLessons(dataToSave) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    var props = dataToSave[locale]
    for(var i = 0; i < items.menuModel.count; i++) {
        var lesson = items.menuModel.get(i)
        if(props && props[lesson.name]) {
            lesson['favorite'] = props[lesson.name].favorite
            lesson['progress'] = props[lesson.name].progress
        } else {
            lesson['favorite'] = false
            lesson['progress'] = 0
        }
    }
}

function stop() {
}

function initLevel(lessonModelIndex_) {
    lessonModelIndex = lessonModelIndex_
    var lessonIndex = items.menuModel.get(lessonModelIndex).lessonIndex

    var flatWordList = Lang.getLessonWords(dataset, lessons[lessonIndex]);
    // We have to split the works in chunks of maxWordInLesson
    items.wordList = []
    var i = 0
    while(flatWordList.length > 0) {
        items.wordList[i++] = Core.shuffle(flatWordList.splice(0, maxWordInLesson));
    }
    // If needed complete the last set to have maxWordInLesson items in it
    // We pick extra items from the head of the list
    if(items.wordList[i-1].length != maxWordInLesson) {
        var flatWordList = Lang.getLessonWords(dataset, lessons[lessonIndex]);
        var lastLength = items.wordList[i-1].length
        items.wordList[i-1] =
                items.wordList[i-1].concat(flatWordList.splice(0, maxWordInLesson - lastLength))
    }

    items.imageReview.category = items.categoriesTranslations[lessons[lessonIndex].name] //lessons[lessonIndex].name

    // Calc the sublevel to start with
    var subLevel = Math.floor(items.menuModel.get(lessonModelIndex)['progress'] / maxWordInLesson)
    if(subLevel >= items.wordList.length)
        // Level done, start again at level 0
        subLevel = 0

    items.menuScreen.stop()
    items.imageReview.initLevel(subLevel)
}

function launchMenuScreen() {
    items.imageReview.stop()
    items.menuScreen.start()
}

function sortByFavorites() {
    for(var i = 0; i < items.menuModel.count; i++) {
        if(items.menuModel.get(i)['favorite'])
            items.menuModel.move(i, 0, 1);
    }
}

function markProgress() {
    // We count progress as a number of image learnt from the lesson start
    items.menuModel.get(lessonModelIndex)['progress'] += maxWordInLesson
}

function playWord(word) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    return items.audioVoices.append(
                GCompris.ApplicationInfo.getAudioFilePathForLocale(word, locale))
}

function clearVoiceQueue() {
    items.audioVoices.clearQueue()
}
