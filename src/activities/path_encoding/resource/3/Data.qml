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
                ['.', '*', '*', '*', '*', '.', '*', '*', '*', '.'],
                ['R', '*', 'B', '.', '*', 'R', '*', 'B', '*', '.'],
                ['*', '*', '.', '*', '*', '.', '*', 'G', '*', 'W'],
                ['*', 'W', '.', '*', '.', '.', '*', '.', '*', 'S'],
                ['*', 'W', '.', '*', '*', '.', '*', '*', '.', '.'],
                ['*', '*', '.', 'B', '*', 'G', '.', '*', '.', '.'],
                ['.', '*', 'G', '.', '*', '.', '.', '*', '.', '.'],
                ['B', '*', '.', 'R', '*', '*', '*', '*', '.', '.'],
                ['.', '*', '.', '.', '.', '.', '.', '.', '.', 'R'],
                ['.', 'E', '.', '.', '.', 'W', '.', 'G', '.', '.'],
            ]
        },
        {
            path: [
                ['G', 'E', '.', '*', '*', '*', '*', '*', 'W', 'W'],
                ['.', '*', '.', '*', 'R', 'B', '.', '*', 'W', 'W'],
                ['G', '*', 'R', '*', '.', '.', '.', '*', 'T', 'T'],
                ['.', '*', '*', '*', '.', '*', '*', '*', 'T', 'T'],
                ['.', 'G', '.', 'B', '.', '*', 'B', '.', 'T', 'T'],
                ['.', '.', '.', '.', '.', '*', '*', '.', '.', '.'],
                ['*', '*', '*', '*', '*', '.', '*', 'B', '.', '.'],
                ['*', 'R', '.', '.', '*', '.', '*', '.', 'R', '.'],
                ['*', '*', '*', 'G', '*', '.', '*', '.', '.', '.'],
                ['.', '.', 'S', '.', '*', '*', '*', '.', 'B', '.'],
            ]
        }
    ]
}
