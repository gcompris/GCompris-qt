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
    objective: qsTr("Maximum value: 5000.")
    difficulty: 5
    data: [
        {
            "subLevels": 5,
            "arrows": 6,
            "circleValues": [
                1000,
                300,
                200,
                100,
                30,
                10,
                8,
                4,
                2,
                1,
            ]
        },
        {
            "subLevels": 5,
            "arrows": 6,
            "circleValues": [
                3000,
                1000,
                300,
                200,
                100,
                30,
                10,
                8,
                4,
                2,
                1,
            ]
        },
        {
            "subLevels": 5,
            "arrows": 6,
            "circleValues": [
                5000,
                3000,
                1000,
                300,
                200,
                100,
                30,
                10,
                8,
                4,
                2,
                1,
            ]
        }
    ]
}
