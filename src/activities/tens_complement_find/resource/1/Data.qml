/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

/**
For fixed questions, use data like this:
    {
        randomQuestionPosition: false,
        values: [
        {
            numberValue: [6, 2, 8, 4, 9, 2],
            questionValue: [2, 1, 4]
        },
        {
            numberValue: [7, 2, 5, 8, 6, 4],
            questionValue: [2, 1, 3]
        }
        ]
    }
*/
Data {
    objective: qsTr("First number from 1 to 4.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            randomQuestionPosition: false,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 3,
            findBothNumbers: false,
            minimumFirstValue: 1,
            maximumFirstValue: 4
        },
        {
            randomValues: true,
            randomQuestionPosition: false,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 6,
            findBothNumbers: false,
            minimumFirstValue: 1,
            maximumFirstValue: 4
        }
    ]
}
