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
    //: Coefficients are the numbers by which the numbers of stars are multiplied to get the total
    objective: qsTr("Add stars up to 10000 with coefficients.")
    difficulty: 6
    data: [
        {
            "maxValue": 10000,
            "minStars" : [2, 0, 0],
            "maxStars" : [1000, 0, 0]
        },
        {
            "maxValue": 10000,
            "minStars" : [2, 2, 0],
            "maxStars" : [1000, 1000, 0]
        },
        {
            "maxValue": 10000,
            "minStars" : [2, 2, 2],
            "maxStars" : [2000, 2000, 1000]
        },
        {
            "maxValue": 10000,
            "minStars" : [2, 2, 2],
            "maxStars" : [3000, 3000, 1000]
        },
        {
            "maxValue": 10000,
            "minStars" : [2, 2, 2],
            "maxStars" : [4000, 4000, 2000]
        }
    ]
}
