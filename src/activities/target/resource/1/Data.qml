/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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
    objective: qsTr("Maximum value: 10.")
    difficulty: 2
    property var colors: [
        "#ee7f7f",
        "#eebf7f",
        "#e0ee7f",
        "#7fee8f",
        "#7fcbee",
        "#b8c8f6"
    ]
    data: [
        [
            {size: 50, color: colors[0], score: 5},
            {size: 100, color: colors[1], score: 4},
            {size: 150, color: colors[2], score: 3},
            {size: 200, color: colors[3], score: 2},
            {size: 250, color: colors[4], score: 1}
        ],
        [
            {size: 50, color: colors[0], score: 7},
            {size: 100, color: colors[1], score: 5},
            {size: 150, color: colors[2], score: 3},
            {size: 200, color: colors[3], score: 2},
            {size: 250, color: colors[4], score: 1}
        ],
        [
            {size: 50, color: colors[0], score: 10},
            {size: 100, color: colors[1], score: 7},
            {size: 150, color: colors[2], score: 5},
            {size: 200, color: colors[3], score: 3},
            {size: 250, color: colors[4], score: 2}
        ]
    ]
}
