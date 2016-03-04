/* GCompris - letter-in-word.js
 *
 * Copyright (C) 2014 Holger Kaelberer
 *               2016 Akshat Tandon
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of click-on-letter)
 *   Akshat Tandon    <akshat.tandon@research.iiit.ac.in>
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
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var url = "qrc:/gcompris/src/activities/letter-in-word/resource/"
var defaultLevelsFile = ":/gcompris/src/activities/letter-in-word/resource/levels/levels-en.json";
var maxLettersPerLine = 6;

var levels;
var currentLevel;
var maxLevel;
var currentSubLevel;
var currentLetter;
var maxSubLevel;
var level;
var questions;
var words;
var items;
var dataset = null;
var frequency;
var incorrectFlag = false;

function start(_items)
{
    Core.checkForVoices(_items.main);

    items = _items;


    // register the voices for the locale
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    GCompris.DownloadManager.updateResource(GCompris.DownloadManager.getVoicesResourceForLocale(locale))
    loadDataset();
    //console.log('Dataset:')
    //console.log(dataset);
    levels = Lang.getAllLessons(dataset)
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = levels.length;
    //console.log('Max num of levels')
    //console.log(maxLevel);
    initLevel();
}


function loadDataset()
{
    var resourceUrl = "qrc:/gcompris/src/activities/lang/resource/"

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    dataset = Lang.load(items.parser, resourceUrl,
                        GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                                                               "content-"+ locale +".json")
    //console.log('** Came here')
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
        dataset = Lang.load(items.parser, resourceUrl,
                            GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                                                                   "content-"+localeShort+ ".json")
    }
    //console.log('** Came here 2')

    if(!dataset) {
        // English fallback
        dataset = Lang.load(items.parser, resourceUrl,
                            GCompris.ApplicationSettings.wordset ? "words.json" : "words_sample.json",
                                                                   "content-en.json")
    }
    //console.log('** Came here 3')



}

function stop()
{
    items.animateX.stop()
}

function shuffleString(s)
{
    var a = s;
    var n = a.length;

    for(var i = n-1; i>0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
    return a.join("");
}

function initLevel() {
    //console.log("**********Current level: " + currentLevel)
    var componentsArr;
    items.bar.level = currentLevel + 1;
    if (currentSubLevel == 0 && !incorrectFlag) {
        level = levels[currentLevel];
        words = Lang.getLessonWords(dataset, level);
        Core.shuffle(words);
        var limit = Math.min(13, words.length)
        words = words.slice(0,limit)
        frequency = calculateFrequency();
        var tempQuestions = generateQuestions();
        maxSubLevel = tempQuestions.length;
        items.score.numberOfSubLevels = maxSubLevel;
        items.score.currentSubLevel = 1;
        questions = shuffleString(tempQuestions);
        items.wordsModel.clear();
        for (var i = 0; i < words.length; i++) {
            componentsArr = [];
            componentsArr.push({"textdata": words[i].translatedTxt});
            //console.log(componentsArr.length)
            items.wordsModel.append({
                                        "spelling": words[i].translatedTxt,
                                        "imgurl": words[i].image,
                                        "selected": false,
                                        "components": componentsArr
                                    });
        }
    } else {
        items.score.currentSubLevel = currentSubLevel + 1;
    }

    incorrectFlag = false;

    for(var i = 0; i < words.length; i++){
        items.wordsModel.setProperty(i, "selected", false);

    }

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    currentLetter = questions[currentSubLevel];
    items.question = currentLetter
    items.animateX.restart();

    if (GCompris.ApplicationSettings.isAudioVoicesEnabled &&
            GCompris.DownloadManager.haveLocalResource(
                GCompris.DownloadManager.getVoicesResourceForLocale(locale))) {
        items.audioVoices.silence(100)
        playLetter(currentLetter)
    }
}

function calculateFrequency(){
    var freq = [];
    for(var i = 0; i < words.length; i++){
        var currentWord = words[i].translatedTxt;
        for(var j = 0; j < currentWord.length; j++){
            var character = currentWord.charAt(j);
            if(freq[character]){
                freq[character]++;
            }
            else{
                freq[character] = 1;
            }
        }
    }
    /*
    for(var i in freq){
        console.log(i)
        console.log(freq[i])

    }*/

    return freq;
}

function generateQuestions(){
    var freqArr = [];
    var ques = [];

    for(var character in frequency){
        //console.log('calc freq')
        //console.log(character)
        //console.log(frequency[character])
        freqArr.push([character, frequency[character]]);
    }

    freqArr.sort(function(a, b) {return b[1] - a[1]});

    /*
    for(var i = 0; i < freqArr.length; i++){
        console.log('freq arr')
        console.log(freqArr[i][0])
        console.log(freqArr[i][1])
    }*/

    var limit = Math.min(10, freqArr.length);
    //console.log(freqArr.length)
    //console.log(limit)
    for(var i = 0; i < limit; i++){
        ques.push(freqArr[i][0])
    }
    /*for(var i = 0; i < ques.length; i++){
        console.log('bablu')
        console.log(ques[i])
    }*/

    return ques;
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter)))
}

function nextLevel() {
    items.audioVoices.clearQueue()
    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.audioVoices.clearQueue()
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function checkAnswer()
{
    var checkFlag = false;
    var modelEntry;
    for(var i = 0; i < words.length; i++){
        modelEntry = items.wordsModel.get(i);
        for(var j = 0; j < modelEntry.spelling.length; j++){
            if(currentLetter == modelEntry.spelling.charAt(j) && modelEntry.selected == false){
                checkFlag = true;
                break;
            }
        }
    }
    if(checkFlag == false){
        items.bonus.good("flower");
    }
}

function checkWord(index)
{
    var checkFlag = false;
    var modelEntry = items.wordsModel.get(index);
    for(var i = 0; i < modelEntry.spelling.length; i++){
        if(currentLetter ==  modelEntry.spelling.charAt(i)){
            items.wordsModel.setProperty(index, "selected", true);
            checkAnswer();
            checkFlag = true;
            break;
        }
    }
    if(checkFlag == true){


        //items.wordsModel.setProperty(index, "components", componenetsArr)
        //items.wordsModel.setProperty(index, "imgurl","qrc:/gcompris/src/activities/lang/resource/words_sample/one.png")

        /*for(var i = 0; i < componenetsArr.length; i++){
            console.log(componenetsArr[i].textdata)
        }*/
        return true;
    }
    else{
        items.bonus.bad("flower");
        return  false;
    }
}

function incorrectSelection(){
    //console.log('Entered /*******************************');
    //console.log(typeof(questions))
    //console.log('Before')
    //console.log(questions)
    incorrectFlag = true;
    var quesLen = questions.length;
    questions = questions.slice(0,currentSubLevel) + questions.slice(currentSubLevel+1,quesLen) + questions.charAt(currentSubLevel);
    //console.log('After')
    //console.log(questions);
    currentSubLevel--;
    nextSubLevel();
    //console.log('Exited /*******************************');
}
