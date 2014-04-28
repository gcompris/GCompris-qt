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
 * - Android
 * - adjust wordlist filenames once we have an ApplicationInfo.dataPath() or so
 * - make uppercaseOnly be taken from (activity-) settings
 */

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo

var url = "qrc:/gcompris/src/activities/gletters/resource/"

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel = 0;
var maxSubLevel = 0;
var items;
var uppercaseOnly;
var defaultSubLevel = 8;  // min. # of sublevels
var speed = 0;           // how fast letters fall
var fallRateBase = 40;   // default for how fast letters fall (smaller is faster)
var fallRateMult = 80;   // default for how much falling speed increases per level (smaller is faster)
var fallSpeed = 0;       // how often new letters are dropped
var dropRateBase = 5000; // default for how often new letters are dropped
var dropRateMult = 100;  // default for how much drop rate increases per level
var droppedWords;
var wordComponent = null;

function start(items_, uppercaseOnly_) {
    console.log("Gletters activity: start");
    
    items = items_;
    uppercaseOnly = uppercaseOnly_;
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = items.wordlist.maxLevel;
    droppedWords = new Array();
    initLevel();
}

function stop() {
    console.log("Gletters activity: stop");
    deleteWords();
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
            var wordCount = level.words.length;
            wordCount = Math.floor(wordCount / 3 + (currentLevel + 1) / 3);
            maxSubLevel = (defaultSubLevel > wordCount ? defaultSubLevel : wordCount);
        }
        items.score.numberOfSubLevels = maxSubLevel;
        setSpeed();
        /*console.log("Gletters: initializing level " + (currentLevel + 1) 
                + " maxSubLvl=" + maxSubLevel 
                + " wordCount=" + level.words.length
                + " speed=" + speed + " fallspeed=" + fallSpeed); */
        
        if (GCompris.ApplicationInfo.isMobile) 
        {
            /* populate VirtualKeyboard for mobile:
             * 1. for < 10 letters print them all in the same row
             * 2. for > 10 letters create 3 rows with equal amount of keys per row
             *    if possible, otherwise more keys in the upper rows
             */
            var layout = new Array();
            var row = 0;
            var offset = 0;
            while (offset < level.words.length-1) {
                var cols = level.words.length <= 10 ? level.words.length : (Math.ceil((level.words.length-offset) / (3 - row)));
                layout[row] = new Array();
                for (var j = 0; j < cols; j++)
                    layout[row][j] = { label: level.words[j+offset] };
                offset += j;
                row++;
            }
            items.keyboard.layout = layout;
        }
    }
    
    // initialize sublevel
    items.score.currentSubLevel = currentSubLevel + 1;
    dropWord();
    //console.log("Gletters: initializing subLevel " + (currentSubLevel + 1) + " words=" + JSON.stringify(level.words));
}

function processKeyPress(text) {
    for (var i = 0; i< droppedWords.length; i++) {
        var chars = droppedWords[i].text.split("");
        var typedText = uppercaseOnly ? text.toLocaleUpperCase() : text;
        if (chars[droppedWords[i].unmatchedIndex] == typedText) {
            // typed correctly
            droppedWords[i].nextCharMatched();
            if (droppedWords[i].isCompleted()) {
                // win!
                items.flipAudio.play();
                droppedWords[i].won();
                droppedWords.splice(i, 1);
                nextSubLevel();
            }
            break;
        }
    }
}

function setSpeed()
{
    speed = (level.speed !== undefined) ? level.speed : (fallRateBase + Math.floor(fallRateMult / (currentLevel + 1)));
    fallSpeed = (level.fallspeed !== undefined) ? level.fallspeed : Math.floor((dropRateBase + (dropRateMult * (currentLevel + 1))));
    items.wordDropTimer.interval=fallSpeed;
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
        var word = wordComponent.createObject( items.background, 
                {
                    "text": text,
                    "x": Math.random() * (items.main.width - 25), // FIXME: 25? 
                    "y": -25,  // FIXME: -25?
                });
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
        wordComponent = Qt.createComponent("qrc:/gcompris/src/activities/gletters/Word.qml");
        if (wordComponent.status == 1 /* Component.Ready */)
            createWord();
        else if (wordComponent.status == 3 /* Component.Error */) {
            console.log("Gletters: error creating word component: " + wordComponent.errorString());
        } else
            wordComponent.statusChanged.connect(createWord);
    }
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
