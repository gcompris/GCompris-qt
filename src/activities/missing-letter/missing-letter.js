/* GCompris - missing-letter.js
 *
 * Copyright (C) 2014 "Amit Tomar" <a.tomar@outlook.com>
 *
 * Authors:
 *   "Pascal Georges" <pascal.georgis1.free.fr> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
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
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var url = "qrc:/gcompris/src/activities/missing-letter/resource/"
var langUrl = "qrc:/gcompris/src/activities/lang/resource/";

var items
var currentLevel
var numberOfLevel

var questions
var dataset
var lessons

// Do not propose these letter in the choices
var ignoreLetters = '[ ,;:\\-\u0027]'

function init(items_) {
    items = items_
}

function start() {
    currentLevel = 0

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(GCompris.DownloadManager.getVoicesResourceForLocale(locale))

    dataset = Lang.load(items.parser, langUrl,
                        GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                        "content-"+ locale +".json")

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
        dataset = Lang.load(items.parser, langUrl,
                            GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                            "content-"+localeShort+ ".json")
    }

    // If still dataset is empty then fallback to english
    if(!dataset) {
        // English fallback
        items.background.englishFallback = true
        dataset = Lang.load(items.parser, langUrl,
                            GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                            "content-en.json")
    } else {
        items.background.englishFallback = false
    }

    lessons = Lang.getAllLessons(dataset)
    questions = initDataset()
    numberOfLevel = questions.length
    initLevel()
}

function initDataset() {
    var questions = []
    for (var lessonIndex = 0; lessonIndex < lessons.length; lessonIndex++) {
        var lesson = Lang.getLessonWords(dataset, lessons[lessonIndex])
        var guessLetters = getRandomLetters(lesson)
        questions[lessonIndex] = []
        for (var j in lesson) {
            var clearQuestion = lesson[j].translatedTxt
            if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllUppercase)
                clearQuestion = clearQuestion.toLocaleUpperCase()
            else if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllLowercase)
                clearQuestion = clearQuestion.toLocaleLowerCase()

            var maskedQuestion = getRandomMaskedQuestion(clearQuestion, guessLetters, lessonIndex)

            questions[lessonIndex].push(
                        {
                            'image': lesson[j].image,
                            'clearQuestion': clearQuestion,
                            'maskedQuestion': maskedQuestion[0],
                            'answer': maskedQuestion[1],
                            'choices': maskedQuestion[2],
                            'voice': lesson[j].voice,
                        })
        }
    }
    return questions
}

// Get all the letters for all the words in the lesson excluding ignoreLetters
function getRandomLetters(lesson) {
    var letters = []
    var re = new RegExp(ignoreLetters, 'g');
    for (var i in lesson) {
        if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllUppercase)
            letters = letters.concat(lesson[i].translatedTxt.replace(re, '').toLocaleUpperCase().split(''))
        else if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllLowercase)
            letters = letters.concat(lesson[i].translatedTxt.replace(re, '').toLocaleLowerCase().split(''))
        else
            letters = letters.concat(lesson[i].translatedTxt.replace(re, '').split(''))
    }
    return sortUnique(letters)
}

// Get a random letter in the given word excluding ignoreLetters
function getRandomLetter(word) {
    var re = new RegExp(ignoreLetters, 'g')
    var letters = word.replace(re, '').split('')
    var letter = Core.shuffle(letters)[0]
    if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllUppercase)
        return letter.toLocaleUpperCase()
    else if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllLowercase)
        return letter.toLocaleLowerCase()

    return letter
}

function getRandomMaskedQuestion(clearQuestion, guessLetters, level) {
    var maskedQuestion = clearQuestion
    var goodLetter = getRandomLetter(maskedQuestion)
    var index = maskedQuestion.search(goodLetter)

    // Replace the char at index with '_'
    var repl = maskedQuestion.split('')
    repl[index] = '_'
    maskedQuestion = repl.join('')

    // Get some other letter to confuse the children
    var confusingLetters = []
    for(var i = 0; i < Math.min(level + 2, 6); i++) {
        var letter = guessLetters.shift()
        confusingLetters.push(letter)
        guessLetters.push(letter)
    }
    confusingLetters.push(goodLetter)

    return [maskedQuestion, goodLetter, Core.shuffle(sortUnique(confusingLetters))]
}

function sortUnique(arr) {
    arr = GCompris.ApplicationInfo.localeSort(arr, items.locale);
    var ret = [arr[0]];
    for (var i = 1; i < arr.length; i++) { // start loop at 1 as element 0 can never be a duplicate
        if (arr[i-1] !== arr[i]) {
            ret.push(arr[i]);
        }
    }
    return ret;
}
function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.score.currentSubLevel = 1
    items.score.numberOfSubLevels = questions[currentLevel].length
    showQuestion()
}

function getCurrentQuestion() {
    return questions[currentLevel][items.score.currentSubLevel - 1]
}

function showQuestion() {
    var question = getCurrentQuestion()

    playWord(question.voice)
    items.answer = question.answer
    items.answers.model = question.choices
    items.questionText.text = question.maskedQuestion
    items.questionImage.source = question.image
    items.isGoodAnswer = false
    items.buttonsBlocked = false
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function nextSubLevel() {
    var question = getCurrentQuestion()

    if(items.score.currentSubLevel >= questions[currentLevel].length) {
        items.bonus.good('flower')
        return
    }
    items.score.currentSubLevel ++;
    showQuestion()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function showAnswer() {
    var question = getCurrentQuestion()
    playLetter(question.answer)
    items.isGoodAnswer = true
    items.questionText.text = question.clearQuestion
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/" +
                             Core.getSoundFilenamForChar(letter)))
}

function playCurrentWord() {
    var question = getCurrentQuestion()
    playWord(question.voice)
}

function playWord(word) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    var wordLocalized = word.replace("$LOCALE", locale)
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath(wordLocalized))
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
