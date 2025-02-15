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

// 10 levels. Any combination of shapes, colors and sizes. Count : 12, 15
Data {
    objective: qsTr("Copy this frieze: patterns between 12 and 15, any combination of shapes, colors/signs and sizes.")
    difficulty: 3
    data: [
        {   "title": qsTr("Copy this frieze."),
            "hidden": false,
            "shown": 20,
            "shuffle": false,
            "duplicate": true,
            "subLevels": [
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 1, 1 ],
                        [ 3, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 3, 1, 2 ],
                        [ 4, 1, 1 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 3, 2, 2 ],
                        [ 4, 2, 2 ],
                        [ 2, 1, 1 ],
                        [ 3, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 4, 2, 1 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 1 ],
                        [ 2, 2, 1 ],
                        [ 3, 1, 1 ],
                        [ 3, 2, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 1, 1 ],
                        [ 3, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 3, 1, 2 ],
                        [ 4, 1, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 3, 2, 2 ],
                        [ 4, 2, 2 ],
                        [ 2, 1, 1 ],
                        [ 3, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 4, 2, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 3, 2, 2 ],
                        [ 4, 2, 2 ],
                        [ 4, 1, 2 ],
                        [ 2, 1, 1 ],
                        [ 3, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 4, 2, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 12,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 1, 2 ],
                        [ 1, 2, 1 ],
                        [ 1, 2, 2 ],
                        [ 2, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 2, 2, 1 ],
                        [ 2, 2, 2 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 15,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 3, 2, 2 ],
                        [ 4, 2, 2 ],
                        [ 4, 1, 2 ],
                        [ 2, 1, 1 ],
                        [ 3, 2, 1 ],
                        [ 2, 2, 2 ],
                        [ 4, 2, 1 ]
                    ],
                    "patLength": 5
                },
                {
                    "count": 15,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 1, 2 ],
                        [ 1, 2, 1 ],
                        [ 1, 2, 2 ],
                        [ 2, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 2, 2, 1 ],
                        [ 2, 2, 2 ]
                    ],
                    "patLength": 5
                }
            ]
        }
    ]
}
