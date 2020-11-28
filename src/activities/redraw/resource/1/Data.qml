/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {

    objective: qsTr("Small grids.")
    difficulty: 1
    data: [
        {
            "columns": 4,
            "image":
                [
                1,0,0,1,
                0,1,1,0,
                0,0,0,0,
                0,0,0,0,
                0,0,0,0
            ]
        },
        {
            "columns": 4,
            "image":
                [
                1,0,0,0,
                0,0,2,0,
                0,0,0,0,
                0,0,2,0,
                1,0,0,0
            ]
        },
        {
            "columns": 4,
            "image":
                [
                1,0,0,0,
                0,0,0,0,
                0,0,2,1,
                0,2,0,0,
                0,0,0,0
            ]
        },
        {
            "columns": 4,
            "image":
                [
                1,0,0,1,
                2,0,0,2,
                0,0,1,0,
                0,2,2,0,
                1,0,0,1
            ]
        },
        {
            "columns": 4,
            "image":
                [
                0,0,0,1,
                2,2,2,0,
                0,0,1,0,
                1,0,2,0,
                0,2,0,1
            ]
        },
        {
            "columns": 4,
            "image":
                [
                0,0,0,1,
                2,3,2,0,
                0,0,3,0,
                0,1,2,0,
                0,2,0,1
            ]
        },
    ]
}
