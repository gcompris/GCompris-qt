/* GCompris - hangman.js
 *
 *   Copyright (C) 2014 <RAJDEEP KAUR>
 *
 *    Authors:
 *    Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *    Rajdeep kaur <rajdeep51994@gmail.com> (Qt Quick port)
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


var currentLevel 
var currentSubLevel 
var wordlength 
var maxLevel 
var maxSubLevel
var level = null;
var sublevel 
var numberOfLevel 
var items
var win 

var noOfLife;

var countNoAlphabet;
var currentWord;
var wordi = new Array();
var component;
var sp ="_ ";
var baseUrl = "qrc:/gcompris/src/activities/hangman/resource/"
var dataset = null;
var lessons 
var wordList
var subLevelsLeft


function start(items_) {
    items = items_
    currentLevel = 0;
    currentSubLevel = 0;
    noOfLife = 6;
    
    dataset = Lang.load(items.parser, baseUrl, "words.json", "content-$LOCALE.json")
    if(!dataset) {
        // English fallback
        items.background.englishFallback = true
        dataset = Lang.load(items.parser, baseUrl, "words.json", "content-en.json")
    } else {
        items.background.englishFallback = false
    }
    
    lessons = Lang.getAllLessons(dataset)
    maxLevel = lessons.length
    initLevel();
    
}

function stop() {
}



    function initLevel() {
        items.bar.level = currentLevel + 1;
        var currentLesson = lessons[currentLevel]
        wordList = Lang.getLessonWords(dataset, currentLesson);
        Core.shuffle(wordList);
       
        maxSubLevel = wordList.length;
        items.score.numberOfSubLevels = maxSubLevel;
        items.score.visible = true;
       
        subLevelsLeft = []
        for(var i in wordList)
            subLevelsLeft.push(i)
       
        console.log(level+"france");
        initSubLevel();
        {   //to set the layout...populate
            var letters = new Array();
            items.keyboard.shiftKey = false;
            for (var i = 0; i < wordList.length; i++) {
                var currentWord = wordList[i].translatedTxt;
                for (var j = 0; j < currentWord.length; j++) {
                    var letter = currentWord.charAt(j);
                    var isUpper = (letter == letter.toLocaleUpperCase());
                    if (isUpper && letters.indexOf(letter.toLocaleLowerCase()) !== -1)
                        items.keyboard.shiftKey = true;
                    else if (!isUpper && letters.indexOf(letter.toLocaleUpperCase()) !== -1)
                        items.keyboard.shiftKey = true;
                    else if (letters.indexOf(letter) === -1)
                        letters.push(currentWord.charAt(j));
                }
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
           
        }
        items.keyboard.layout = layout;
       
    }



function processKeyPress(text) {
    console.log(text+"idiot");
    var flag = 0;
    var inital = wordi;
    console.log(inital);
    wordi = "";
    for(var i = 0; i< currentWord.length ; i++) {
        if(currentWord[i] === text) {
            flag=1;
            countNoAlphabet +=1;
            if(i === 0){
                wordi=wordi+currentWord.charAt(0);
                for(var j = 1; j <inital.length ; j = j+1)
                {	wordi = wordi+inital.charAt(j);
                }
            }
            else{
                var j=i*2;
                for(var k=0;k<inital.length;k=k+1)
                {	   if(j === k)
                    {	wordi = wordi+currentWord.charAt(i);
                    }
                    else
                    {	wordi = wordi+inital.charAt(k);
                    }
                }
            }
        }

    }
    if(flag !== 1)
    {	wordi = inital;
        noOfLife=noOfLife-1;
    }
    items.hidden.text = wordi
    if(countNoAlphabet === (currentWord.length))
    {	items.ping_animation.running = true
        items.bonus.good("lion");
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function initSubLevel()
{	if(items.score.currentSubLevel < items.score.numberOfSubLevels)
        items.score.currentSubLevel = currentSubLevel + 1;
    else
        items.score.visible = false
    items.goodWordIndex = subLevelsLeft.pop()
    items.goodWord = wordList[items.goodWordIndex]
    var text1 = items.goodWord.translatedTxt;
    items.wordImage.changeSource("qrc:/gcompris/data/" + items.goodWord.image);
    win=0;
    wordi = new Array();
    currentWord = text1 ;
    countNoAlphabet = 0;
    console.log(currentWord);
    for(var i = 0; i < currentWord.length ; i=i+1)
    {   if(i == 0)
        {	wordi.push("_ ");   }
        else
        {	wordi = wordi + sp;
        }
    }
    console.log(wordi);
    items.hidden.text=wordi;
}

function nextSublevel()
{	if(maxsublevel<= ++currentSubLevel)
        {		currentSubLevel=1;	}
        initSubLevel();
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items)
        items.textinput.forceActiveFocus();
}
