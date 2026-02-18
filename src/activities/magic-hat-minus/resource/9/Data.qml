/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Calculate remaining stars up to 10, with 2 or 3 different star sets.")
    difficulty: 3
    data: [
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 0],
            "maxStars" : [10, 5, 0]
        },
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 0],
            "maxStars" : [10, 10, 0]
        },
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [5, 5, 0],
            "maxStars" : [10, 10, 0]
        },
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 1],
            "maxStars" : [10, 10, 5]
        },
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [2, 1, 1],
            "maxStars" : [10, 10, 10]
        },
        {
            "useDifferentStars": true,
            "maxResultPerRow": 10,
            "minStars" : [5, 5, 5],
            "maxStars" : [10, 10, 10]
        }
    ]
}
