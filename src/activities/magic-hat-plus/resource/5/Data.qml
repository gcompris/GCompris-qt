/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Add stars up to 30.")
    difficulty: 3
    data: [
        {
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 0],
            "maxStars" : [9, 5, 0]
        },
        {
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 0],
            "maxStars" : [9, 9, 0]
        },
        {
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 1],
            "maxStars" : [8, 8, 8]
        },
        {
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 1],
            "maxStars" : [9, 9, 9]
        },
        {
            "maxResultPerRow": 10,
            "minStars" : [3, 4, 5],
            "maxStars" : [9, 9, 9]
        },
        {
            "maxResultPerRow": 10,
            "minStars" : [6, 7, 8],
            "maxStars" : [9, 9, 9]
        }
    ]
}
