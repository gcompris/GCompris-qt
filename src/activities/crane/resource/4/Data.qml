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
    objective: qsTr("Play with words of 5 letters.")
    difficulty: 3
    data:  [
        [
            /* To add your words, replace "wordLength" key with "word".
              Example - replace "wordLength": 3 with "word": qsTr("pen")
            */
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            }
        ]
    ]
}
