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
    objective: qsTr("10 rows, 10 cols, 43 length")
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
                ['G', '.', 'W', '*', '*', '*', '.', '.', 'W', 'W'],
                ['.', '*', '*', '*', 'R', '*', 'W', '*', '*', '*'],
                ['G', '*', 'R', 'W', '.', '*', '.', '*', 'B', '*'],
                ['*', '*', '.', '.', 'G', '*', '*', '*', '.', '*'],
                ['*', 'G', 'W', '.', '.', '.', 'B', '.', 'T', '*'],
                ['*', '*', '.', 'B', '*', '*', '*', '.', '*', '*'],
                ['B', '*', '.', '*', '*', '.', '*', '*', '*', '.'],
                ['.', '*', 'T', '*', '.', 'T', '.', '.', 'R', '.'],
                ['S', '*', '.', '*', '*', '*', '*', '.', '.', '.'],
                ['.', '.', 'G', '.', 'W', '.', 'E', '.', 'B', '.'],
            ]
        }
    ]
}
