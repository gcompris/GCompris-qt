/* GCompris - missing-letter.js
 *
 * Copyright (C) 2014 "Amit Tomar" <a.tomar@outlook.com>
 *
 * Authors:
 *   "Pascal Georges" <pascal.georgis1.free.fr> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var url = "qrc:/gcompris/src/activities/missing-letter/resource/"
var langUrl = "qrc:/gcompris/src/activities/lang/resource/";

var items
var numberOfLevel

var questions
var dataset
var lessons

// Do not propose these letter in the choices
var ignoreLetters = '[ ,;:\\-\u0027]'
var re = new RegExp(ignoreLetters, 'g')

function init(items_) {
    items = items_
}

function start() {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(GCompris.GCompris.VOICES, {"locale": locale})

    dataset = Lang.load(items.parser, langUrl,
                        GCompris.ApplicationSettings.useExternalWordset() ? "words.json" : "words_sample.json",
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
                            GCompris.ApplicationSettings.useExternalWordset() ? "words.json" : "words_sample.json",
                            "content-"+localeShort+ ".json")
    }

    // If still dataset is empty then fallback to english
    if(!dataset) {
        // English fallback
        items.background.englishFallback = true
        dataset = Lang.load(items.parser, langUrl,
                            GCompris.ApplicationSettings.useExternalWordset() ? "words.json" : "words_sample.json",
                            "content-en.json")
    } else {
        items.background.englishFallback = false
    }

    lessons = Lang.getAllLessons(dataset)
    questions = initDataset()
    numberOfLevel = questions.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
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
    for (var i in lesson) {
        var word = lesson[i].translatedTxt.replace(re, '')
        var lettersInCurrentWord;
        if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllUppercase)
            lettersInCurrentWord = word.toLocaleUpperCase().split('')
        else if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllLowercase)
            lettersInCurrentWord = word.toLocaleLowerCase().split('')
        else
            lettersInCurrentWord = word.split('')

        for(var l in lettersInCurrentWord) {
            if(letters.indexOf(lettersInCurrentWord[l]) === -1) {
                letters.push(lettersInCurrentWord[l]);
            }
        }
    }
    return Core.shuffle(GCompris.ApplicationInfo.localeSort(letters, items.locale))
}

// Get a random letter in the given word excluding ignoreLetters
function getRandomLetter(word) {
    var letters = word.replace(re, '').split('')
    var letter = letters[Math.floor(Math.random() * letters.length)]
    if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllUppercase)
        return letter.toLocaleUpperCase()
    else if(GCompris.ApplicationSettings.fontCapitalization === Quick.Font.AllLowercase)
        return letter.toLocaleLowerCase()

    return letter
}

function getRandomMaskedQuestion(clearQuestion, guessLetters, level) {
    var maskedQuestion = clearQuestion
    var goodLetter = getRandomLetter(maskedQuestion)

    // If the word has several occurrences of the letter, choose one at random
    var goodLetterPositions = [];
    for(var i = 0; i < maskedQuestion.length; i++) {
        if (maskedQuestion[i] === goodLetter) {
            goodLetterPositions.push(i);
        }
    }
    var index = goodLetterPositions[Math.floor(Math.random() * goodLetterPositions.length)];

    // Replace the char at index with '_'
    var repl = maskedQuestion.split('')
    repl[index] = '_'
    maskedQuestion = repl.join('')

    // Get some other letter to confuse the children
    var confusingLetters = []
    for(var i = 0; i < Math.min(level + 2, 6); i++) {
        var letter = guessLetters.shift()
        if(confusingLetters.indexOf(letter) === -1 && letter !== goodLetter) {
            confusingLetters.push(letter);
        }
        guessLetters.push(letter)
    }
    confusingLetters.push(goodLetter)

    return [maskedQuestion, goodLetter, Core.shuffle(confusingLetters)]
}

function stop() {
    items.questionAnim.stop();
    items.audioVoices.clearQueue();
}

function initLevel() {
    items.questionAnim.stop()
    items.score.currentSubLevel = 1
    items.score.numberOfSubLevels = questions[items.currentLevel].length
    showQuestion()
}

function getCurrentQuestion() {
    return questions[items.currentLevel][items.score.currentSubLevel - 1]
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextSubLevel() {
    var question = getCurrentQuestion()

    if(items.score.currentSubLevel >= questions[items.currentLevel].length) {
        items.bonus.good('flower')
        return
    }
    items.score.currentSubLevel ++;
    showQuestion()
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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
    items.audioVoices.stop()
    items.audioVoices.clearQueue()
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
