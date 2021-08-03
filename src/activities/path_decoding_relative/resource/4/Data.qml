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
    objective: qsTr("%1x%2 grids.").arg(12).arg(12)
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
                ['I', '.', '.', 'B', 'G', '.', 'I', 'I', '.', '.', 'G', 'I'],
                ['I', '*', '*', '*', '*', '*', 'I', '*', '*', '*', '.', 'I'],
                ['.', '*', 'T', 'T', '.', '*', '*', '*', '.', '*', '*', '.'],
                ['B', '*', '*', '.', '.', 'B', '.', '.', '.', 'T', '*', '*'],
                ['.', '.', '*', 'W', 'W', '.', '*', '*', '*', '*', 'T', '*'],
                ['*', '*', '*', '.', 'T', 'T', '*', 'B', 'W', '*', '.', '*'],
                ['*', '.', 'R', '.', '.', '.', '*', '*', '.', '*', '*', '*'],
                ['*', '*', '.', '*', '*', '*', 'T', '*', '.', 'B', '.', '.'],
                ['T', '*', 'W', '*', '.', '*', '.', '*', '.', '.', 'R', '.'],
                ['*', '*', '.', '*', 'B', '*', 'W', '*', '*', '*', '.', '.'],
                ['*', 'T', '*', '*', '.', '*', '.', '.', '.', '*', 'W', 'I'],
                ['*', '*', '*', 'I', 'I', 'E', 'W', 'I', 'I', 'S', 'W', 'I'],
            ]
        }
    ]
}
