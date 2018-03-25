/* GCompris
 *
 * Copyright (C) 2014 Bruno Coudoin
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

.import "qrc:/gcompris/src/core/core.js" as Core

function getAddTable(table) {
    var result = []
    for(var i = 1; i <= 10; ++i) {
        if(Math.floor(Math.random()*2))
            // The mathematical addition sign
            result.push(["" + table + " " + qsTr("+") + " " + i,
                         table + i])
        else
            result.push(["" + i + " " + qsTr("+") + " " + table,
                         table + i])
    }
    return result
}

function getMinusTable(table) {
    var result = []
    for(var i = 1; i <= 10; ++i) {
        // The mathematical subtraction sign
        result.push(["" + (i + table) + " " + qsTr("−") + " " + table,
                      i])
    }
    return result
}

function getMultTable(table) {
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
    return result
}

function getDivTable(table) {
    var result = []
    for(var i = 1; i <= 10; ++i) {
        // The mathematical division sign
        result.push(["" + i * table + " " + qsTr("÷") + " " + table,
                     i])
    }
    return result
}

function removeDuplicates(tAll) {
    Core.shuffle(tAll)
    var result = []
    // Remove duplicate values with the same result
    for(var i = 0; i < tAll.length; ++i) {
        var gotIt = false
        for(var j = 0; j < result.length; ++j) {
            if(tAll[i][1] === result[j][1])
                gotIt = 1
        }
        if(!gotIt)
            result.push(tAll[i])
    }
    return result
}

function getAddMinusTable(table) {
    var t1 = getAddTable(table)
    var t2 = getMinusTable(table)
    return removeDuplicates(t1.concat(t2))
}

function getAddMinusMultTable(table) {
    var t1 = getAddTable(table)
    var t2 = getMinusTable(table)
    var t3 = getMultTable(table)
    return removeDuplicates(t1.concat(t2, t3))
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

