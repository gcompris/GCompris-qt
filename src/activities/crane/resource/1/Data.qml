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
    objective: qsTr("Play with images.")
    difficulty: 2
    property var images: [
        "qrc:/gcompris/src/activities/crane/resource/bulb.svg",
        "qrc:/gcompris/src/activities/crane/resource/letter-a.svg",
        "qrc:/gcompris/src/activities/crane/resource/letter-b.svg",
        "qrc:/gcompris/src/activities/crane/resource/rectangle1.svg",
        "qrc:/gcompris/src/activities/crane/resource/rectangle2.svg",
        "qrc:/gcompris/src/activities/crane/resource/square1.svg",
        "qrc:/gcompris/src/activities/crane/resource/square2.svg",
        "qrc:/gcompris/src/activities/crane/resource/triangle1.svg",
        "qrc:/gcompris/src/activities/crane/resource/triangle2.svg",
        "qrc:/gcompris/src/activities/crane/resource/tux.svg",
        "qrc:/gcompris/src/activities/crane/resource/water_drop1.svg",
        "qrc:/gcompris/src/activities/crane/resource/water_drop2.svg",
        "qrc:/gcompris/src/activities/crane/resource/water_spot1.svg",
        "qrc:/gcompris/src/activities/crane/resource/water_spot2.svg"
    ]

    data:  [
        [
            {
                "isWord": false,
                "images": images.slice(0,2),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "images": images.slice(3,5),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "images": images.slice(6,8),
                "showGrid": true,
                "inLine": true,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "images": images.slice(9,11),
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            },
            {
                "isWord": false,
                "images": images.slice(11,13),
                "showGrid": true,
                "inLine": false,
                "rows": 3,
                "columns": 4
            }
        ],
        [
            {
                "isWord": false,
                "images": images.slice(0,3),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "images": images.slice(2,4),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "images": images.slice(5,8),
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "images": images.slice(9,11),
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": false,
                "images": images.slice(10,13),
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": false,
                "images": images.slice(0,3),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "images": images.slice(2,5),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "images": images.slice(3,6),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "images": images.slice(6,9),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": false,
                "images": images.slice(9,13),
                "showGrid": false,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": false,
                "images": images.slice(0,4),
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": false,
                "images": images.slice(2,7),
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": false,
                "images": images.slice(4,9),
                "showGrid": false,
                "inLine": true,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": false,
                "images": images.slice(5,11),
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": false,
                "images": images.slice(6,13),
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            }
        ]
    ]
}
