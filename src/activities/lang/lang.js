/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
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
*/.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang
.import "qrc:/gcompris/src/activities/lang/quiz.js" as QuizActivity
.import "qrc:/gcompris/src/activities/lang/spell_it.js" as SpellActivity

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel;
var maxSubLevel;
var items;
var baseUrl = "qrc:/gcompris/src/activities/lang/resource/";
var dataset = null;
var lessons
var maxWordInLesson = 12
var wordList
var subLevelsLeft
var menus = []
var currentProgress = []
var savedProgress = []
var favorites= []
var subWordList
var currentSubLesson
var maxSubLesson
// miniGames is list of miniGames
// first element is Activity name,
// second element is mode of miniGame
// third element is the qml to load
var miniGames = [["QuizActivity", 1,"Quiz.qml"],
                 ["QuizActivity", 2,"Quiz.qml"],
                 ["QuizActivity", 3,"Quiz.qml"],
                 ["SpellActivity", 1,"SpellIt.qml"]];
var currentMiniGame
var loadedItems

function init(items_) {
    items = items_
    maxLevel = 0
    maxSubLevel = 0
    currentLevel = 0
    currentSubLevel = 0
    currentSubLesson = 0
    currentMiniGame = -1
}

function start() {
    currentLevel = 0;
    currentSubLevel = 0;

    var locale = items.locale == "system" ? "$LOCALE" : items.locale
    dataset = Lang.load(items.parser, baseUrl, "words.json", "content-"+ locale +".json")

    // If dataset is empty, we try to load from short locale and if not present again, we switch to default one
    var localeUnderscoreIndex = locale.indexOf('_')
    if(!dataset) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex)
        }
        else {
            localeShort = locale;
        }
        dataset = Lang.load(items.parser, baseUrl, "words.json", "content-"+localeShort+ ".json")
    }

    //If still dataset is empty then fallback to english
    if(!dataset) {
        // English fallback
        items.background.englishFallback = true
        dataset = Lang.load(items.parser, baseUrl, "words.json", "content-en.json")
    } else {
        items.background.englishFallback = false
    }

    lessons = Lang.getAllLessons(dataset)
    maxLevel = lessons.length

    menus = Lang.getMenuModel(dataset, items)
    items.menuModel.clear()

    for (var j =0; j<maxLevel; j++) {
        if(!(currentProgress[j] > 0))
            currentProgress[j] = 0
    }

    for (var k =0; k<maxLevel; k++) {
        if(!(savedProgress[k] >0)) {
            savedProgress[k] = 0
        }
        if(!favorites[k])
            favorites[k] = false
//        menus.push({'savedProgress': savedProgress[k] })
    }

    items.menuModel.clear()
    items.menuModel.append(menus)

//    console.log("model length "+ items.menuModel.count)

    items.imageFrame.visible = false
    items.score.visible = false

    items.menu_screen.visible = true
    items.menu_screen.focus = true
    items.menu_screen.forceActiveFocus()

    //    initLevel();

}

function stop() {
}

function initLevel(currentLevel_) {
    currentLevel = currentLevel_
    items.bar.level = currentLevel + 1;

    var currentLesson = lessons[currentLevel]
    wordList = Lang.getLessonWords(dataset, currentLesson);
    maxSubLesson = Math.floor(wordList.length / maxWordInLesson)

    var subLessons = []
    for (var i = 0; i < wordList.length; i++) {
        subLessons[i] = wordList.splice(0,maxWordInLesson)
    }

    subWordList = subLessons[currentSubLesson]

    Core.shuffle(subWordList);

    maxSubLevel = subWordList.length;
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.currentSubLevel = 1;
    items.score.visible = true

    items.menu_screen.visible = false
    items.imageFrame.visible = true

    items.wordTextbg.visible = true
    items.wordText.visible = true
    items.categoryTextbg.visible = true
    items.categoryText.changeCategory(currentLesson.name);
    items.miniGameLoader.source = ""
    items.keyboard.visibleFlag = false
    currentMiniGame = 0

    subLevelsLeft = [];
    for(var i in subWordList) {
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    for(i =0 ;i < maxLevel;i++)
//    items.progress = savedProgress
    if(currentSubLesson == 0)
            currentProgress[currentLevel] = savedProgress[currentLevel] //change to saved progress

    initSubLevel()
}

function nextSubLesson(){
    if(savedProgress[currentLevel] < currentProgress[currentLevel])
        savedProgress[currentLevel] = currentProgress[currentLevel]

    if(currentSubLesson < maxSubLesson) {
        ++currentSubLesson
        initLevel(currentLevel)
    }
    else {
        if(maxLevel <= ++currentLevel ) {
            currentLevel = 0
        }
        launchMenuScreen()
    }
}

function nextLevel() {
    if(savedProgress[currentLevel] < currentProgress[currentLevel])
        savedProgress[currentLevel] = currentProgress[currentLevel]
    console.log("clicked on next and saved "+ savedProgress[currentLevel])

    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0
    }
}

