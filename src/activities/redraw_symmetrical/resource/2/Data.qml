/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Shubham Mishra <shivam828787@gmail.com>
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Medium grids (5×5).")
    difficulty: 4
    data: [
        {
            "columns": 5,
            "image":
                [
                0,1,0,0,1,
                1,0,1,0,0,
                1,0,0,1,0,
                0,0,1,0,0,
                1,0,0,0,1,
            ]
        },
        {
            "columns": 5,
            "image":
                [
                1,0,2,0,1,
                0,2,0,0,2,
                0,0,1,2,0,
                0,0,2,1,0,
                2,0,1,0,2
            ]
        },
        {
            "columns": 5,
            "image":
                [
                1,0,2,0,3,
                0,2,0,0,1,
                1,0,0,3,2,
                3,0,1,0,0,
                0,1,0,2,3
            ]
        },
        {
            "columns": 5,
            "image":
                [
                0,1,2,0,3,
                1,0,3,0,2,
                2,0,2,0,1,
                1,0,2,0,3,
                2,0,3,0,1
            ]
        },
        {
            "columns": 5,
            "image":
                [
                1,0,2,0,4,
                3,2,0,2,0,
                3,0,1,2,4,
                0,2,0,0,3,
                1,0,0,3,0
            ]
        },
        {
            "columns": 5,
            "image":
                [
                2,0,1,0,1,
                3,1,0,4,0,
                3,0,2,0,3,
                0,2,0,1,0,
                1,0,4,0,1
            ]
        },
    ]
}
