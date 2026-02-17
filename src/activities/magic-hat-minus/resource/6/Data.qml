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
    //: Coefficients are the numbers by which the numbers of stars are multiplied to get the total
    objective: qsTr("Calculate remaining stars up to 100 with coefficients.")
    difficulty: 4
    data: [
        {
            "useCoefficients": true,
            "multiplier": 1,
            "rowCoefficients" : [2, 1, 0],
        },
        {
            "useCoefficients": true,
            "multiplier": 1,
            "rowCoefficients" : [2, 2, 1]
        },
        {
            "useCoefficients": true,
            "multiplier": 1,
            "rowCoefficients" : [2, 2, 2]
        },
        {
            "useCoefficients": true,
            "multiplier": 1,
            "rowCoefficients" : [3, 3, 2]
        },
        {
            "useCoefficients": true,
            "multiplier": 1,
            "rowCoefficients" : [4, 4, 2]
        }
    ]
}
