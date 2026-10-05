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
.import QtQuick as Quick
.import core 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var useMultipleDataset;
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
    items.numberOfLevel = useMultipleDataset ? items.levels.length : levelCount_;
    glowEnabledDefault = answerGlow_;
    displayDropCircle = displayDropCircle_;

    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);

    items.score.currentSubLevel = 0;
    items.score.numberOfSubLevels = 0;
    resetData();
    initLevel();
}

function resetData() {
    resetKeyboardControls();
    resetSelectedIndices();
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
        items.dataset.source = items.levels[items.currentLevel][items.score.currentSubLevel];
    else
        items.dataset.source = boardsUrl + "board" + "/" + "board" + (items.currentLevel+1) + "_" + items.score.currentSubLevel + ".qml";
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

    if(items.score.currentSubLevel == 0 && levelData.numberOfSubLevel != undefined)
        items.score.numberOfSubLevels = levelData.numberOfSubLevel + 1;

    if(levelData.glow === undefined)
        glowEnabled = glowEnabledDefault;
    else
        glowEnabled = levelData.glow;

    items.toolTip.show('');

    if(levelData.instruction === undefined) {
        items.instructionPanel.opacity = 0;
        items.instructionPanel.textItem.text = "";
    } else if(!displayDropCircle) {
        items.instructionPanel.opacity = 0;
        items.instructionPanel.textItem.text = levelData.instruction;
    }
    else {
        items.instructionPanel.opacity = 1;
        items.instructionPanel.textItem.text = levelData.instruction;
    }

    for(var i = 0, j = 0, k = 0; i < levelData.levels.length; i++) {

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
                         items.spotsContainer, {
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

    // Shuffle only the ListModel to have different indices between the ListWidget and spots, and keep the original data order for the spots
    Core.shuffleListModel(items.availablePieces.model);

    //Initialize displayedGroup variable which is used for showing navigation bars
    for(var i=0;i<items.availablePieces.view.nbDisplayedGroup;++i)
        items.availablePieces.view.displayedGroup[i] = true;
    items.inputLocked = false;
}

function hideInstructions() {
        items.instructionPanel.opacity = 0;
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("flower");
    }
    else {
        initLevel();
    }
}

function nextLevel() {
    items.score.currentSubLevel = 0;
    items.score.numberOfSubLevels = 0;
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 0;
    items.score.numberOfSubLevels = 0;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function win() {
    items.goodAnswerSound.play();
    if(items.score.visible) {
        items.score.currentSubLevel += 1;
        items.score.playWinAnimation();
    } else {
        items.bonus.good("flower");
    }
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

function resetKeyboardControls() {
    items.keyboardControls = false;
    items.listFocus = true;
}

function resetSelectedIndices() {
    items.availablePieces.repeater.currentIndex = -1;
    items.selectedSpotIndex = -1;
    items.selectedSpot = null;
}

function moveCursorLeft() {
    if(items.listFocus) {
        if(!items.availablePieces.okEnabled) {
            items.availablePieces.selectPreviousItem();
        }
        return;
    }
    selectPreviousSpot();
}

function moveCursorRight() {
    if(items.listFocus) {
        if(!items.availablePieces.okEnabled) {
            items.availablePieces.selectNextItem();
        }
        return;
    }
    selectNextSpot();
}

function moveCursorUp() {
    if(items.listFocus) {
        if(!items.availablePieces.okEnabled) {
            items.availablePieces.selectPreviousItem();
        }
        return;
    }
    selectPreviousSpot();
}

function moveCursorDown() {
    if(items.listFocus) {
        if(!items.availablePieces.okEnabled) {
            items.availablePieces.selectNextItem();
        }
        return;
    }
    selectNextSpot();
}

function deselectSpot() {
    if(items.selectedSpot != null) {
        items.selectedSpot.displaySelector = false;
        items.selectedSpotIndex = -1;
        items.selectedSpot = null
    }
}

function hideSpotSelector() {
    if(items.selectedSpot) {
        items.selectedSpot.displaySelector = false;
        items.selectedSpot = null;
    }
}

function selectSpot(_index) {
    deselectSpot();
    items.selectedSpotIndex = _index;
    items.selectedSpot = items.spotsContainer.children[_index];
    items.selectedSpot.displaySelector = true;
}

function selectNextSpot() {
    var newSpotIndex = items.selectedSpotIndex + 1;
    if(newSpotIndex >= spots.length) {
        newSpotIndex = 0
    }
    selectSpot(newSpotIndex);
}

function selectPreviousSpot() {
    var newSpotIndex = items.selectedSpotIndex - 1;
    if(newSpotIndex < 0) {
        newSpotIndex = spots.length - 1;
    }
    selectSpot(newSpotIndex);
}

function spacePressed() {
    if(items.listFocus) {
        switchFocus();
    } else {
        if(items.availablePieces.repeater.currentIndex != -1) {
            dropItem();
        } else {
            undropItem();
        }
        switchFocus();
    }
}

function dropItem() {
    if(items.availablePieces.repeater.currentIndex === -1) {
        undropItem();
    } else {
        var itemToDrop = items.availablePieces.repeater.itemAt(items.availablePieces.repeater.currentIndex);
        itemToDrop.dropToSpot(items.selectedSpot);
    }
}

function switchFocus() {
    items.listFocus = !items.listFocus
    if(!items.listFocus) {
        if(items.availablePieces.repeater.currentIndex === -1) {
            items.availablePieces.selectFirstItem();
        }
        if(items.selectedSpotIndex < 0) {
            items.selectedSpotIndex = 0;
        }
        selectSpot(items.selectedSpotIndex);
    } else {
        hideSpotSelector();
        if(items.availablePieces.repeater.itemAt(items.availablePieces.repeater.currentIndex) && items.availablePieces.repeater.itemAt(items.availablePieces.repeater.currentIndex).isDropped) {
            items.availablePieces.selectFirstItem();
        }
    }
}

function undropItem() {
    if(items.selectedSpot != null) {
        items.selectedSpot.imageRemove();
        highLightSpot(null, null);
        items.availablePieces.repeater.itemAt(0).hideOkButton();
    }
}
