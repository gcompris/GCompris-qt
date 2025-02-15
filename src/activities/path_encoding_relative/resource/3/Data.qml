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
    objective: qsTr("%1x%2 grids.").arg(10).arg(10)
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
                ['W', '*', '*', '*', '*', '.', '*', '*', '*', '.'],
                ['*', '*', 'B', '.', '*', 'R', '*', 'B', '*', '.'],
                ['*', 'T', '.', '.', '*', '*', '*', 'G', '*', 'W'],
                ['*', '*', '*', '*', '.', '.', '.', '*', '*', '.'],
                ['.', 'W', '.', '*', 'T', '.', '.', '*', '.', '.'],
                ['.', '.', '.', '*', '.', 'G', 'G', '*', '.', '.'],
                ['.', '*', '*', '*', '.', '.', '.', '*', '.', '.'],
                ['B', '*', '.', 'R', '.', '*', '*', '*', 'B', '.'],
                ['.', '*', '.', '.', '.', '*', '.', '.', '.', 'R'],
                ['.', 'S', '.', 'B', '.', 'E', '.', 'G', '.', '.'],
            ]
        },
        {
            path: [
                ['G', 'S', '.', '*', '*', '*', '.', '.', 'W', 'W'],
                ['.', '*', '.', '*', 'R', '*', '.', '*', '*', '*'],
                ['G', '*', 'R', '*', '.', '*', '.', '*', 'B', '*'],
                ['.', '*', '*', '*', '.', '*', '*', '*', '.', '*'],
                ['.', 'G', '.', 'B', '.', '.', 'B', '.', 'T', '*'],
                ['.', '.', '.', '.', 'W', 'W', '.', '.', '*', '*'],
                ['B', '.', '*', '*', '*', '.', '*', '*', '*', '.'],
                ['.', 'R', '*', '.', '*', '.', '*', '.', 'R', '.'],
                ['.', '*', '*', 'G', '*', '.', '*', '.', '.', '.'],
                ['.', 'E', '.', '.', '*', '*', '*', '.', 'B', '.'],
            ]
        }
    ]
}
