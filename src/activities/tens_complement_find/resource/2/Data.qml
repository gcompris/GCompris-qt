/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("First number from 5 to 9.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            randomQuestionPosition: false,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 3,
            findBothNumbers: false,
            minimumFirstValue: 5,
            maximumFirstValue: 9
        },
        {
            randomValues: true,
            randomQuestionPosition: false,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 6,
            findBothNumbers: false,
            minimumFirstValue: 5,
            maximumFirstValue: 9
        }
    ]
}
