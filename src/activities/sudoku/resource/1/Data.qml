/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Small grids using symbols.")
    difficulty: 3

  property var symbols: [
        {"imgName": "circle.svg", "text": 'A'},
        {"imgName": "rectangle.svg", "text": 'B'},
        {"imgName": "rhombus.svg", "text": 'C'},
        {"imgName": "star.svg", "text": 'D'},
        {"imgName": "triangle.svg", "text": 'E'}
    ]

    data: [
        {
            "symbols": symbols,
            "data": [
                [
                    ['.','C','B'],
                    ['.','B','A'],
                    ['.','A','C']
                ],
                [
                    ['C','A','B'],
                    ['.','.','.'],
                    ['B','C','A']
                ],
                [
                    ['C','A','B'],
                    ['A','B','C'],
                    ['.','.','.']
                ],
                [
                    ['A','.','C'],
                    ['C','.','B'],
                    ['B','.','A']
                ],
                [
                    ['A','.','C'],
                    ['B','C','.'],
                    ['.','A','B']
                ],
                [
                    ['A','B','C'],
                    ['B','.','A'],
                    ['.','A','.']
                ],
                [
                    ['.','B','A'],
                    ['B','.','C'],
                    ['A','C','.']
                ],
                [
                    ['A','B','C'],
                    ['.','C','A'],
                    ['.','A','.']
                ]
            ]
        },
        {
            "symbols": symbols,
            "data": [
                [
                    ['A','.','.'],
                    ['D','.','.'],
                    ['C','A','.']
                ],
                [
                    ['C','.','D'],
                    ['.','.','B'],
                    ['.','D','C']
                ],
                [
                    ['.','B','D'],
                    ['D','.','.'],
                    ['B','.','C']
                ],
                [
                    ['A','.','.'],
                    ['.','D','A'],
                    ['D','.','C']
                ],
                [
                    ['C','.','D'],
                    ['.','C','.'],
                    ['B','.','C']
                ]
            ]
        },
        {
            "symbols": symbols,
            "data": [
                [
                    ['.','A','.'],
                    ['A','C','.'],
                    ['.','B','.']
                ],
                [
                    ['B','A','.'],
                    ['A','C','.'],
                    ['.','.','.']
                ],
                [
                    ['.','A','C'],
                    ['.','.','B'],
                    ['C','.','.']
                ],
                [
                    ['.','.','C'],
                    ['D','.','A'],
                    ['C','.','.']
                ],
                [
                    ['.','.','C'],
                    ['D','.','A'],
                    ['.','A','.']
                ]
            ]
        }
    ]
}
