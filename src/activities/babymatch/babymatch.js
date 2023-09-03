/* GCompris - babymatch.js
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var useMultipleDataset;
var currentSubLevel = 0;
var numberOfLevel;
var numberOfSubLevel;
var items;
var imagesUrl;
var soundsUrl;
var boardsUrl;
var glowEnabled;
var glowEnabledDefault;
var spots = [];
var showText = [];
var displayDropCircle;

function start(items_, imagesUrl_, soundsUrl_, boardsUrl_, levelCount_, answerGlow_, displayDropCircle_, useMultipleDataset_) {
    items = items_;
    imagesUrl = imagesUrl_;
    soundsUrl = soundsUrl_;
    boardsUrl = boardsUrl_;
    useMultipleDataset = useMultipleDataset_;
    numberOfLevel = useMultipleDataset ? items.levels.length : levelCount_;
    glowEnabledDefault = answerGlow_;
    displayDropCircle = displayDropCircle_;

    items.currentLevel = Core.getInitialLevel(numberOfLevel);

    currentSubLevel = 0;
    numberOfSubLevel = 0;
    resetData();
    initLevel();
}

function resetData() {
    items.availablePieces.model.clear();
    for(var i = 0 ; i < spots.length ; ++ i) {
        spots[i].destroy();
    }
    spots = [];

    for(var i = 0 ; i < showText.length ; ++ i)
        showText[i].destroy();
    showText = [];

    items.backgroundPiecesModel.clear();
    items.backgroundImageSource.source = "";
}

function stop() {
    resetData();
}

function initLevel() {
    if(useMultipleDataset)
        items.dataset.source = items.levels[items.currentLevel][currentSubLevel];
    else
        items.dataset.source = boardsUrl + "board" + "/" + "board" + (items.currentLevel+1) + "_" + currentSubLevel + ".qml";
    var levelData = items.dataset.item;
    resetData();
    items.availablePieces.view.currentDisplayedGroup = 0;
    items.availablePieces.view.previousNavigation = 1;
    items.availablePieces.view.nextNavigation = 1;
    items.availablePieces.view.okShowed = false;
    items.availablePieces.view.showGlow = false;
    items.availablePieces.view.ok.height = 0;

    var dropItemComponent = Qt.createComponent("qrc:/gcompris/src/activities/babymatch/DropAnswerItem.qml");
    var textItemComponent = Qt.createComponent("qrc:/gcompris/src/activities/babymatch/TextItem.qml");

    if(currentSubLevel == 0 && levelData.numberOfSubLevel != undefined)
        numberOfSubLevel = levelData.numberOfSubLevel;

    items.score.currentSubLevel = currentSubLevel + 1;
    items.score.numberOfSubLevels = numberOfSubLevel + 1;

    if(levelData.glow === undefined)
        glowEnabled = glowEnabledDefault;
    else
        glowEnabled = levelData.glow;

    items.toolTip.show('');

    if(levelData.instruction === undefined) {
        items.instruction.opacity = 0;
        items.instruction.text = "";
    } else if(!displayDropCircle) {
        items.instruction.opacity = 0;
        items.instruction.text = levelData.instruction;
    }
    else {
        items.instruction.opacity = 1;
        items.instruction.text = levelData.instruction;
    }
	
    // Fill available pieces
    var arr = [];
    var levelDataLength = levelData.levels.length;
    for(var i=0 ; i < levelDataLength ; i++)
        arr[i] = i;

    var i = 0, j = 0, k = 0, n = 0;
    while(levelDataLength--) {

        //Randomize the order of pieces
        var rand = Math.floor(Math.random() * levelDataLength);
        i = arr[rand];
        arr.splice(rand,1);

        //Create answer pieces
        if(levelData.levels[i].type === undefined) {
            items.availablePieces.model.append( {
                "imgName": levelData.levels[i].pixmapfile,
                "imgSound": levelData.levels[i].soundFile ?
                     soundsUrl + levelData.levels[i].soundFile :
                     "qrc:/gcompris/src/core/resource/sounds/scroll.wav",
                "imgHeight": levelData.levels[i].height === undefined ? 0 : levelData.levels[i].height,
                "imgWidth": levelData.levels[i].width === undefined ? 0 : levelData.levels[i].width,
                "toolTipText":
                   // We remove the text before the pipe symbol if any (translation disembiguation)
                   levelData.levels[i].toolTipText === undefined ?
                                                       "" :
                                                       (levelData.levels[i].toolTipText.split('|').length > 1 ?
                                                        levelData.levels[i].toolTipText.split('|')[1] :
                                                        levelData.levels[i].toolTipText),
            });

            spots[j++] = dropItemComponent.createObject(
                         items.backgroundImage, {
                            "posX": levelData.levels[i].x,
                            "posY": levelData.levels[i].y,
                            "imgName" : levelData.levels[i].pixmapfile,
                         });
        }
        //Create Text pieces for the level which has to display additional information
        else if(levelData.levels[i].type === "DisplayText") {
			showText[k++] = textItemComponent.createObject(
                            items.backgroundImage, {
                                "posX": levelData.levels[i].x,
                                "posY": levelData.levels[i].y,
                                "textWidth": levelData.levels[i].width,
                                "textHeight": levelData.levels[i].height,
                                "showText" : levelData.levels[i].text
                            });
        }
        //Create static background pieces
        else {
            if(levelData.levels[i].type === "SHAPE_BACKGROUND_IMAGE") {
                items.backgroundImageSource.source = imagesUrl + levelData.levels[i].pixmapfile;
                if(levelData.levels[i].width)
                    items.backgroundImageSource.sourceSize.width = levelData.levels[i].width;
                if(levelData.levels[i].height)
                    items.backgroundImageSource.sourceSize.height = levelData.levels[i].height;
            }
            else {
                items.backgroundPiecesModel.append( {
                    "imgName": levelData.levels[i].pixmapfile,
                    "posX": levelData.levels[i].x,
                    "posY": levelData.levels[i].y,
                    "imgHeight": levelData.levels[i].height === undefined ? 0 : levelData.levels[i].height,
                    "imgWidth": levelData.levels[i].width === undefined ? 0 : levelData.levels[i].width,
                });
            }
        }
    }

    //Initialize displayedGroup variable which is used for showing navigation bars
    for(var i=0;i<items.availablePieces.view.nbDisplayedGroup;++i)
        items.availablePieces.view.displayedGroup[i] = true;
    items.inputLocked = false;
}

function hideInstructions() {
        items.instruction.opacity = 0;
}

function nextSubLevel() {
    if(numberOfSubLevel < ++currentSubLevel) {
        nextLevel();
    }
    else
        initLevel();
}

function nextLevel() {
    currentSubLevel = 0;
    numberOfSubLevel = 0;
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    currentSubLevel = 0;
    numberOfSubLevel = 0;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function win() {
    items.bonus.good("flower");
}

function getClosestSpot(x, y) {
    var minDist = 200 * GCompris.ApplicationInfo.ratio;
    var closestDist = Number.MAX_VALUE;
    var closestItem;
    for(var i = 0 ; i < spots.length ; ++ i) {
        // Calc Distance
        var spot = spots[i];
        var dist = Math.floor(Math.sqrt(Math.pow(x - spot.x, 2) +
                                        Math.pow(y - spot.y, 2)));
        if(dist < closestDist) {
            closestDist = dist;
            closestItem = spot;
        }
    }
    if(closestDist < minDist) {
        return closestItem;
    } else {
        return null;
    }
}

function highLightSpot(stopItem, tile) {
    for(var i = 0 ; i < spots.length ; ++ i) {
        if(spots[i] === stopItem) {
            spots[i].show(tile);
        } else {
            spots[i].hide();
        }
    }
}

function clearHighLightSpots() {
    for(var i = 0 ; i < spots.length ; ++ i) {
        spots[i].hide();
    }
}
