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
.import QtQuick 2.0 as Quick
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

function initEditor(_props)
{
    props = _props;
    console.log("init editor");

    currentLevel = 0;
    numberOfLevel = 0;
    props.lastBallIndex = -1;
    props.lastGoalIndex = -1;
console.log("XXX loaded levels form file " + props.editor.filename);
    levels = [];
    if (props.file.exists(props.editor.filename)) {
        levels = props.parser.parseFromUrl(props.editor.filename, validateLevels);
        if (levels == null) {
            console.error("BalanceboxEditor: Error loading levels from "
                          + props.editor.filename);
            levels = [];  // restart with an empty level-set
        } else
            console.log("XXX loaded levels form file " + props.editor.filename);
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
    //console.log("XXX editor initLevel levels=" + JSON.stringify(levels));
    if (currentLevel >= numberOfLevel) {
        levels.push(createEmptyLevel());
        numberOfLevel++;
        currentIsNewLevel = true;
    } else
        currentIsNewLevel = false;

    level = levels[currentLevel];
    props.bar.level = currentLevel + 1
    props.lastBallIndex = -1;
    props.lastGoalIndex = -1;

    props.mapModel.clear();
    levelChanged = false;
    for (var row = 0; row < level.map.length; row++) {
        for (var col = 0; col < level.map[row].length; col++) {
            var contactValue = "";
            var value = parseInt(level.map[row][col]);  // always enforce number
            var orderNum = (value & 0xFF00) >> 8;
            if (orderNum > 0 && level.targets[orderNum - 1] === undefined) {
                console.error("Invalid level: orderNum " + orderNum
                              + " without target value!");
            } else if (orderNum > 0) {
                if (orderNum > props.lastOrderNum)
                    props.lastOrderNum = orderNum;
                contactValue = Number(level.targets[orderNum-1]).toString();
                if (contactValue > parseInt(props.contactValue) + 1)
                    props.contactValue = Number(parseInt(contactValue) + 1).toString();
            }
            props.mapModel.append({
                "row": row,
                "col": col,
                "value": value,
                "orn": orderNum,
                "contactValue": orderNum > 0 ? contactValue : ""
            });
            if (value & GOAL) {
                if (props.lastGoalIndex > -1) {
                    console.error("Invalid level: multiple goal locations: row/col="
                                  + row + "/" + col);
                    return;
                }
                props.lastGoalIndex = row * level.map.length + col;
            }
            if (value & START) {
                if (props.lastBallIndex > -1) {
                    console.error("Invalid level: multiple start locations: row/col="
                                  + row + "/" + col);
                    return;
                }
                props.lastBallIndex = row * level.map.length + col;
            }
        }
    }
}

function dec2hex(i) {
   return (i+0x10000).toString(16).substr(-4).toUpperCase();
}

function modelToLevel()
{
    var map = new Array();
    var targets = new Array();
    for (var i = 0; i < props.mapModel.count; i++) {
        var row = Math.floor(i / props.columns);
        var col = i % props.columns;
        if (col === 0) {
            map[row] = new Array();
        }

        var obj = props.mapModel.get(i);
        var value = obj.value;
        if (obj.orn > 0) {
            value |= (obj.orn << 8);
            targets[obj.orn-1] = obj.contactValue;
        }
        map[row][col] = "0x" + dec2hex(value);
    }
    var level = {
                    level: currentLevel + 1,
                    map: map,
                    targets: targets
                }
    //console.log("XXX level: " + JSON.stringify(level) + " - " + map);
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
            console.debug("Created path " + path);
    }
    levels[currentLevel] = l
    if (!props.file.write(JSON.stringify(levels), userFile))
        console.error("BalanceboxEditor: Error saving levels to " + userFile);
    else {
        //console.debug("BalanceboxEditor: Saved " + numberOfLevel + " levels in " + userFile);
        Core.showMessageDialog(props.editor,
                               qsTr("Saved %1 levels to user levels file.")
                               .arg(numberOfLevel).arg(userFile),
                               "", null, "", null, null);
        levelChanged = false;
    }
}

function modifyMap(props, row, col)
{
    //console.log("XXX modify map currentTool='" + props.currentTool + "'");
    var modelIndex = row * level.map.length + col;
    var obj = props.mapModel.get(modelIndex);
    var oldValue = obj.value;
    var newValue = oldValue;

    if (props.currentTool === TOOL_CLEAR) {
        newValue = 0;
        props.mapModel.setProperty(row * level.map.length + col,
                                   "contactValue", 0)
        props.mapModel.setProperty(row * level.map.length + col,
                                   "orn", 0)
    } else { // all other tools

        // special treatment for mutually exclusive ones:
        if (props.currentTool === TOOL_HOLE
                || props.currentTool === TOOL_GOAL
                || props.currentTool === TOOL_CONTACT
                || props.currentTool === TOOL_BALL) {
            // helper:
            var MUTEX_MASK = (START | GOAL | HOLE | CONTACT) ^ props.currentTool;
            props.mapModel.setProperty(row * level.map.length + col,
                                       "orn", 0)
            newValue &= ~MUTEX_MASK;
        }

        // special treatment for singletons:
        if (props.currentTool === TOOL_GOAL) {
            console.log("GGGoal " + (obj.value & TOOL_GOAL));
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
            props.mapModel.setProperty(row * level.map.length + col, "orn", ++props.lastOrderNum);
            props.mapModel.setProperty(row * level.map.length + col, "contactValue", props.contactValue);
            var newContact =  Number(Number(props.contactValue) + 1).toString()
            props.contactValue = newContact;
        }

        // update value by current tool bit:
        newValue ^= props.currentTool;
    }

    if (oldValue !== newValue)
        levelChanged = true;
    console.log("XXX value=" + obj.value + " typeof=" + typeof(obj.value) + " newValue=" + newValue + " typeof=" + typeof(newValue));
    props.mapModel.setProperty(modelIndex, "value", newValue);
}

function warnUnsavedChanges(yesFunc, noFunc)
{
    Core.showMessageDialog(props.editor,
            qsTr("You have unsaved changes!<br/> " +
                 " Really switch to another level and loose changes?"),
                  qsTr("Yes"), yesFunc,
                  qsTr("No"), noFunc,
                  noFunc);
}

function nextLevel() {
    if(numberOfLevel === currentLevel + 1
            && !levelChanged && currentIsNewLevel ) {
        console.log("BalanceboxEditor: Current level is new and unchanged, nogo!");
        return;
    }

    currentLevel++;
    initLevel();
}

function previousLevel() {
    if (currentLevel === 0)
        return;
    currentLevel--;
    initLevel();
}
