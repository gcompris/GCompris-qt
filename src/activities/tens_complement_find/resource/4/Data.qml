/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Find both numbers.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            randomQuestionPosition: true,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 6,
            findBothNumbers: true,
            minimumFirstValue: 1,
            maximumFirstValue: 9
        },
        {
            randomValues: true,
            randomQuestionPosition: true,
            numberOfSublevels: 5,
            numberOfEquations: 3,
            numberOfNumbersInLeftContainer: 6,
            findBothNumbers: true,
            minimumFirstValue: 1,
            maximumFirstValue: 9
        }
    ]
}
