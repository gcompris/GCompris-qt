/* GCompris - imageid.js
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
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

.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel = 2;
var maxSubLevel = 0;
var items;
var baseUrl = "qrc:/gcompris/src/activities/imageid/resource/";
var dataset = null;

function start(items_) {
    console.log("Imageid activity: start");
    
    items = items_;
    currentLevel = 0;
    currentSubLevel = 0;
    // determine maxLevel:
    for (maxLevel = 0; items.file.exists(baseUrl + "/board" + (maxLevel + 1) + ".json")
        ; maxLevel++);
    if (maxLevel == 0) {
        console.error("Imageid: No dataset found, can't continue!");
        return;
    } else
        console.debug("Imageid: Found " + maxLevel + " levels");

    initLevel();
}

function stop() {
    console.log("Imageid activity: stop");
}

function validateDataset(levels)
{
    if (levels.length < 1)
        return false;
    for (var i = 0; i < levels.length; i++) {
        if (undefined === levels[i].image 
            || undefined === levels[i].good
            || undefined === levels[i].bad)
            return false;
    }
    return true;
}

function getCorrectAnswer()
{
    return dataset[currentSubLevel].good;
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    if (currentSubLevel == 0) {
        // initialize level
        var datasetUrl = baseUrl + "board" + (currentLevel + 1) + ".json";
        dataset = items.parser.parseFromUrl(datasetUrl, validateDataset);
        if (dataset == null) {
            console.error("Imageid: Invalid dataset, can't continue: "
                    + datasetUrl);
            return;
        }
        maxSubLevel = dataset.length;
        items.score.numberOfSubLevels = maxSubLevel;
    }
    // initialize sublevel
    items.score.currentSubLevel = currentSubLevel + 1;
    items.wordListModel.clear();
    // shuffle the words in the list so it is not always the first word to be the good one
    var allWords = dataset[currentSubLevel].bad.slice().concat(dataset[currentSubLevel].good);
    Core.shuffle(allWords);
    for (var i = 0; i < allWords.length; i++)
        items.wordListModel.append( {"word": allWords[i] } );
    items.wordImage.source = baseUrl + "/" + dataset[currentSubLevel].image;
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
        currentSubLevel = 0;
        nextLevel();
    } else
        initLevel();
}
