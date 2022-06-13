/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("First number from 5 to 9.")
    difficulty: 1
    data: [
        {
            "randomQuestionPosition": false,
            "value": [
                [
                    {
                        "numberValue": [1, 3, 4],
                        "questionValue": [7, 9, 6]
                    },
                    {
                        "numberValue": [1, 2, 5],
                        "questionValue": [8, 5, 9]
                    }
                ],
                [
                    {
                        "numberValue": [1, 3, 7, 4, 9, 2],
                        "questionValue": [6, 9, 7]
                    },
                    {
                        "numberValue": [7, 2, 5, 8, 6, 4],
                        "questionValue": [8, 5, 6]
                    }
                ]
            ]
        }
    ]
}
