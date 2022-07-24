/* GCompris - hangman.js
 *
 *   SPDX-FileCopyrightText: 2015 Rajdeep Kaur <rajdeep1994@gmail.com>
 *
 *    Authors:
 *    Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *    Rajdeep kaur <rajdeep51994@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var currentLevel
var currentSubLevel
var maxLevel
var maxSubLevel
var items

var currentWord
var separator = "_"
var dataset = null
var lessons
var wordList
var subLevelsLeft
var alreadyTypedLetters

var charsToAlwaysShow=RegExp("[ !-#%-*,-/\:;?@_\{\}\u00A1\u00A7\u00AB\u00B6\u00B7\u00BB\u00BF\u037E\u0387\u055A-\u055F\u0589\u058A\u05B0-\u05C1\u05C0\u05C3\u05C6\u05F3\u05F4\u0609\u060A\u060C\u060D\u061B\u061E\u061F\u066A-\u066D\u06D4\u0700-\u070D\u07F7-\u07F9\u0830-\u083E\u085E\u0964\u0965\u0970\u0AF0\u0DF4\u0E4F\u0E5A\u0E5B\u0F04-\u0F12\u0F14\u0F3A-\u0F3D\u0F85\u0FD0-\u0FD4\u0FD9\u0FDA\u104A-\u104F\u10FB\u1360-\u1368\u1400\u166D\u166E\u169B\u169C\u16EB-\u16ED\u1735\u1736\u17D4-\u17D6\u17D8-\u17DA\u1800-\u180A\u1944\u1945\u1A1E\u1A1F\u1AA0-\u1AA6\u1AA8-\u1AAD\u1B5A-\u1B60\u1BFC-\u1BFF\u1C3B-\u1C3F\u1C7E\u1C7F\u1CC0-\u1CC7\u1CD3\u2010-\u2027\u2030-\u2043\u2045-\u2051\u2053-\u205E\u207D\u207E\u208D\u208E\u2308-\u230B\u2329\u232A\u2768-\u2775\u27C5\u27C6\u27E6-\u27EF\u2983-\u2998\u29D8-\u29DB\u29FC\u29FD\u2CF9-\u2CFC\u2CFE\u2CFF\u2D70\u2E00-\u2E2E\u2E30-\u2E42\u3001-\u3003\u3008-\u3011\u3014-\u301F\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF\uA60D-\uA60F\uA673\uA67E\uA6F2-\uA6F7\uA874-\uA877\uA8CE\uA8CF\uA8F8-\uA8FA\uA8FC\uA92E\uA92F\uA95F\uA9C1-\uA9CD\uA9DE\uA9DF\uAA5C-\uAA5F\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F\uFE10-\uFE19\uFE30-\uFE52\uFE54-\uFE61\uFE63\uFE68\uFE6A\uFE6B\uFF01-\uFF03\uFF05-\uFF0A\uFF0C-\uFF0F\uFF1A\uFF1B\uFF1F\uFF20\uFF3B-\uFF3D\uFF3F\uFF5B\uFF5D\uFF5F-\uFF65]");

// js strings are immutable, can't replace letter like that...
// http://stackoverflow.com/questions/1431094/how-do-i-replace-a-character-at-a-particular-index-in-javascript
String.prototype.replaceAt = function(index, character) {
    return this.substr(0, index) + character + this.substr(index+character.length);
}

function start(items_) {
    items = items_
    currentLevel = 0;
    currentSubLevel = 0;
    items.remainingLife = 6;

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    var resourceUrl = "qrc:/gcompris/src/activities/lang/resource/"

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(
                GCompris.DownloadManager.getVoicesResourceForLocale(locale))

    var data = Lang.loadDataset(items.parser, resourceUrl, locale);
    dataset = data["dataset"];
    items.background.englishFallback = data["englishFallback"];
    lessons = Lang.getAllLessons(dataset)
    maxLevel = lessons.length
    initLevel();
}

function stop() {
    items.winTimer.stop();
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    var currentLesson = lessons[currentLevel];
    wordList = Lang.getLessonWords(dataset, currentLesson);
    Core.shuffle(wordList);

    maxSubLevel = wordList.length;
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.visible = true;

    subLevelsLeft = []
    for(var i in wordList)
        subLevelsLeft.push(i)

    initSubLevel();

    //to set the layout...populate
    var letters = new Array();
    for (var i = 0; i < wordList.length; i++) {
        var word = wordList[i].translatedTxt;
        for (var j = 0; j < word.length; j++) {
            var letter = word.charAt(j).toLocaleLowerCase();
            if (letters.indexOf(letter) === -1 && !charsToAlwaysShow.test(letter))
                letters.push(letter);
        }
    }
    letters = GCompris.ApplicationInfo.localeSort(letters, items.locale);

    // generate layout from letter map
    var layout = new Array();
    var row = 0;
    var offset = 0;
    while (offset < letters.length-1) {
        var cols = letters.length <= 10
                ? letters.length : (Math.ceil((letters.length-offset) / (3 - row)));
        layout[row] = new Array();
        for (var j = 0; j < cols; j++)
            layout[row][j] = { label: letters[j+offset] };
        offset += j;
        row++;
    }
    items.keyboard.layout = layout;
}

function processKeyPress(text) {
    if(items.remainingLife === 0 || items.goodIcon.visible) {
        return
    }

    text = text.toLocaleLowerCase()

    // Check if the character has already been typed
    if(alreadyTypedLetters.indexOf(text) !== -1) {
        // Character already typed, do nothing
        return;
    }
    // Add the character to the already typed characters
    alreadyTypedLetters.push(text);

    // add the typed character in the "Attempted characters" text field
    createAttemptedText()

    // Get all the indices of this letter in the word
    var indices = [];
    for(var i = 0 ; i < currentWord.length ; i ++) {
        if (currentWord[i].toLocaleLowerCase() === text) {
            indices.push(i);
        }
    }

    if(indices.length == 0) {
        // The letter is not in the word to find
        // If no more life, we display the good word and show the bonus
        if(--items.remainingLife == 0) {
            items.hidden.text = items.goodWord.translatedTxt;
            items.playWord()
            items.bonus.bad("lion");
            return;
        }
    } else {
        var text = items.hidden.text
        // For all the indices found, we replace the "_" by the letter
        for(var index = 0 ; index < indices.length ; index ++) {
            text = text.replaceAt(indices[index],
                                  currentWord[indices[index]]);
        }

        items.hidden.text = text
    }

    // If no more '_' in the word to find, we have found all letters, show bonus
    if(items.hidden.text.indexOf(separator) === -1) {
        items.maskThreshold = 0;
        items.playWord();
        items.hidden.text = items.goodWord.translatedTxt;
        items.goodIcon.visible = true
        items.winTimer.start();
    }
}

function nextLevel() {
    if(maxLevel <= ++currentLevel) {
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

function initSubLevel() {
    // initialize sublevel
    if(items.score.currentSubLevel < items.score.numberOfSubLevels)
        items.score.currentSubLevel = currentSubLevel + 1;
    else
        items.score.visible = false
    items.goodWordIndex = subLevelsLeft.pop()
    items.ok.visible = false
    items.goodIcon.visible = false
    items.goodWord = wordList[items.goodWordIndex]
    items.wordImage.changeSource(items.goodWord.image);
    items.remainingLife = 6;
    alreadyTypedLetters = new Array();
    currentWord = items.goodWord.translatedTxt;
    createAttemptedText()

    var search = RegExp(charsToAlwaysShow);
    var text = "";
    for(var i = 0; i < currentWord.length ; ++ i) {
        var charDisplayed = separator;
        if(charsToAlwaysShow.test(currentWord[i])) {
            charDisplayed = currentWord[i];
        }
        text = text + charDisplayed;
    }
    items.hidden.text = text;
}

function createAttemptedText() {
    alreadyTypedLetters.sort()
    items.guessedText.text = qsTr("Attempted: %1").arg(alreadyTypedLetters.join(", "))
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0;
        nextLevel();
    } else {
        initSubLevel();
    }
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
