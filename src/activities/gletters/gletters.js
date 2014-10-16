/* GCompris - gletters.js
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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

/* ToDo / open issues:
 * - adjust wordlist filenames once we have an ApplicationInfo.dataPath() or so
 * - make uppercaseOnly be taken from (activity-) settings
 */

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel = 0;
var maxSubLevel = 0;
var items;
var uppercaseOnly;
var mode;
var defaultSubLevel = 8; // min. # of sublevels

//speed calculations, common:
var speed = 0;           // how fast letters fall
var fallSpeed = 0;       // how often new letters are dropped
var incFallSpeed = 1000; // how much drop rate increases per sublevel 
var incSpeed = 10;       // how much speed increases per sublevel
// gletters:
var fallRateBase = 40;   // default for how fast letters fall (smaller is faster)
var fallRateMult = 80;   // default for how much falling speed increases per level (smaller is faster)
var dropRateBase = 5000; // default for how often new letters are dropped
var dropRateMult = 100;  // default for how much drop rate increases per level
// wordsgame:
var wgMaxFallSpeed = 7000;
var wgMaxSpeed = 150;
var wgMinFallSpeed = 3000;
var wgMinSpeed = 50;
var wgDefaultFallSpeed = 8000;
var wgDefaultSpeed = 170;
var wgAddSpeed = 20;
var wgAddFallSpeed = 1000;

var droppedWords;
var currentWord = null;  // reference to the word currently typing, null if n/a
var wordComponent = null;

function start(items_, uppercaseOnly_,  _mode) {
    items = items_;
    uppercaseOnly = uppercaseOnly_;
    mode = _mode;
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = items.wordlist.maxLevel;
    droppedWords = new Array();
    initLevel();
}

function stop() {
    deleteWords();
    wordComponent = null
    items.wordDropTimer.stop();
}

function initLevel() {
    items.bar.level = currentLevel + 1;

    if (currentSubLevel == 0) {
        // initialize level
        deleteWords();
        level = items.wordlist.getLevelWordList(currentLevel + 1);
        maxSubLevel = items.wordlist.getMaxSubLevel(currentLevel + 1);

        if (maxSubLevel == 0) {
            // If level length is not set in wordlist, make sure the level doesn't get too long
            if (mode == "letter") {
                var wordCount = level.words.length;
                wordCount = Math.floor(wordCount / 3 + (currentLevel + 1) / 3);
                maxSubLevel = (defaultSubLevel > wordCount ? defaultSubLevel : wordCount);
            } else
                maxSubLevel = 10 + currentLevel * 5;
        }
        items.score.numberOfSubLevels = maxSubLevel;
        setSpeed();
        /*console.log("Gletters: initializing level " + (currentLevel + 1) 
                + " maxSubLvl=" + maxSubLevel 
                + " wordCount=" + level.words.length
                + " speed=" + speed + " fallspeed=" + fallSpeed);*/
        
        {
            /* populate VirtualKeyboard for mobile:
             * 1. for < 10 letters print them all in the same row
             * 2. for > 10 letters create 3 rows with equal amount of keys per row
             *    if possible, otherwise more keys in the upper rows  */
            // first generate a map of needed letters
            var letters = new Array();
            for (var i = 0; i < level.words.length; i++) {
                for (var j = 0; j < level.words[i].length; j++)
                    if (letters.indexOf(level.words[i].charAt(j)) === -1)
                        letters.push(level.words[i].charAt(j));
            }
            letters.sort();
            // generate layout from letter map
            var layout = new Array();
            var row = 0;
            var offset = 0;
            while (offset < letters.length-1) {
                var cols = letters.length <= 10 ? letters.length : (Math.ceil((letters.length-offset) / (3 - row)));
                layout[row] = new Array();
                for (var j = 0; j < cols; j++)
                    layout[row][j] = { label: letters[j+offset] };
                offset += j;
                row++;
            }
            items.keyboard.layout = layout;
        }
    }
    
    // initialize sublevel
    currentWord = null;
    if (currentSubLevel != 0) {
        // increase speed
        speed = Math.max(speed - incSpeed, wgMinSpeed);
        items.wordDropTimer.interval = fallSpeed = Math.max(fallSpeed - incFallSpeed, wgMinFallSpeed);
    }
    items.score.currentSubLevel = currentSubLevel + 1;
    if (currentSubLevel == 0 || droppedWords.length <= 1)  // note, last word is still fading out
        dropWord();
    //console.log("Gletters: initializing subLevel " + (currentSubLevel + 1) + " words=" + JSON.stringify(level.words));
}

