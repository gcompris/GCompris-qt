/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Remember and copy this frieze: patterns between 4 and 7, any combination of shapes, colors/signs and sizes.")
    difficulty: 5
    data: [
        {   "title": qsTr("Remember and copy this frieze."),
            "hidden": true,
            "shuffle": true,
            "shown": 20,
            "subLevels": [
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 4, 1, 2 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 4, 4, 1 ]
                    ],

                    "patLength": 4
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 1, 1, 2 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 4, 4, 1 ]
                    ],

                    "patLength": 5
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 4, 1, 2 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 2 ],
                        [ 2, 1, 1 ],
                        [ 2, 3, 2 ],
                        [ 1, 1, 2 ],
                        [ 1, 3, 1 ]
                    ],

                    "patLength": 5
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 1, 2 ],
                        [ 2, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 3, 1, 1 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 4
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 2 ],
                        [ 1, 3, 1 ],
                        [ 1, 4, 2 ],
                        [ 1, 1, 2 ],
                        [ 1, 2, 1 ],
                        [ 1, 3, 2 ]
                    ],

                    "patLength": 6
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 4, 4, 2 ],
                        [ 1, 1, 2 ],
                        [ 2, 2, 1 ],
                        [ 3, 3, 2 ]
                    ],

                    "patLength": 6
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 4, 4, 2 ],
                        [ 1, 1, 2 ],
                        [ 2, 2, 1 ],
                        [ 3, 3, 2 ]
                    ],

                    "patLength": 5
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 1, 2, 2 ],
                        [ 1, 1, 2 ],
                        [ 2, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 2, 3, 2 ],
                        [ 2, 3, 1 ],
                        [ 2, 4, 1 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 7
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 1 ],
                        [ 2, 1, 1 ],
                        [ 2, 2, 1 ],
                        [ 2, 3, 2 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 5
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 2 ],
                        [ 4, 1, 1 ],
                        [ 2, 1, 1 ],
                        [ 2, 3, 2 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 7
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 2 ],
                        [ 4, 1, 1 ],
                        [ 2, 1, 2 ],
                        [ 4, 2, 1 ],
                        [ 2, 1, 1 ],
                        [ 2, 3, 2 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 6
                },
                {
                    "count": 20,
                    "tokens": [
                        [ 1, 1, 1 ],
                        [ 2, 2, 2 ],
                        [ 3, 3, 2 ],
                        [ 4, 1, 1 ],
                        [ 2, 4, 1 ],
                        [ 3, 4, 2 ],
                        [ 4, 3, 1 ],
                        [ 2, 1, 1 ],
                        [ 2, 3, 2 ],
                        [ 3, 1, 2 ]
                    ],

                    "patLength": 7
                }
            ]
        }
    ]
}
