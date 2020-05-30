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
    objective: qsTr("Play with smaller grids using symbols")
    difficulty: 3
    data: [
        [
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
        ],
        [ // Level 2
         [
             ['A','.','.'],
             ['D','.','.'],
             ['C','A','.']
         ]
    ]
    ]
}
