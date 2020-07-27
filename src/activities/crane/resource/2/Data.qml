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
    objective: qsTr("Play with smaller grids of size 4x5.")
    difficulty: 3
    data:  [
        [
            {
                "isWord": true,
                "word": qsTr("pen"),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("area"),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("good"),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("best"),
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("coat"),
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 6,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 7,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": true,
                "word": qsTr("cap"),
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("bell"),
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("easy"),
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("girl"),
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "word": qsTr("food"),
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": false,
                "noOfItems": 3,
                "showGrid": false,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 4,
                "showGrid": false,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 6,
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "noOfItems": 7,
                "showGrid": false,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ]
    ]
}
