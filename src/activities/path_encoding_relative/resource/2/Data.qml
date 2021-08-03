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
                ['B', '.', '*', 'S', '.', '.', 'W', '.'],
                ['.', '*', '*', '.', '.', 'W', '.', '.'],
                ['*', '*', 'T', '.', '.', '.', '*', 'E'],
                ['*', '.', '.', '.', 'B', '*', '*', '.'],
                ['*', 'G', 'B', '.', '.', '*', '.', '.'],
                ['*', '*', '.', '*', '*', '*', '.', '.'],
                ['.', '*', '*', '*', 'R', '.', 'B', '.'],
                ['.', '.', '.', 'G', 'W', '.', '.', '.'],
            ]
        },
        {
            path: [
                ['W', '*', '*', '*', '.', '.', '.', '.'],
                ['.', '*', 'B', '*', '*', 'W', '.', '.'],
                ['.', '*', 'R', '.', '*', '*', 'G', 'R'],
                ['.', '*', '*', '.', 'T', '*', '.', '.'],
                ['.', 'W', '*', '.', '.', '*', '*', '*'],
                ['B', '*', '*', 'R', '.', '.', '.', '*'],
                ['S', '*', '.', '.', '.', 'G', '*', '*'],
                ['.', '.', '.', 'B', '.', '.', 'E', 'T'],
            ]
        }
    ]
}
