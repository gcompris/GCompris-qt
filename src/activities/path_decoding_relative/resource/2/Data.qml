/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("%1x%2 grids.").arg(8).arg(8)
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
                ['B', '.', 'G', '.', '*', '*', '*', '.'],
                ['.', '*', '*', '*', '*', 'W', '*', 'G'],
                ['.', '*', 'T', '.', '.', '.', '*', '.'],
                ['.', '*', '*', 'W', 'B', '*', '*', 'W'],
                ['T', 'R', '*', '.', '.', '*', 'R', '.'],
                ['.', '*', '*', '.', 'G', '*', '*', '.'],
                ['G', '*', 'W', 'B', 'R', '.', '*', 'S'],
                ['.', 'E', '.', '.', '.', 'W', '.', '.'],
            ]
        },
        {
            path: [
                ['W', 'E', 'W', '*', '*', '*', 'W', 'T'],
                ['.', '*', '*', '*', '.', '*', '*', '*'],
                ['.', 'B', '.', 'B', 'R', '.', 'G', '*'],
                ['S', '.', 'G', '.', 'T', '.', '.', '*'],
                ['*', '.', '*', '*', '*', 'T', '*', '*'],
                ['*', '*', '*', 'R', '*', '.', '*', '.'],
                ['.', '.', '.', '.', '*', '*', '*', '.'],
                ['T', 'G', 'W', 'B', '.', '.', 'B', 'G'],
            ]
        }
    ]
}
