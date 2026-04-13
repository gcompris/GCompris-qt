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
    objective: qsTr("Maximum value: 500.")
    difficulty: 4
    data: [
        {
            "subLevels": 5,
            "arrows": 5,
            "circleValues": [
                100,
                30,
                20,
                10,
                8,
                4,
                2,
                1
            ]
        },
        {
            "subLevels": 5,
            "arrows": 5,
            "circleValues": [
                300,
                100,
                30,
                20,
                10,
                8,
                4,
                2,
                1,
            ]
        },
        {
            "subLevels": 5,
            "arrows": 5,
            "circleValues": [
                500,
                300,
                100,
                30,
                20,
                10,
                8,
                4,
                2,
                1
            ]
        }
    ]
}