function processKeyPress(text) {
    var typedText = uppercaseOnly ? text.toLocaleUpperCase() : text;
    playLetter(text)

    if (currentWord !== null) {
        // check against a currently typed word
        if (!currentWord.checkMatch(typedText)) {
            currentWord = null;
            return;
        }
    } else {
        // no current word, check against all available words
        for (var i = 0; i< droppedWords.length; i++) {
            if (droppedWords[i].checkMatch(typedText)) {
                // typed correctly
                currentWord = droppedWords[i];
                break;
            }
        }
    }

    if (currentWord !== null && currentWord.isCompleted()) {
        // win!
        currentWord.won();  // note: deleteWord() is triggered after fadeout
        currentWord = null
        nextSubLevel();
    }
}

function setSpeed()
{
    if (mode == "letter") {
        speed = (level.speed !== undefined) ? level.speed : (fallRateBase + Math.floor(fallRateMult / (currentLevel + 1)));
        fallSpeed = (level.fallspeed !== undefined) ? level.fallspeed : Math.floor((dropRateBase + (dropRateMult * (currentLevel + 1))));
    } else { // wordsgame
        speed = (level.speed !== undefined) ? level.speed : wgDefaultSpeed - (currentLevel+1)*wgAddSpeed;
        fallSpeed = (level.fallspeed !== undefined) ? level.fallspeed : wgDefaultFallSpeed - (currentLevel+1)*wgAddFallSpeed

        if(speed < wgMinSpeed ) speed = wgMinSpeed;
        if(speed > wgMaxSpeed ) speed = wgMaxSpeed;
        if(fallSpeed < wgMinFallSpeed ) fallSpeed = wgMinFallSpeed;
        if(fallSpeed > wgMaxFallSpeed ) fallSpeed = wgMaxFallSpeed;
    }
    items.wordDropTimer.interval = fallSpeed;
}

function deleteWords()
{
    if (droppedWords === undefined || droppedWords.length < 1)
        return;
    for (var i = 0; i< droppedWords.length; i++)
        droppedWords[i].destroy();
    droppedWords.length = 0;
}

function deleteWord(w)
{
    if (droppedWords === undefined || droppedWords.length < 1)
        return;
    if (w == currentWord)
        currentWord = null;
    for (var i = 0; i< droppedWords.length; i++)
        if (droppedWords[i] == w) {
            droppedWords[i].destroy();
            droppedWords.splice(i, 1);
            break;
        }
}

function createWord()
{
    if (wordComponent.status == 1 /* Component.Ready */) {
        var text = items.wordlist.getRandomWord(currentLevel + 1);
        // if uppercaseOnly case does not matter otherwise it does
        if (uppercaseOnly)
            text = text.toLocaleUpperCase();

        var word

        if(items.ourActivity.getImage(text)) {
            word = wordComponent.createObject( items.background,
                {
                    "text": text,
                    "image": items.ourActivity.getImage(text),
                    // assume x=width-25px for now, Word auto-adjusts onCompleted():
                    "x": Math.random() * (items.main.width - 25),
                    "y": -25,
                });
        } else if(items.ourActivity.getDominoValues(text)) {
            word = wordComponent.createObject( items.background,
                {
                    "text": text,
                    "dominoValues": items.ourActivity.getDominoValues(text),
                    // assume x=width-25px for now, Word auto-adjusts onCompleted():
                    "x": Math.random() * (items.main.width - 25),
                    "y": -25,
                });
        } else {
            word = wordComponent.createObject( items.background,
                {
                    "text": text,
                    // assume x=width-25px for now, Word auto-adjusts onCompleted():
                    "x": Math.random() * (items.main.width - 25),
                    "y": -25,
                });
        }

        if (word === null)
            console.log("Gletters: Error creating word object");
        else {
            droppedWords[droppedWords.length] = word;
            // speed to duration:
            var duration = (items.main.height / 2) * speed;
            /* console.debug("Gletters: dropping new word " + word.text
                    + " duration=" + duration + " (speed=" + speed + ")"  
                    + " num=" + droppedWords.length);*/
            word.startMoving(duration);
        }
        items.wordDropTimer.restart();
    } else if (wordComponent.status == 3 /* Component.Error */) {
        console.log("Gletters: error creating word component: " + wordComponent.errorString());
    }
}

function dropWord()
{
    if (wordComponent !== null)
        createWord();
    else {
        var text = items.wordlist.getRandomWord(currentLevel + 1);
        var fallingItem
        if(items.ourActivity.getImage(text))
            fallingItem = "FallingImage.qml"
        else if(items.ourActivity.getDominoValues(text).length)
            fallingItem = "FallingDomino.qml"
        else
            fallingItem = "FallingWord.qml"


        wordComponent = Qt.createComponent("qrc:/gcompris/src/activities/gletters/" + fallingItem);
        if (wordComponent.status == 1 /* Component.Ready */)
            createWord();
        else if (wordComponent.status == 3 /* Component.Error */) {
            console.log("Gletters: error creating word component: " + wordComponent.errorString());
        } else
            wordComponent.statusChanged.connect(createWord);
    }
}

function audioCrashPlay() {
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
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
        currentSubLevel = 0
        items.bonus.good("lion");
    } else
        initLevel();
}

function playLetter(letter) {
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter)))
}
