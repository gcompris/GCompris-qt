/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Shubham Mishra <shivam828787@gmail.com>
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *   Deepak Kumar <deepakdk2431@gmail.com>
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
    objective: qsTr("Large grids.")
    difficulty: 5
    data: [

        { // A
            "columns": 7,
            "image":
                [
                0,0,2,2,1,0,1,
                2,0,0,2,3,0,1,
                0,1,1,0,2,0,2,
                2,0,0,2,3,4,1,
                2,0,2,0,4,3,1,
                1,1,0,2,0,3,3,
                2,0,2,2,4,3,1

            ]
        },
        { // B
            "columns": 7,
            "image":
                [
                2,2,2,2,1,1,1,
                2,0,0,2,3,0,1,
                2,1,1,0,1,0,2,
                2,0,0,2,3,4,1,
                2,2,2,2,4,3,1,
                2,2,2,2,4,3,1,
                2,2,2,2,4,3,1
            ]
        },
        { // C
            "columns": 7,
            "image":
                [
                1,3,0,2,1,2,4,
                2,0,0,2,3,0,1,
                2,1,3,0,1,0,2,
                3,0,0,2,3,4,1,
                4,3,3,2,4,3,2,
                2,2,0,2,2,3,1,
                1,2,0,2,4,3,4
            ]
        },
        { // D
            "columns": 7,
            "image":
                [
                1,2,3,2,4,1,2,
                2,0,0,2,3,0,1,
                2,1,1,0,1,0,2,
                4,0,0,2,3,4,1,
                2,1,3,2,4,3,1,
                1,3,2,1,2,2,0,
                4,2,3,2,4,3,1
            ]
        },
        { // E
            "columns": 7,
            "image":
                [
                0,1,2,4,1,2,0,
                2,0,0,2,3,0,1,
                3,0,1,0,1,0,3,
                2,0,0,2,3,4,1,
                0,1,2,2,4,3,2,
                2,3,2,1,4,3,1,
                2,3,2,2,4,3,1
            ]
        },
        { // F
            "columns": 7,
            "image":
                [
                2,2,0,2,3,1,4,
                1,0,0,2,3,0,1,
                2,1,1,0,1,0,2,
                3,0,0,2,3,4,3,
                2,2,2,2,4,3,1,
                4,2,1,0,0,2,1,
                0,2,3,2,4,3,0
            ]
        },
        { // G
            "columns": 7,
            "image":
                [
                0,2,3,0,3,2,0,
                1,5,0,1,0,1,1,
                1,0,5,1,1,0,1,
                1,5,0,1,0,1,1,
                0,3,2,0,2,3,0,
                1,2,0,1,0,5,1,
                0,3,2,0,2,3,0
            ]
        },
        { // H
            "columns": 7,
            "image":
                [
                6,2,3,4,3,2,0,
                1,5,0,1,0,1,1,
                2,0,0,1,1,0,3,
                1,5,0,1,0,1,1,
                0,3,2,0,2,3,0,
                1,2,0,6,0,5,1,
                0,3,2,0,2,3,6
            ]
        },
        { // I
            "columns": 7,
            "image":
                [
                6,2,3,0,3,2,0,
                1,5,0,1,0,1,1,
                1,0,5,1,1,0,6,
                1,5,0,1,0,1,1,
                0,3,2,0,2,3,0,
                1,2,0,1,0,5,1,
                0,3,2,0,2,3,6
            ]
        }

    ]
}
