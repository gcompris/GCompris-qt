/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/*
data usage:

data: [
    {
        // If "shuffle" is true, it will shuffle the content of "values" for this level.
        "shuffle": false,
        "values": [
            // Example of level with random numbers, with 2 questions.
            // 3 random numbers in each question (1 pair for each equal to 10).
            {
            "randomValues": true,
            "numberOfElements": 3
            },
            {
            "randomValues": true,
            "numberOfElements": 3
            }
        ],
    },
    {
        // If "shuffle" is true, it will shuffle the content of "values" for this level.
        "shuffle": false,
        "values": [
            // Example of level with fixed numbers.
            // "numberValues" must contain 1, 2 or 3 numbers, their complement to 10 will be added automatically.
            // "extraValue" can contain 1 optional number added to the addition. It is mandatory
            // if "numberValues" contains 1 number, optional if it contains 2 numbers,
            // and not used if it contains 3 numbers.
            {
            "numberValues": [1],
            "extraValue": [4]

            },
            {
            "numberValues": [7, 6]
            "extraValue": [5]
            }
        ]
    }
]
*/

Data {
    objective: qsTr("1 pair to make from 3 numbers.")
    difficulty: 4
    data: [
        {
          "values": [
                {
                    "randomValues": true,
                    "numberOfElements": 3
                },
                {
                    "randomValues": true,
                    "numberOfElements": 3
                },
                {
                    "randomValues": true,
                    "numberOfElements": 3
                }
            ]
        },
        {
          "values": [
                {
                    "randomValues": true,
                    "numberOfElements": 3
                },
                {
                    "randomValues": true,
                    "numberOfElements": 3
                },
                {
                    "randomValues": true,
                    "numberOfElements": 3
                },
                {
                    "randomValues": true,
                    "numberOfElements": 3
                }
            ]
        }
    ]
}
