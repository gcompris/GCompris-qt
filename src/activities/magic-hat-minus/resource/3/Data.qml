/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Calculate remaining stars up to 5.")
    difficulty: 1
    data: [
        {
            "maxValue": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [3, 0, 0]
        },
        {
            "maxValue": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [4, 0, 0]
        },
        {
            "maxValue": 5,
            "minStars" : [2, 0, 0],
            "maxStars" : [5, 0, 0]
        }
    ]
}
