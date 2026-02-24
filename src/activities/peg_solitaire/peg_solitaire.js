/* GCompris - peg_solitaire.js
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items;

var englishBoard = {
    // "gridDivider" is the maximum between number of rows and number of columns of the grid.
    // Don't use grids with more than 8 to avoid too small grid.
    "gridDivider": 7,
    "gridCoordinates": [
            [2,0],[3,0],[4,0],
            [2,1],[3,1],[4,1],
[0,2],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],
[0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],
[0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],
            [2,5],[3,5],[4,5],
            [2,6],[3,6],[4,6]
            ],
    "defaultHoleIndex": 16,
    //: Board for the Peg solitaire game
    "description": qsTr("English board")
};

var frenchBoard = {
    "gridDivider": 7,
    "gridCoordinates": [
            [2,0],[3,0],[4,0],
      [1,1],[2,1],[3,1],[4,1],[5,1],
[0,2],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],
[0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],
[0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],
      [1,5],[2,5],[3,5],[4,5],[5,5],
            [2,6],[3,6],[4,6]
            ],
    "defaultHoleIndex": 11,
    //: Board for the Peg solitaire game
    "description": qsTr("French board")
};

var diamond32Board = {
    "gridDivider": 8,
    "gridCoordinates": [
                  [3,0],
            [2,1],[3,1],[4,1],
      [1,2],[2,2],[3,2],[4,2],[5,2],
[0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],
[0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],
      [1,5],[2,5],[3,5],[4,5],[5,5],
            [2,6],[3,6],[4,6],
                  [3,7]
            ],
    "defaultHoleIndex": 12,
    //: Board for the Peg solitaire game
    "description": qsTr("32 holes diamond board")
};

var asymmetricalBoard = {
    "gridDivider": 8,
    "gridCoordinates": [
            [2,0],[3,0],[4,0],
            [2,1],[3,1],[4,1],
            [2,2],[3,2],[4,2],
[0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],
[0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],
[0,5],[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],
            [2,6],[3,6],[4,6],
            [2,7],[3,7],[4,7]

    ],
    "defaultHoleIndex": 20,
    //: Board for the Peg solitaire game
    "description": qsTr("Asymmetrical board")
};

var levelList = [englishBoard, frenchBoard, diamond32Board, asymmetricalBoard];

var slotsWhichCanReceive = []; // list of slots which can receive selected peg
var selectedPeg = null;
var dropTarget = null;

function start(items_) {
    items = items_;
    items.numberOfLevel = levelList.length
    // Make sure numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel();
}

function stop() {
    if(selectedPeg) {
        selectedPeg.moveAnim.stop();
    }
}

function initLevel() {
    items.inputBlocked = true;
    deselectPeg();
    resetDropTarget();
    items.initPieceRemoved = false;
    items.gameGrid = levelList[items.currentLevel];
    items.boardDescription = items.gameGrid.description;
    items.descriptionVisible = true;
    items.boardRepeater.model = items.gameGrid.gridCoordinates;
    items.boardRepeater.resetBoard();
    items.pegsWhichCanMove = 0;
    items.pegsToEat = items.gameGrid.gridCoordinates.length - 2;
    if(items.useDefaultHole) {
        removeFirstPeg(items.boardRepeater.itemAt(items.gameGrid.defaultHoleIndex));
    }
    slotsWhichCanReceive = [];
    selectedPeg = null;
    items.undoList = [];
    items.redoList = [];
    items.alreadyWon = false;
    items.inputBlocked = false;
}

function slotPressed(_clickedSlot) {
    items.descriptionVisible = false;
    if(!items.initPieceRemoved) {
        removeFirstPeg(_clickedSlot);
    } else if(_clickedSlot.canMove) {
        selectPeg(_clickedSlot);
    } else if(_clickedSlot.canReceive) {
        scheduleMovePeg(_clickedSlot);
    } else {
        items.inputBlocked = true;
        deselectPeg();
        resetDropTarget();
        items.inputBlocked = false;
    }
}

function scheduleMovePeg(_clickedSlot) {
    items.inputBlocked = true;
    selectedPeg.targetSlot = _clickedSlot;
    selectedPeg.moveAnim.start();
    items.smudgeSound.play()
}

function doPendingMove() {
    movePeg(selectedPeg.targetSlot, false);
}


function checkDropTarget() {
    if(dropTarget) {
        items.inputBlocked = true;
        movePeg(dropTarget, false);
        items.smudgeSound.play();
    }
}

function setDropTarget(_targetSlot) {
    dropTarget = _targetSlot;
    dropTarget.isDropTarget = true;
}

function resetDropTarget() {
    if(dropTarget) {
        dropTarget.isDropTarget = false;
    }
    dropTarget = null;
}

function deselectPeg() {
    if(selectedPeg) {
        selectedPeg.isSelected = false;
    }
    selectedPeg = null;
    resetCanReceive();
}

function doUndo() {
    items.inputBlocked = true;
    if(items.undoList.length > 0) {
        deselectPeg();
        resetDropTarget();
        var undoItem = items.undoList.pop();
        var _initialSlot = undoItem.initialSlot;
        var _destinationSlot = undoItem.destinationSlot;
        var _eatenSlot = undoItem.eatenSlot;
        _initialSlot.hasPeg = true;
        _destinationSlot.hasPeg = false;
        _eatenSlot.hasPeg = true;
        items.pegsToEat++;

        setCanMove(_initialSlot.index, true);
        checkSurroundingSlots(_initialSlot.modelData);

        setCanMove(_destinationSlot.index, false);
        checkSurroundingSlots(_destinationSlot.modelData);

        var newCanMove = checkCanMove(_eatenSlot.modelData);
        setCanMove(_eatenSlot.index, newCanMove);
        checkSurroundingSlots(_eatenSlot.modelData);

        items.redoList.push(undoItem);
    }
    items.inputBlocked = false;
}

function doRedo() {
    items.inputBlocked = true;
    if(items.redoList.length > 0) {
        deselectPeg();
        resetDropTarget();
        var undoItem = items.redoList.pop();
        selectedPeg = undoItem.initialSlot;
        movePeg(undoItem.destinationSlot, true);
        selectedPeg = null;

        items.undoList.push(undoItem);
    }
    items.inputBlocked = false;
}

function movePeg(_clickedSlot, _isUndo) {
    items.inputBlocked = true;
    // check which direction to find eaten peg
    var moveToPosition = _clickedSlot.modelData;
    var selectedPegPosition = selectedPeg.modelData;
    var diffX = (moveToPosition[0] + selectedPegPosition[0]) * 0.5;
    var diffY = (moveToPosition[1] + selectedPegPosition[1]) * 0.5;
    var eatenPegPosition = [diffX, diffY];
    var eatenPegIndex = findPeg(eatenPegPosition);
    var eatenPeg = items.boardRepeater.itemAt(eatenPegIndex);
    eatenPeg.hasPeg = false;
    items.pegsToEat--;
    setCanMove(eatenPegIndex, false);

    selectedPeg.hasPeg = false;
    setCanMove(selectedPeg.index, false);

    _clickedSlot.hasPeg = true;
    var newCanMove = checkCanMove(_clickedSlot.modelData);
    setCanMove(_clickedSlot.index, newCanMove);

    checkSurroundingSlots(selectedPeg.modelData);
    checkSurroundingSlots(eatenPegPosition);
    checkSurroundingSlots(_clickedSlot.modelData);

    if(!_isUndo) {
        items.undoList.push({ "initialSlot": selectedPeg, "destinationSlot": _clickedSlot, "eatenSlot": eatenPeg });
        items.redoList = [];
    }

    // at the end
    deselectPeg();
    resetDropTarget();

    checkBoard();
}

function checkBoard() {
    if(items.pegsWhichCanMove === 0) {
        if(items.pegsToEat > 0) {
            items.bonus.bad('flower');
        } else if (!items.alreadyWon){
            items.alreadyWon = true;
            items.bonus.good('flower');
        }
    } else {
        items.inputBlocked = false;
    }
}

function removeFirstPeg(_clickedSlot) {
    items.inputBlocked = true;
    _clickedSlot.hasPeg = false;
    _clickedSlot.canMove = false;
    var pegXY = _clickedSlot.modelData;
    // set next surrounding pieces to canMove
    var nextSurroundingPegs = getNextSurroundingPegs(pegXY);
    for(var i = 0; i < 4; i++) {
        var indexOfPegToFind = findPeg(nextSurroundingPegs[i]);
        if(indexOfPegToFind != -1) {
            setCanMove(indexOfPegToFind, true);
        }
    }
    items.initPieceRemoved = true;
    items.inputBlocked = false;
}

function checkSurroundingSlots(_pegXY) {
    // check if surrounding pieces can move
    var surroundingPegs = getSurroundingPegs(_pegXY);
    for(var i = 0; i < 4; i++) {
        var indexOfPegToFind = findPeg(surroundingPegs[i]);
        if(indexOfPegToFind != -1 && items.boardRepeater.itemAt(indexOfPegToFind).hasPeg) {
            var newCanMove = checkCanMove(surroundingPegs[i]);
            setCanMove(indexOfPegToFind, newCanMove);
        }
    }

    // check if next surrounding pieces can move
    var nextSurroundingPegs = getNextSurroundingPegs(_pegXY);
    for(var i = 0; i < 4; i++) {
        var indexOfPegToFind = findPeg(nextSurroundingPegs[i]);
        if(indexOfPegToFind != -1 && items.boardRepeater.itemAt(indexOfPegToFind).hasPeg) {
            var newCanMove = checkCanMove(nextSurroundingPegs[i]);
            setCanMove(indexOfPegToFind, newCanMove);
        }
    }
}

function checkCanMove(_pegXY) {
    var canMove = false;
    var surroundingPegs = getSurroundingPegs(_pegXY);
    var nextSurroundingPegs = getNextSurroundingPegs(_pegXY);
    // check on each direction if neighbour slot has a peg and next one is empty
    for(var i = 0; i < 4; i++) {
        var indexOfNeighbour = findPeg(surroundingPegs[i]);
        if(indexOfNeighbour != -1 && items.boardRepeater.itemAt(indexOfNeighbour).hasPeg) {
            var indexNextPeg = findPeg(nextSurroundingPegs[i]);
            if(indexNextPeg != -1 && !items.boardRepeater.itemAt(indexNextPeg).hasPeg) {
                canMove = true;
                break;
            }
        }
    }
    return canMove
}

function getSurroundingPegs(_pegXY) {
    return [
        [_pegXY[0] - 1, _pegXY[1]],
        [_pegXY[0] + 1, _pegXY[1]],
        [_pegXY[0], _pegXY[1] - 1],
        [_pegXY[0], _pegXY[1] + 1]
    ];
}

function getNextSurroundingPegs(_pegXY) {
    return [
        [_pegXY[0] - 2, _pegXY[1]],
        [_pegXY[0] + 2, _pegXY[1]],
        [_pegXY[0], _pegXY[1] - 2],
        [_pegXY[0], _pegXY[1] + 2]
    ];
}

function findPeg(_pegToFind) {
    return items.gameGrid.gridCoordinates.findIndex(peg => peg[0] === _pegToFind[0] && peg[1] === _pegToFind[1]);
}

function setCanMove(_itemIndex, _canMove) {
    var gridSlot = items.boardRepeater.itemAt(_itemIndex);
    if(gridSlot.canMove != _canMove) {
        gridSlot.canMove = _canMove;
        if(_canMove) {
            items.pegsWhichCanMove++;
        } else {
            items.pegsWhichCanMove--;
        }
    }
}

function resetCanReceive() {
    for(var i = 0; i < slotsWhichCanReceive.length; i++) {
        slotsWhichCanReceive[i].canReceive = false;
    }
    slotsWhichCanReceive = [];
}

function selectPeg(_clickedSlot) {
    items.inputBlocked = true;
    deselectPeg();
    resetDropTarget();
    selectedPeg = _clickedSlot;
    selectedPeg.isSelected = true;
    resetCanReceive();
    var surroundingPegs = getSurroundingPegs(_clickedSlot.modelData);
    var nextSurroundingPegs = getNextSurroundingPegs(_clickedSlot.modelData);
    // check on each direction if neighbour slot has a peg and next one is empty
    for(var i = 0; i < 4; i++) {
        var indexOfNeighbour = findPeg(surroundingPegs[i]);
        if(indexOfNeighbour != -1 && items.boardRepeater.itemAt(indexOfNeighbour).hasPeg) {
            var indexNextPeg = findPeg(nextSurroundingPegs[i]);
            if(indexNextPeg != -1 && !items.boardRepeater.itemAt(indexNextPeg).hasPeg) {
                items.boardRepeater.itemAt(indexNextPeg).canReceive = true;
                slotsWhichCanReceive.push(items.boardRepeater.itemAt(indexNextPeg));
            }
        }
    }
    items.inputBlocked = false;
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}
