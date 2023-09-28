/* GCompris - explore-level.js
*
* SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

.pragma library
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var url

function start(items_,url_,levelCount_) {
    items = items_
    url = url_
    numberOfLevel = levelCount_
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.score.currentSubLevel = 1

    initLevel()
}

function stop() {
    items.audioVoices.stop()
}

function initLevel() {
    var filename = url + "board" + "/" + "board" + (items.currentLevel + 1) + ".qml"
    items.dataset.source = filename
    items.progressbar.value = 0
    items.progressbar.to = items.dataModel.count
    items.score.numberOfSubLevels = items.hasAudioQuestions ? 3 : 2;
    // randomize the questions for level 2 and 3
    items.questionOrder = Array.apply(null, {length: items.dataModel.count}).map(Number.call, Number)
    Core.shuffle(items.questionOrder);

    // Change the currentSubLevel value to 1 to be sure to update the question value
    // else if you are sublevel 0 and go to last level, the question is not the good one
    items.progressbar.value = 1
    items.progressbar.value = 0
    items.descriptionPanel.visible = false
    items.instruction.visible = true

    reload();
}

function nextLevel() {
    ++items.score.currentSubLevel
    if((items.currentLevel + 1) >= numberOfLevel && items.score.numberOfSubLevels < items.score.currentSubLevel)
    {
        items.currentLevel = -1
    }
    if (items.score.numberOfSubLevels < items.score.currentSubLevel) {
        items.currentLevel ++
        items.score.currentSubLevel = 1
    }
    initLevel();

    // Stop audio if necessary (switch from level 2 at beginning to a new level for example)
    items.audioVoices.stop()

    if (items.score.currentSubLevel == 2) {
        items.progressbar.value = 0;
        initSubSubLevel();
    }
}

function previousLevel() {
    --items.score.currentSubLevel
    if(items.currentLevel <= 0 && items.score.currentSubLevel < 1)
    {
        items.currentLevel = numberOfLevel-1
        items.score.currentSubLevel = items.score.numberOfSubLevels
    }
    else if(items.score.currentSubLevel < 1) {
        items.currentLevel--
        items.score.currentSubLevel = items.score.numberOfSubLevels
    }
    initLevel();

    // Stop audio if necessary (switch from level 2 at beginning to a new level for example)
    items.audioVoices.stop()

    if(items.score.currentSubLevel == 2 && items.hasAudioQuestions) {
       repeat();
    }
}

function isComplete() {
    for(var i = 0 ; i < items.dataModel.count ; ++ i) {
        if(!items.dataModel.itemAt(i).starVisible)
            return false;
    }
    return true;
}

function initSubSubLevel(IsNext) {
    if(items.progressbar.value == items.dataModel.count) {
        items.bonus.good("smiley");
    }
     if(items.score.currentSubLevel == 2 && items.hasAudioQuestions && getCurrentQuestion()) {
         if(items.bonus.isPlaying) {
             items.bonusPlaying = true;
         } else {
             repeat();
        }
    }
}

function nextSubSubLevel() {
    items.audioVoices.silence(2000)
    initSubSubLevel(true)
}

function reload() {
    for(var i = 0 ; i < items.dataModel.count ; ++ i) {
        items.dataModel.itemAt(i).starVisible = false;
    }
}

function repeat() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
    items.audioVoices.append(getCurrentQuestion().audio);
}

function getCurrentQuestion() {
    return items.dataset.item.tab[items.questionOrder[items.progressbar.value]];
}
