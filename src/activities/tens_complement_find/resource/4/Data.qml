/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find both numbers.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            shuffleOperands: true,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 0,
            findBothNumbers: true,
            minimumFirstValue: 1,
            maximumFirstValue: 9
        },
        {
            randomValues: true,
            shuffleOperands: true,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 0,
            findBothNumbers: true,
            minimumFirstValue: 1,
            maximumFirstValue: 9
        }
    ]
}
