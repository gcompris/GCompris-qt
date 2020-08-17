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

    objective: qsTr("Small grids(3x3).")
    difficulty: 3
    data: [
        {
            "columns": 3,
            "image":
                [
                1,0,0,
                0,1,1,
                0,0,0
            ]
        },
        {
            "columns": 3,
            "image":
                [
                1,0,1,
                0,0,2,
                2,0,0
            ]
        },
        {
            "columns": 3,
            "image":
                [
                1,2,0,
                0,1,0,
                1,0,2
            ]
        },
        {
            "columns": 3,
            "image":
                [
                1,0,2,
                3,0,1,
                0,3,1
            ]
        },
        {
            "columns": 3,
            "image":
                [
                1,0,1,
                2,3,2,
                1,0,1
            ]
        },
        {
            "columns": 3,
            "image":
                [
                1,0,3,
                2,3,2,
                1,0,3
            ]
        },
    ]
}
