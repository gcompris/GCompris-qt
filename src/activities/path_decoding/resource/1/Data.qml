/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("%1x%2 grids.").arg(6).arg(6)
    difficulty: 4
    data: [
        /*
            Symbols used:
            * -> path
            . -> empty
            S -> starting point
            E -> ending point
            I -> invisible tile
            R -> rock
            T -> tree
            B -> bush
            G -> grass
            W -> water

            Note: Make sure you have a unique path.
        */
        {
            path: [
                ['B', 'T', '*', '*', '*', 'T'],
                ['.', '*', '*', 'R', '*', '*'],
                ['.', '*', 'G', '.', '.', '*'],
                ['S', '*', '.', 'W', 'B', '*'],
                ['.', 'R', '.', '.', 'T', '*'],
                ['.', '.', 'W', '.', '.', 'E'],
            ]
        },
        {
            path: [
                ['.', 'R', '*', '*', '*', 'E'],
                ['.', '*', '*', 'G', '.', '.'],
                ['R', '*', '.', '.', '*', 'S'],
                ['T', '*', 'B', '*', '*', '.'],
                ['.', '*', '*', '*', 'W', '.'],
                ['W', '.', '.', '.', 'G', '.'],
            ]
        }
    ]
}
