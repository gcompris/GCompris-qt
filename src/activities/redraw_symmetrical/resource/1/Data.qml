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

    objective: qsTr("Small grids (3×3).")
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
