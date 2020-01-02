/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0
import "../../../../core"

Dataset {
    objective: qsTr("Select medium grids")
    difficulty: 2
    data: [
        {
            "columns": 6,
            "image":
                [
                0,1,0,0,1,0,
                1,0,0,0,0,1,
                0,0,0,1,0,0,
                0,0,0,0,0,0,
                1,0,0,0,0,1,
                0,0,1,1,0,0
            ]
        },
        {
            "columns": 6,
            "image":
                [
                1,0,2,0,0,0,
                0,0,0,0,0,2,
                0,0,1,2,0,0,
                0,0,2,1,0,0,
                0,0,0,0,0,0,
                0,0,0,3,3,1
            ]
        },
        {
            "columns": 6,
            "image":
                [
                1,0,0,0,0,3,
                0,2,0,0,0,3,
                0,0,0,3,0,0,
                0,0,1,0,0,0,
                0,0,0,2,0,0,
                0,1,0,0,0,1
            ]
        },
        {
            "columns": 7,
            "image":
                [
                0,1,2,0,2,1,0,
                1,0,0,0,0,0,1,
                2,0,0,0,0,0,2,
                0,0,0,0,0,0,0,
                2,0,0,0,0,0,2,
                1,0,0,0,0,0,1,
                0,1,2,0,2,1,0
            ]
        },
        {
            "columns": 7,
            "image":
                [
                0,0,1,0,1,0,0,
                0,2,0,2,0,2,0,
                3,0,0,0,0,0,3,
                0,2,0,0,0,2,0,
                0,0,0,3,0,0,0,
                0,2,0,0,0,2,0,
                1,0,1,0,1,0,1
            ]
        },
        {
            "columns": 7,
            "image":
                [
                0,0,1,0,1,0,0,
                3,1,0,0,0,0,2,
                3,0,0,0,0,0,3,
                0,2,0,1,0,2,0,
                0,0,0,0,1,0,0,
                0,2,0,0,0,2,0,
                0,3,0,0,3,0,1
            ]
        },
    ]
}
