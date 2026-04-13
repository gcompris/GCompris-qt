/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Maximum value: 10.")
    difficulty: 2
    data: [
        {
            "subLevels": 5,
            "arrows": 3,
            "circleValues": [
                5,
                4,
                3,
                2,
                1
            ]
        },
        {
            "subLevels": 5,
            "arrows": 3,
            "circleValues": [
                7,
                5,
                3,
                2,
                1
            ]
        },
        {
            "subLevels": 5,
            "arrows": 3,
            "circleValues": [
                10,
                7,
                5,
                3,
                2
            ]
        }
    ]
}
