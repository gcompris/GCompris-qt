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
    objective: qsTr("Add stars up to 100 with coefficients.")
    difficulty: 4
    data: [
        {
            "maxValue": 100,
            "minStars" : [2, 2, 0],
            "maxStars" : [20, 10, 0]
        },
        {
            "maxValue": 100,
            "minStars" : [2, 2, 2],
            "maxStars" : [20, 20, 10]
        },
        {
            "maxValue": 100,
            "minStars" : [2, 2, 2],
            "maxStars" : [20, 20, 20]
        },
        {
            "maxValue": 100,
            "minStars" : [2, 2, 2],
            "maxStars" : [30, 30, 20]
        },
        {
            "maxValue": 100,
            "minStars" : [2, 2, 2],
            "maxStars" : [40, 40, 20]
        }
    ]
}
