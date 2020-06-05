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
    objective: qsTr("Play with medium size grids using numbers and symbols.")
    difficulty: 5

    property var symbols: [
        {"imgName": "circle", "text": 'A', "extension": ".svg"},
        {"imgName": "rectangle", "text": 'B', "extension": ".svg"},
        {"imgName": "rhombus", "text": 'C', "extension": ".svg"},
        {"imgName": "star", "text": 'D', "extension": ".svg"},
        {"imgName": "triangle", "text": 'E', "extension": ".svg"},
        {"imgName": "1", "text": '1', "extension": ".svg"},
        {"imgName": "2", "text": '2', "extension": ".svg"},
        {"imgName": "3", "text": '3', "extension": ".svg"},
        {"imgName": "4", "text": '4', "extension": ".svg"},
        {"imgName": "5", "text": '5', "extension": ".svg"}
    ]

    data: [
        {
            "symbols": symbols,
            "data": [
                [
                    ['A','B','C','D','E'],
                    ['.','A','B','C','D'],
                    ['.','.','A','B','C'],
                    ['.','.','.','A','B'],
                    ['.','.','.','.','A']
                ],
                [
                    ['A','B','.','D','.'],
                    ['.','.','D','E','A'],
                    ['C','.','.','A','.'],
                    ['D','E','.','.','C'],
                    ['.','A','B','.','D']
                ],
                [
                    ['.','C','.','A','.'],
                    ['A','.','B','.','C'],
                    ['.','B','.','C','.'],
                    ['D','.','C','.','A'],
                    ['.','A','E','.','B']
                ],
                [
                    ['C','B','.','.','D'],
                    ['.','.','D','C','.'],
                    ['D','.','B','.','E'],
                    ['.','A','.','D','C'],
                    ['E','.','.','B','.']
                ],
                [
                    ['D','.','.','B','E'],
                    ['.','E','A','.','.'],
                    ['A','C','.','.','B'],
                    ['.','.','B','C','.'],
                    ['C','B','.','A','.']
                ],
                [
                    ['.','.','C','D','.'],
                    ['B','.','.','.','C'],
                    ['.','C','.','B','D'],
                    ['C','.','D','A','.'],
                    ['D','E','.','.','A']
                ]
            ]
        },
        {
            "symbols": symbols,
            "data": [
                [
                    ['1','2','3','4','5'],
                    ['.','1','2','3','4'],
                    ['.','.','1','2','3'],
                    ['.','.','.','1','2'],
                    ['.','.','.','.','1']
                ],
                [
                    ['1','2','.','4','.'],
                    ['.','.','4','5','1'],
                    ['3','.','.','1','.'],
                    ['4','5','.','.','3'],
                    ['.','1','2','.','4']
                ],
                [
                    ['.','3','.','1','.'],
                    ['1','.','2','.','3'],
                    ['.','2','.','3','.'],
                    ['4','.','3','.','1'],
                    ['.','1','5','.','2']
                ],
                [
                    ['3','2','.','.','4'],
                    ['.','.','4','3','.'],
                    ['4','.','2','.','5'],
                    ['.','1','.','4','3'],
                    ['5','.','.','2','.']
                ],
                [
                    ['4','.','.','2','5'],
                    ['.','5','1','.','.'],
                    ['1','3','.','.','2'],
                    ['.','.','2','3','.'],
                    ['3','2','.','1','.']
                ],
                [
                    ['.','.','3','4','.'],
                    ['2','.','.','.','3'],
                    ['.','3','.','2','4'],
                    ['3','.','4','1','.'],
                    ['4','5','.','.','1']
                ]
            ]
        }
    ]
}
