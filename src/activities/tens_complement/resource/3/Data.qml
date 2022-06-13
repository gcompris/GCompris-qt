/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Numbers from 1 to 9.")
    difficulty: 1
    data: [
        {
            "randomQuestionPosition": true,
            "value": [
                [
                    {
                        "numberValue": [8, 2, 3],
                        "questionValue": [7, 8, 2]
                    },
                    {
                        "numberValue": [3, 9, 5],
                        "questionValue": [7, 1, 5]
                    }
                ],
                [
                    {
                        "numberValue": [1, 2, 8, 4, 3, 2],
                        "questionValue": [6, 2, 7]
                    },
                    {
                        "numberValue": [7, 2, 5, 8, 6, 4],
                        "questionValue": [8, 5, 3]
                    }
                ],
                [
                    {
                        "numberValue": [1, 4, 8, 2, 6, 9],
                        "questionValue": ["?", "?" ,"?"]
                    },
                    {
                        "numberValue": [7, 9, 1, 3, 6, 4],
                        "questionValue": ["?", "?" ,"?"]
                    }
                ]
            ]
        }
    ]
}
