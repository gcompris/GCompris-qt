/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("First number from 1 to 4.")
    difficulty: 1
    data: [
        {
            "randomQuestionPosition": false,
            "value": [
                [
                    {
                        "numberValue": [8, 6, 7],
                        "questionValue": [3, 4, 2]
                    },
                    {
                        "numberValue": [9, 6, 7],
                        "questionValue": [1, 4, 3]
                    }
                ],
                [
                    {
                        "numberValue": [6, 2, 8, 4, 9, 2],
                        "questionValue": [2, 1, 4]
                    },
                    {
                        "numberValue": [7, 2, 5, 8, 6, 4],
                        "questionValue": [2, 1, 3]
                    }
                ]
            ]
        }
    ]
}
