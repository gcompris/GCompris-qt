/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Syntax:
 *   hidden: bool, hide tokens when ready
 *   shown: number of tokens shown. Greater than count shows all token.
 *   A token is made of 3 values: [ shape index, color index, size index ]
 *   Shapes and colors arrays are shuffled each time.
 *     Shapes 1, 2... will be a different shape each time.
 *     Idem for colors 1, 2...
 *     Size: 1 = big, 2 = small
 *   Index set to zero is reserved for future use.
 *  patLength : sequence's length of tokens repeated until count is reached.
 *  count : numbers of tokens to find
 *  duplicate : no repeated token when false (low difficulty)
 *    Values are tokens'indexes in tokens array
 * The number of tokens must be at least equal to patLength.
 */
import core 1.0

// 10 levels. 2 shapes with different colors and 1 size. Count : 8, 10, 12
Data {
    objective: qsTr("Copy this frieze: 2 shapes with different colors/signs.")
    difficulty: 1
    data: [
        {   "title": qsTr("Copy this frieze."),
            "hidden": false,
            "shuffle": false,
            "shown": 20,
            "duplicate": false,
            "subLevels": [
                {
                    "count": 8,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 8,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 8,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 8,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 2
                }
            ]
        }
    ]
}
