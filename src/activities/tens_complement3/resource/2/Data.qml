/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Split the 10's complement of the given number")
    difficulty: 1
    data: [
        {
            "value": [
                {
                    "numberValue": [8, 11, 3, 12, 4 , 15],
                    "questionValue": [7, 18, 25],
                    "splitValue": [7, "?", "?", 25],
                    "answerValue": [3, 15],
                    "questionValue2": [6, 12, 18],
                    "splitValue2": [6, "?", "?", 18],
                    "answerValue2": [4, 8]
                },
                {
                    "numberValue": [1, 17 ,13 ,8 ,7 ,11],
                    "questionValue": [9, 14, 23],
                    "splitValue": [9, "?", "?", 23],
                    "answerValue": [1, 13],
                    "questionValue2": [3, 18, 21],
                    "splitValue2": [5, "?", "?", 21],
                    "answerValue2": [7, 11]
                }
            ]
        }
    ]
}

