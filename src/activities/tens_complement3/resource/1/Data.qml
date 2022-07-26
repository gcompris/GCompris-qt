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
                    "numberValue": [4, 3, 6, 7, 2, 3],
                    "questionValue": [7, 9, 16],
                    "splitValue": [7, "?", "?", 16],
                    "answerValue": [3, 6],
                    "questionValue2": [6, 7, 13],
                    "splitValue2": [6, "?", "?", 13],
                    "answerValue2": [4, 3]
                },
                {
                    "numberValue": [5, 2, 4, 6, 1, 8],
                    "questionValue": [4, 8, 12],
                    "splitValue": [4, "?", "?", 12],
                    "answerValue": [6, 2],
                    "questionValue2": [5, 6, 11],
                    "splitValue2": [5, "?", "?", 11],
                    "answerValue2": [5, 1]
                }
            ]
        }
    ]
}

