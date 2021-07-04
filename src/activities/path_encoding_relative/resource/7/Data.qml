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
    objective: qsTr("12 rows, 12 cols, 46 length.")
    difficulty: 4
    data: [
        {
            rows: 12,
            cols: 12,
            
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
                ['I', '.', '.', 'B', '.', '.', 'I', 'I', '.', 'E', '.', 'I'],
                ['I', '*', '*', '*', '*', '.', 'I', 'I', '.', '*', '.', 'I'],
                ['.', '*', '.', 'T', '*', 'R', '.', '.', '.', '*', '*', '.'],
                ['.', '*', '*', '.', '*', '.', '.', '.', '.', '.', '*', '.'],
                ['.', '.', '*', 'W', '*', '*', '*', 'W', '.', '.', '*', '.'],
                ['*', '*', '*', '.', '.', 'T', '*', 'B', 'W', '.', '*', 'B'],
                ['*', '.', 'R', '.', '*', '*', '*', '.', '*', '*', '*', '.'],
                ['*', '*', '.', '.', '*', 'T', '.', '*', '*', '.', '.', '.'],
                ['.', '*', '.', 'T', '*', '.', '.', '*', '.', '.', 'R', '.'],
                ['.', '*', '*', '.', '*', '*', '*', '*', 'B', '.', '.', '.'],
                ['I', '.', '*', '.', 'I', 'R', '.', '.', '.', 'I', 'W', 'I'],
                ['I', '.', 'S', 'I', 'I', '.', 'I', 'I', 'I', 'I', 'W', 'I'],
            ]
        }
    ]
}
