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
    objective: qsTr("Play with smaller grids of size 3x4.")
    difficulty: 2
    data:  [
        [
            {
                "isWord": true,
                "word": qsTr("cat"),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("dog"),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("egg"),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("win"),
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("day"),
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 2,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ],
        [
            {
                "isWord": true,
                "word": qsTr("red"),
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("big"),
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("air"),
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("box"),
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "word": qsTr("ant"),
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 2,
                "showGrid": false,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": false,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": false,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ]
    ]
}
