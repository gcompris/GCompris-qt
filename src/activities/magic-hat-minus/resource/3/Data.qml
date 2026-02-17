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
    objective: qsTr("Calculate remaining stars up to 5.")
    difficulty: 1
    data: [
        {
            "maxResultPerRow": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [3, 0, 0]
        },
        {
            "maxResultPerRow": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [4, 0, 0]
        },
        {
            "maxResultPerRow": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [5, 0, 0]
        }
    ]
}
