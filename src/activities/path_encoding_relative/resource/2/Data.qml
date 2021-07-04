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
    objective: qsTr("6 rows, 6 cols, 14 length.")
    difficulty: 4
    data: [
        {
            rows: 6,
            cols: 6,
            
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
                ['.', 'R', '*', '*', '*', '.'],
                ['.', '.', '*', '.', '*', '.'],
                ['E', '*', '*', '.', '*', 'B'],
                ['T', '*', 'B', '*', '*', '.'],
                ['.', '*', '.', '*', 'W', '.'],
                ['.', 'S', '.', 'E', 'G', '.'],
            ]
        }
    ]
}
