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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

.import "qrc:/gcompris/src/activities/memory/math_util.js" as Memory

var memory_cards = [
            { // Level 1
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(1)
            },
            { // Level 2
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(2)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(3)
            },
            { // Level 4
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(4)
            },
            { // Level 5
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(5)
            },
            { // Level 6
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(6)
            },
            { // Level 7
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(7)
            },
            { // Level 8
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(8)
            },
            { // Level 9
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(9)
            },
            { // Level 10
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultTable(10)
            }
        ]


function get() {
    return memory_cards
}
