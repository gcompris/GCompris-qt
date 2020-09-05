/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

Data {
    objective: qsTr("Medium grids using symbols.")
    difficulty: 4

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
                    ['.','B','C','D'],
                    ['D','C','.','A'],
                    ['.','D','A','B'],
                    ['B','A','.','C']
                ],
                [
                    ['A','.','.','D'],
                    ['D','C','B','.'],
                    ['C','D','A','.'],
                    ['.','.','D','C']
                ],
                [
                    ['.','B','.','.'],
                    ['.','C','B','A'],
                    ['C','D','A','.'],
                    ['.','.','D','.']
                ],
                [
                    ['.','B','A','.'],
                    ['D','.','B','C'],
                    ['A','C','.','B'],
                    ['.','D','C','.']
                ],
                [
                    ['.','.','.','.'],
                    ['D','A','B','C'],
                    ['A','C','D','B'],
                    ['.','.','.','.']
                ],
            ]
        },
        {
            "symbols": symbols,
            "data": [
                [
                    ['.','.','.','.'],
                    ['D','A','B','.'],
                    ['C','.','A','B'],
                    ['.','.','.','D']
                ],
                [
                    ['A','B','C','D'],
                    ['.','.','.','.'],
                    ['.','.','.','.'],
                    ['B','C','D','A']
                ],
                [
                    ['.','.','A','D'],
                    ['D','.','.','C'],
                    ['A','.','.','B'],
                    ['B','D','.','.']
                ],
                [
                    ['.','.','A','.'],
                    ['D','A','B','.'],
                    ['.','C','D','B'],
                    ['.','D','.','.']
                ],
                [
                    ['C','B','.','D'],
                    ['.','.','.','C'],
                    ['A','.','.','.'],
                    ['B','.','C','A']
                ],
            ]
        },
        {
            "symbols": symbols,
            "data": [
                [
                    ['C','.','.','D'],
                    ['.','.','B','.'],
                    ['A','.','.','.'],
                    ['.','.','D','.']
                ],
                [
                    ['.','B','.','A'],
                    ['.','.','B','.'],
                    ['C','.','D','.'],
                    ['.','.','.','C']
                ],
                [
                    ['A','.','B','.'],
                    ['.','C','.','A'],
                    ['.','.','.','D'],
                    ['D','.','C','.']
                ],
                [
                    ['.','A','.','.'],
                    ['C','.','A','B'],
                    ['.','.','C','.'],
                    ['D','.','.','A']
                ],
                [
                    ['C','.','.','D'],
                    ['B','.','A','.'],
                    ['.','B','.','A'],
                    ['.','.','.','.']
                ],
                [
                    ['.','A','C','.'],
                    ['.','.','.','D'],
                    ['C','.','.','A'],
                    ['.','B','.','.']
                ],
                [
                    ['.','C','.','D'],
                    ['B','.','.','.'],
                    ['.','.','.','.'],
                    ['C','A','.','B']
                ],
                [
                    ['B','.','.','C'],
                    ['.','A','.','.'],
                    ['.','.','D','.'],
                    ['.','B','.','.']
                ]
            ]
        }
    ]
}
