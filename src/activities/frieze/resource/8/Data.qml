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

// 10 levels. Any combination of shapes,colors and sizes. Count : 10, 12
Data {
    objective: qsTr("Copy and complete this frieze: patterns between 10 and 12, any combination of shapes, colors/signs and sizes.")
    difficulty: 3
    data: [
        {   "title": qsTr("Copy and complete this frieze."),
            "hidden": false,
            "shown": 6,
            "shuffle": false,
            "duplicate": true,
            "subLevels": [
                {
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 1 ],
                        [ 2, 2, 1 ],
                        [ 3, 1, 1 ],
                        [ 3, 2, 1 ]
                    ],
                    "patLength": 3
                },
                {
                    "count": 10,
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
                    "count": 10,
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
                    "count": 10,
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
                    "count": 10,
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
                    "count": 10,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 2 ],
                        [ 1, 3, 2 ],
                        [ 1, 4, 1 ],
                        [ 1, 1, 2 ],
                        [ 1, 3, 2 ],
                        [ 1, 2, 1 ]
                    ],
                    "patLength": 4
                },
                {
                    "count": 10,
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
                    "patLength": 5
                },
                {
                    "count": 10,
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
                },
                {
                    "count": 12,
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
                    "patLength": 5
                }
            ]
        }
    ]
}
