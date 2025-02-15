/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

// 12 levels. 3 or 4 shapes with possible same colors and 2 sizes. Count : 9, 12
Data {
    objective: qsTr("Copy this frieze: 3 or 4 shapes with 2 sizes and potentially same colors/signs.")
    difficulty: 2
    data: [
        {   "title": qsTr("Copy this frieze."),
            "hidden": false,
            "shuffle": false,
            "shown": 20,
            "duplicate": false,
            "subLevels": [
                {
                    "count": 9,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 1, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 9,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 1, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 9,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 1, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 9,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 2, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 2, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 2, 2, 2 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 4, 4, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 2 ],
                        [ 2, 2, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 2, 3, 2 ],
                        [ 1, 4, 2 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 1, 1, 2 ],
                        [ 2, 1, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 1 ],
                        [ 1, 3, 1 ],
                        [ 1, 3, 2 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 1, 2 ],
                        [ 1, 2, 1 ],
                        [ 1, 2, 2 ]
                    ],
                    "patLength": 4
                }
            ]
        }
    ]
}
