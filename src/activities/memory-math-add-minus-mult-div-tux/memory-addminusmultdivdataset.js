/* GCompris
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.import "qrc:/gcompris/src/activities/memory/math_util.js" as Memory

var memory_cards = [
            { // Level 1
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(1)
            },
            { // Level 2
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(2)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(3)
            },
            { // Level 4
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(4)
            },
            { // Level 5
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(5)
            },
            { // Level 6
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(6)
            },
            { // Level 7
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(7)
            },
            { // Level 8
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(8)
            },
            { // Level 9
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(9)
            },
            { // Level 10
                columns: 5,
                rows: 2,
                texts: Memory.getAddMinusMultDivTable(10)
            }
        ]


function get() {
    return memory_cards
}
