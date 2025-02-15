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

// 10 levels. 2 shapes with different colors and 1 size. Count : 8, 10, 12
Data {
    objective: qsTr("Copy and complete this frieze: 2 shapes with different colors/signs.")
    difficulty: 1
    data: [
        {   "title": qsTr("Copy and complete this frieze."),
            "hidden": false,
            "shuffle": false,
            "shown": 4,
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
