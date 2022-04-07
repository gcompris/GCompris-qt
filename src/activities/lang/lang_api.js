/* GCompris - lang_api.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
    applyImgPrefix(dataset)

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

/* return a list of words in the lesson. Each words is formatted like:
 * 'description' => "splatter"
 * 'image' => "words/splatter.webp"
 * 'voice' => "voices-$CA/$LOCALE/words/splatter.$CA"
 * 'translatedTxt' => "splatter"
 */
function getLessonWords(dataset, lesson) {
    var wordList = lesson.content
    // Fill up the lesson with the translated text
    var allWords = []
    for (var k in wordList) {
        var word = wordList[k]
        word['translatedTxt'] = dataset.contentText[
                    word.voice.substr(word.voice.lastIndexOf("/")+1).replace("$CA", "ogg")];
        if(word['translatedTxt'])
            allWords.push(word)
    }
    return allWords
}

/* Apply the imgPrefix of the chapter to the whole image set
 */
function applyImgPrefix(dataset) {
    for (var c = 0; c < dataset.length; c++) {
        if(!dataset[c].imgPrefix)
            break
        for (var l in dataset[c].content) {
            for (var k in dataset[c].content[l].content) {
                dataset[c].content[l].content[k].image = dataset[c].imgPrefix + dataset[c].content[l].content[k].image
            }
        }
    }
}

/**
 * Helper to load a dataset
 */
function loadDataset(parser, resourceUrl, locale) {
    var wordset = GCompris.ApplicationSettings.useExternalWordset() ? "words.json" : "words_sample.json";

    var dataset = load(parser, resourceUrl, wordset,
                        "content-"+ locale +".json")
    var englishFallback = false

    // If dataset is empty, we try to load from short locale
    // and if not present again, we switch to default one
    var localeUnderscoreIndex = locale.indexOf('_')
    if(!dataset) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex)
        } else {
            localeShort = locale;
        }
        dataset = load(parser, resourceUrl, wordset,
                            "content-"+localeShort+ ".json")
    }

    // If still dataset is empty then fallback to english
    if(!dataset) {
        // English fallback
        englishFallback = true
        dataset = load(parser, resourceUrl, wordset, "content-en.json")
    }
    return {"dataset": dataset, "englishFallback": englishFallback};
}
