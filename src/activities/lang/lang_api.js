/* GCompris - lang_api.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net)
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
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var contentText

function validateDataset(levels)
{
    return true;
}

function load(parser, baseUrl, datasetFilename, translationFilename) {

    var datasetUrl = baseUrl + "/" + datasetFilename;
    var dataset = parser.parseFromUrl(datasetUrl, validateDataset);
    if (dataset === null) {
        console.error("Lang: Invalid dataset, can't continue: "
                      + datasetUrl);
        return;
    }
    dataset['contentText'] = loadContent(parser,
                                         GCompris.ApplicationInfo.getLocaleFilePath(baseUrl + "/" + translationFilename))

    if(!dataset['contentText']) {
        return null
    }

    return dataset
}

function loadContent(parser, datasetUrl) {

    var dataset = parser.parseFromUrl(datasetUrl, validateDataset);
    if (dataset === null) {
        console.error("Lang: Invalid dataset, can't continue: "
                      + datasetUrl);
        return;
    }
    return dataset
}

function getChapter(dataset, chapter) {
    return dataset[chapter]
}

// Return a datamodel for the chapter suitable for creating a chapter selector
function getChapterModel(dataset) {
    var chapters = []
    for (var c = 0; c < dataset.length; c++) {
        chapters.push(
                    {'name': dataset[c].name,
                        'image': dataset[c].content[0].content[0].image,
                        'index': c
                    })
    }
    return chapters
}

function getLesson(dataset, chapter, lesson) {
    return chapter.content[lesson]
}

function getAllLessons(dataset) {
    var lessons = []
    for (var c in dataset) {
        for (var l in dataset[c].content) {
            var lesson = getLesson(dataset, dataset[c], l)
            lessons.push(lesson)
        }
    }
    return lessons
}

function getLessonWords(dataset, lesson) {
    var wordList = lesson.content
    // Fill up the lesson with the translated text
    var allWords = []
    for (var k in wordList) {
        var word = wordList[k]
        word['translatedTxt'] = getTextByAudio(dataset.contentText,
                                               word.description)
        if(word['translatedTxt'])
            allWords.push(word)
    }
    return allWords
}

function getTextByAudio(contentText, audio) {
    audio += ".ogg"
    return contentText[audio]
}

// Return a datamodel for the lessons for creating menu
function getMenuModel(dataset, items) {
    var menus = []
    var levelCount = 0  //used for creating a straight indexing of levels
    var prevLevelcount = 0
    for (var c in dataset) {
        for (var l in dataset[c].content) {

            levelCount = parseInt(l) + prevLevelcount
            var currentLesson = getLesson(dataset, dataset[c], l)
            var tempWordList = getLessonWords(dataset, currentLesson);
            var modifiedWordCount = tempWordList.length

            for (var m in tempWordList) {
                // if voice is disabled then it doesn't affect maximum
                if(!items.checkWordExistence (tempWordList[m]) ) {
                    --modifiedWordCount
                }
            }

            menus.push(
                        { 'name' : currentLesson.name,
                          'image': currentLesson.content[0].image,
                          'index': levelCount,
                          'wordCount': tempWordList.length * 4 + modifiedWordCount,
                           'savedProgress': 0
                        })
        }
        prevLevelcount = levelCount+ 1
    }
    return menus
}