function previousLevel() {
    if(savedProgress[currentLevel] < currentProgress[currentLevel])
        savedProgress[currentLevel] = currentProgress[currentLevel]
    console.log("clicked on prev and saved "+ savedProgress[currentLevel])

    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    initLevel(currentLevel);
}

function initSubLevel() {
    // initialize sublevel
    if(items.score.currentSubLevel == 1)
        items.previousWordButton.visible = false
    else
        items.previousWordButton.visible = true

    items.goodWord = subWordList[items.score.currentSubLevel-1]
    items.wordImage.changeSource("qrc:/gcompris/data/" + items.goodWord.image)
    items.wordText.changeText(items.goodWord.translatedTxt)
}

function nextSubLevel() {
    ++items.score.currentSubLevel;
    ++currentProgress[currentLevel]
    //make a change when progress exceedes previous one 2 0

    if(items.score.currentSubLevel == items.score.numberOfSubLevels+1) {
        // saving progress after completion
        savedProgress[currentLevel] = currentProgress[currentLevel]
        //here logic for starting quiz game
        nextMiniGame()
    }
    else {
        initSubLevel();
    }
}

function prevSubLevel() {
    --items.score.currentSubLevel
    --currentProgress[currentLevel]
    if( items.score.currentSubLevel <= 0) {
        //Do nothing
    }
    else {
        initSubLevel()
    }
}

//called by a miniGame when it is won
function nextMiniGame() {
    if(currentMiniGame < miniGames.length) {


        console.log("launching next Mini game current progress " + currentProgress[currentLevel]
                    +" saved progress "+ savedProgress[currentLevel])

        var mode = miniGames[currentMiniGame][1];
        var itemToLoad = miniGames[currentMiniGame][2];

        // reloading the subWordList
        var currentLesson = lessons[currentLevel]
        var wordList = Lang.getLessonWords(dataset, currentLesson);

        var subLessons = []
        for (var i = 0; i < wordList.length; i++) {
            subLessons[i] = wordList.splice(0,maxWordInLesson)
        }

        var subWordList = subLessons[currentSubLesson]


        Core.shuffle(subWordList);

        maxSubLevel = subWordList.length

        items.miniGameLoader.source = itemToLoad;
        loadedItems = items.miniGameLoader.item

        // resetting the subWordList length because it could have been spliced by quiz miniGame 3
        if(currentMiniGame === 3) {
            items.score.numberOfSubLevels = subWordList.length
        }

        // initiate the loaded item mini game
        loadedItems.init(items, loadedItems, subWordList, mode)
        ++currentMiniGame;
    }
}

function getProgressStatus(index) {
    return savedProgress[index  ]
}

function launchMenuScreen() {
    currentSubLesson = 0
    currentMiniGame = -1
    if(savedProgress[currentLevel] < currentProgress[currentLevel])
        savedProgress[currentLevel] = currentProgress[currentLevel]
    console.log("completed level and now progress: "+ savedProgress[currentLevel])
    items.menu_screen.menuModel.clear()
    items.menu_screen.menuModel.append(menus)
    items.menu_screen.forceActiveFocus()
    if(items.menu_screen.visible == false) {
        items.menu_screen.visible = true
        items.imageFrame.visible = false
        items.score.visible = false
        level = 0
        if (loadedItems)
            loadedItems.visible = false
    }
}
