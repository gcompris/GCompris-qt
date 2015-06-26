/* GCompris - hangman.js
 *
 * Copyright (C) 2014 <RAJDEEP KAUR>
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
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel=1;
var currentSublevel=1;
var wordlength=0;
var maxLevel = 0;
var maxsublevel=0;
var level = 1;
var sublevel = 0;
var numberOfLevel=5;
var items;
var win=0;

var no_of_life ;

var count_no_alphabet;
var current_word;
var wordi = new Array();
var component;
var sp ="_ ";
var url = "qrc:/gcompris/src/activities/hangman/resource/"


function start(items_) {
    items = items_
    currentLevel = 1;
    currentSublevel = 1;
    no_of_life = 6;
    
     var locale = items.locale == "system" ? "$LOCALE" : items.locale
     items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
            items.ourActivity.dataSetUrl + "default-"+locale+".json"));
     // If wordlist is empty, we try to load from short locale and if not present again, we switch to default one
     var localeUnderscoreIndex = locale.indexOf('_')
     // probably exist a better way to see if the list is empty
     if(items.wordlist.maxLevel == 0) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex)
        }
        else {
            localeShort = locale;
        }
        // If not found, we will use the default file
        items.wordlist.useDefault = true
        items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
        items.ourActivity.dataSetUrl + "default-"+localeShort+".json"));
        // We remove the using of default file for next time we enter this function
        items.wordlist.useDefault = false
    }
    
    maxLevel=items.wordlist.maxLevel;
    initLevel(); 
    
}

function helico()
{	
 
}
function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;		
    initSublevel();
    helico();
    level = items.wordlist.getLevelWordList(currentLevel+1);
    {	//to set the layout...populate
        var letters = new Array();
        items.keyboard.shiftKey = false;
        for (var i = 0; i < level.words.length; i++) {
            for (var j = 0; j < level.words[i].length; j++) {
                var letter = level.words[i].charAt(j);
                var isUpper = (letter == letter.toLocaleUpperCase());
                if (isUpper && letters.indexOf(letter.toLocaleLowerCase()) !== -1)
                    items.keyboard.shiftKey = true;
                else if (!isUpper && letters.indexOf(letter.toLocaleUpperCase()) !== -1)
                    items.keyboard.shiftKey = true;
                else if (letters.indexOf(letter) === -1)
                    letters.push(level.words[i].charAt(j));
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
        console.log(text+"\n");
        var flag = 0;
        var inital = wordi;
	console.log(inital+"brazil");
        wordi = "";
        for(var i = 0; i< current_word.length ; i++) {
            if(current_word[i] === text) {
               flag=1;
	       count_no_alphabet +=1;
	       if(i === 0){
		  wordi=wordi+current_word.charAt(0);
		  for(var j = 1; j <inital.length ; j = j+1)
		  {	wordi = wordi+inital.charAt(j);
		  }
               }
               else{
		  var j=i*2;
		    for(var k=0;k<inital.length;k=k+1)
		    {	   if(j === k)
			   {	wordi = wordi+current_word.charAt(i);
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
		no_of_life=no_of_life-1;
	}				
        items.hidden.text=wordi;
	if(count_no_alphabet === (current_word.length))
	{	items.ping_animation.running = true 
		initSublevel();
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
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function initSublevel()
{	maxsublevel = items.wordlist.getMaxSubLevel(items.bar.level);
        items.wordlist.initRandomWord(items.bar.level);
	win=0;
	var text1 = items.wordlist.getRandomWord();
	wordi = new Array();
	current_word = text1 ;
        count_no_alphabet = 0;
	console.log(current_word);
	for(var i = 0; i < current_word.length ; i=i+1)
	{   if(i == 0)	
	    {	wordi.push("_ ");   }
	    else
	    {	wordi = wordi + sp;		
	    }
	}
	console.log(wordi);
	items.hidden.text=qsTr(wordi);
}

function nextSublevel()
{	if(maxsublevel<= ++currentSublevel)
	{		currentSublevel=0;	}
	initSublevel();
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items)
        items.textinput.forceActiveFocus();
}