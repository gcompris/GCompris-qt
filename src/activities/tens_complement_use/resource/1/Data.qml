/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

/**
Fixed dataset should have values like:
data: [
    {
        "values": [
            {
                numberValue: [4, 3, 6, 7, 2, 3],
                questions: [ 
                {
                    questionValue: [7, 9, 16],
                    splitValue: [7, "?", "?", 16]
                },
                {
                    questionValue: [6, 7, 13],
                    splitValue: [6, "?", "?", 13]
                }
                ]
            },
            {
                numberValue: [5, 2, 4, 6, 1, 8],
                questions: [ 
                {
                    questionValue: [4, 8, 12],
                    splitValue: [4, "?", "?", 12]
                },
                {
                    questionValue: [5, 6, 11],
                    splitValue: [5, "?", "?", 11]
                }
                ]
            }
        ]
*/
Data {
    objective: qsTr("Result between 11 and 19.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 11,
            maxResult: 19
        },
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 11,
            maxResult: 19
        }
    ]
}
