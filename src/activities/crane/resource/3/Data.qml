/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   shivam828787@gmail.com <email.shivam828787@gmail.com>
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
    objective: qsTr("Play with smaller grids of size 5x6.")
    difficulty: 4
    data:  [
        [
            {
                "isWord": true,
                "word": qsTr("help"),
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("child"),
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("happy"),
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("apple"),
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("brown"),
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 6,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 7,
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 8,
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": true,
                "word": qsTr("fresh"),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("green"),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("horse"),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("shape"),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "word": qsTr("paper"),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": false,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 6,
                "showGrid": false,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 7,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "noOfItems": 8,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ]
    ]
}
