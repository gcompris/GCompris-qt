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
    objective: qsTr("Calculate remaining stars up to 1000 with coefficients.")
    difficulty: 5
    data: [
        {
            "maxValue": 1000,
            "minStars" : [2, 0, 0],
            "maxStars" : [100, 0, 0]
        },
        {
            "maxValue": 1000,
            "minStars" : [2, 2, 0],
            "maxStars" : [100, 100, 0]
        },
        {
            "maxValue": 1000,
            "minStars" : [2, 2, 2],
            "maxStars" : [200, 200, 100]
        },
        {
            "maxValue": 1000,
            "minStars" : [2, 2, 2],
            "maxStars" : [300, 300, 100]
        },
        {
            "maxValue": 1000,
            "minStars" : [2, 2, 2],
            "maxStars" : [400, 400, 200]
        }
    ]
}
