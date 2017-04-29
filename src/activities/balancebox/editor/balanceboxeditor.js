/* GCompris - balanceboxeditor.js
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

Qt.include("../balancebox_common.js")

var TOOL_CLEAR = EMPTY
var TOOL_H_WALL = SOUTH
var TOOL_V_WALL = EAST
var TOOL_HOLE = HOLE
var TOOL_CONTACT = CONTACT
var TOOL_GOAL = GOAL
var TOOL_BALL = START

var levels;
var level;
var currentLevel;
var numberOfLevel;
var levelChanged = false;  // whether current level has unsaved changes
var props;
var currentIsNewLevel;
var targetList = [];

function initEditor(_props)
{
    props = _props;
    console.log("init editor");

    currentLevel = 0;
    numberOfLevel = 0;
    props.lastBallIndex = -1;
    props.lastGoalIndex = -1;
    levels = [];
    if (props.file.exists(props.editor.filename)) {
        levels = props.parser.parseFromUrl(props.editor.filename, validateLevels);
        if (levels == null) {
            console.error("BalanceboxEditor: Error loading levels from "
                          + props.editor.filename);
            levels = [];  // restart with an empty level-set
        }
    }
    numberOfLevel = levels.length;

    initLevel();
}

function createEmptyLevel()
{
    var map = [];
    var num = currentLevel + 1;
    for (var row = 0; row < props.rows; row++)
        for (var col = 0; col < props.columns; col++) {
            if (col === 0)
                map[row] = [];
            map[row][col] = 0;
        }
    return {
        level: currentLevel + 1,
        map: map,
        targets: []
    };
}

function initLevel()
{
    props.editor.testBox.loading.start();
    if (currentLevel >= numberOfLevel) {
        levels.push(createEmptyLevel());
        levelChanged = false;
        numberOfLevel++;
        currentIsNewLevel = true;
    } else
        currentIsNewLevel = false;

    level = levels[currentLevel];
    props.bar.level = currentLevel + 1;
    // populate model in the worker-thread:
    props.editorWorker.sendMessage({
                                       lastBallIndex: props.lastBallIndex,
                                       lastGoalIndex: props.lastGoalIndex,
                                       lastOrderNum:  props.lastOrderNum,
                                       mapModel: props.mapModel,
                                       targetList: targetList,
                                       level: level
                                   });
}

function dec2hex(i) {
   return (i+0x10000).toString(16).substr(-4).toUpperCase();
}

function modelToLevel()
{
    var map = new Array();
    var targets = new Array();
    targetList.sort(function(a,b) { return a - b;})
    for (var i = 0; i < props.mapModel.count; i++) {
        var row = Math.floor(i / props.columns);
        var col = i % props.columns;
        if (col === 0) {
            map[row] = new Array();
        }

        var obj = props.mapModel.get(i);
        var value = obj.value;
        value &= ~(0xff00);  // always clear order-number bits
        if (obj.value & CONTACT) {
            value |= ((targetList.indexOf(parseInt(obj.contactValue)) + 1) << 8);
        }
        map[row][col] = "0x" + dec2hex(value);
    }
    var level = {
                    level: currentLevel + 1,
                    map: map,
                    targets: targetList
                }
    return level;
}

function saveModel()
{
    var l = modelToLevel();
    var path = userFile.substring(0, userFile.lastIndexOf("/"));
    if (!props.file.exists(path)) {
        if (!props.file.mkpath(path))
            console.error("Could not create directory " + path);
        else
            console.debug("Created directory " + path);
    }
    levels[currentLevel] = l;
    // renumber levels before saving:
    for(var i = 0; i < levels.length; i++)
        levels[i].level = i + 1;
    if (!props.file.write(JSON.stringify(levels), userFile))
        Core.showMessageDialog(props.editor,
                               //~ singular Error saving %n level to your levels file (%1)
                               //~ plural Error saving %n levels to your levels file (%1)
                               qsTr("Error saving %n level(s) to your levels file (%1)", "", numberOfLevel)
                               .arg(userFile),
                               "", null, "", null, null);
    else {
        Core.showMessageDialog(props.editor,
                               //~ singular Saved %n level to your levels file (%1)
                               //~ plural Saved %n levels to your levels file (%1)
                               qsTr("Saved %n level(s) to your levels file (%1)", "", numberOfLevel)
                               .arg(userFile),
                               "", null, "", null, null);
        levelChanged = false;
        currentIsNewLevel = false;
    }
}

function modifyMap(props, row, col)
{
    var modelIndex = row * level.map.length + col;
    var obj = props.mapModel.get(modelIndex);
    var oldValue = obj.value;
    var newValue = oldValue;

    // contact-tool: check for already existing value early
    if (props.currentTool === TOOL_CONTACT        // have contact tool and ...
            && targetList.indexOf(parseInt(props.contactValue)) !== -1  // already have this contact value ...
            && !(obj.value & TOOL_CONTACT                               // which is not set at the same cell
                 && obj.contactValue === props.contactValue))
    {
        console.debug("Avoiding to set duplicate contact value " + props.contactValue
                      + " current targets=" + JSON.stringify(targetList));
        return;
    }

    if (props.currentTool === TOOL_CLEAR) {
        newValue = 0;
        // remove contact stuff:
        if (obj.value & TOOL_CONTACT) {
            if (targetList.indexOf(parseInt(obj.contactValue)) !== -1)
                targetList.splice(targetList.indexOf(parseInt(obj.contactValue)), 1);
            props.mapModel.setProperty(row * level.map.length + col,
                                       "contactValue", "");
        }
    } else { // all other tools

        // special treatment for mutually exclusive ones:
        if (props.currentTool === TOOL_HOLE
                || props.currentTool === TOOL_GOAL
                || props.currentTool === TOOL_CONTACT
                || props.currentTool === TOOL_BALL) {
            // helper:
            var MUTEX_MASK = (START | GOAL | HOLE | CONTACT) ^ props.currentTool;
            newValue &= ~MUTEX_MASK;
        }

        // special treatment for singletons:
        if (props.currentTool === TOOL_GOAL) {
            if ((obj.value & TOOL_GOAL) === 0) {
                // setting a new one
                if (props.lastGoalIndex > -1) {
                    // clear last one first:
                    props.mapModel.setProperty(props.lastGoalIndex, "value",
                                               props.mapModel.get(props.lastGoalIndex).value &
                                               (~TOOL_GOAL));
                }
                // now memorize the new one:
                props.lastGoalIndex = modelIndex;
            }
        } else
            if (props.currentTool === TOOL_BALL) {
                if ((obj.value & TOOL_BALL) === 0) {
                    // setting a new one
                    if (props.lastBallIndex > -1)
                        // clear last one first:
                        props.mapModel.setProperty(props.lastBallIndex, "value",
                                                   props.mapModel.get(props.lastBallIndex).value & (~TOOL_BALL));
                    // now memorize the new one:
                    props.lastBallIndex = modelIndex;
                }
            }

        // special treatment for contacts:
        if (props.currentTool === TOOL_CONTACT) {
            if (obj.value & TOOL_CONTACT &&                     // have old contact value ...
                    obj.contactValue === props.contactValue) {  // ... which is == the new one
                // clear contact
                if (targetList.indexOf(parseInt(obj.contactValue)) !== -1)
                    targetList.splice(targetList.indexOf(parseInt(obj.contactValue)), 1);
                props.mapModel.setProperty(row * level.map.length + col,
                                           "contactValue", "");
                newValue &= ~(CONTACT);
            } else {
                if (obj.value & TOOL_CONTACT) {              // have old contact that is different
                    if (targetList.indexOf(parseInt(obj.contactValue)) !== -1)
                        targetList.splice(targetList.indexOf(parseInt(obj.contactValue)), 1);
                    // no change to newValue
                }
                // -> set new one:
                if (targetList.indexOf(parseInt(props.contactValue)) === -1)
                    targetList.push(parseInt(props.contactValue));
                props.mapModel.setProperty(row * level.map.length + col,
                                           "contactValue", props.contactValue);
                props.contactValue = Number(Number(props.contactValue) + 1).toString();
                newValue |= CONTACT;
            }
        } else {
            // for other than contact-tool: update value by current tool bit:
            newValue ^= props.currentTool;
        }
    }

    if (oldValue !== newValue)
        levelChanged = true;
    props.mapModel.setProperty(modelIndex, "value", newValue);
}

var warningVisible = false;
function warnUnsavedChanges(yesFunc, noFunc)
{
    if (!warningVisible) {
        warningVisible = true;
        Core.showMessageDialog(props.editor,
                               qsTr("You have unsaved changes!<br/> " +
                                    "Really leave this level and lose changes?"),
                               qsTr("Yes"), function() {
                                   warningVisible = false;
                                   if (yesFunc !== undefined)
                                       yesFunc();
                               },
                               qsTr("No"), function() {
                                   warningVisible = false;
                                   if (noFunc !== undefined)
                                       noFunc();
                               },
                               function() {
                                   warningVisible = false;
                                   if (noFunc !== undefined)
                                       noFunc();
                               });
    }
}

function nextLevel() {
    if(numberOfLevel === currentLevel + 1
            && !levelChanged && currentIsNewLevel ) {
        console.log("BalanceboxEditor: Current level is new and unchanged, nogo!");
        return;
    }

    currentLevel++;
    levelChanged = false;
    initLevel();
}

function previousLevel() {
    if (currentLevel === 0)
        return;
    currentLevel--;
    levelChanged = false;
    initLevel();
}
