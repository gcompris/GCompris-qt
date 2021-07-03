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
    objective: qsTr("10 rows, 10 cols, 38 length")
    difficulty: 4
    data: [
        {
            rows: 10,
            cols: 10,
            
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
