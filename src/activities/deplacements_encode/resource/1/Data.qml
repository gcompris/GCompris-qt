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
    objective: qsTr("Easy Maze.")
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
                
                Note: Make sure you have a unique path.
            */
            
            path: [
                ['.', '.', 'S', '.', '.', '.'],
                ['.', '.', '*', '*', '.', '.'],
                ['.', '.', '.', '*', '.', '.'],
                ['.', '.', '*', '*', '.', '.'],
                ['.', '*', '*', '.', '.', '.'],
                ['.', '*', '.', '.', '.', '.'],
            ]
        }
    ]
}
