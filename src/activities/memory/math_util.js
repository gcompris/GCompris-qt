/* GCompris
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import "qrc:/gcompris/src/core/core.js" as Core

var cacheAdd = {};
function getAddTable(table) {
    var result = []
    if(cacheAdd[table]) {
        return cacheAdd[table];
    }
    for(var i = 1; i <= 10; ++i) {
        if(Math.floor(Math.random()*2))
            // The mathematical addition sign
            result.push(["" + table + " " + qsTr("+") + " " + i,
                         table + i])
        else
            result.push(["" + i + " " + qsTr("+") + " " + table,
                         table + i])
    }
    cacheAdd[table] = result;
    return result
}

var cacheMinus = {};
function getMinusTable(table) {
    if(cacheMinus[table]) {
        return cacheMinus[table];
    }
    var result = []
    for(var i = 1; i <= 10; ++i) {
        // The mathematical subtraction sign
        result.push(["" + (i + table) + " " + qsTr("−") + " " + table,
                      i])
    }
    cacheMinus[table] = result;
    return result
}

var cacheMult = {};
function getMultTable(table) {
    if(cacheMult[table]) {
        return cacheMult[table];
    }
    var result = []
    for(var i = 1; i <= 10; ++i) {
        if(Math.floor(Math.random()*2))
            // The mathematical multiplication sign
            result.push(["" + table + " " + qsTr("×") + " " + i,
                         table * i])
        else
            result.push(["" + i + " " + qsTr("×") + " " + table,
                         table * i])
    }
    cacheMult[table] = result;
    return result
}

var cacheDiv = {};
function getDivTable(table) {
    if(cacheDiv[table]) {
        return cacheDiv[table];
    }
    var result = []
    for(var i = 1; i <= 10; ++i) {
        // The mathematical division sign
        result.push(["" + i * table + " " + qsTr("÷") + " " + table,
                     i])
    }
    cacheDiv[table] = result;
    return result
}

function removeDuplicates(tAll) {
    Core.shuffle(tAll)
    var result = []
    // Remove duplicate values with the same result
    const len = tAll.length;
    for(var i = 0; i < len; ++i) {
        var gotIt = false
        const resultLen = result.length;
        const line = tAll[i];
        for(var j = 0; j < resultLen; ++j) {
            if(line[1] === result[j][1]) {
                gotIt = true;
                break;
            }
        }
        if(!gotIt)
            result.push(line);
    }
    return result
}

function getAddMinusTable(table) {
    var t1 = getAddTable(table)
    var t2 = getMinusTable(table)
    return removeDuplicates(t1.concat(t2))
}

function getAddMinusMultDivTable(table) {
    var t1 = getAddTable(table)
    var t2 = getMinusTable(table)
    var t3 = getMultTable(table)
    var t4 = getDivTable(table)
    return removeDuplicates(t1.concat(t2, t3, t4))
}

function getMultDivTable(table) {
    var t1 = getMultTable(table)
    var t2 = getDivTable(table)
    return removeDuplicates(t1.concat(t2))
}

