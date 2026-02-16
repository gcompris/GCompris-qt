/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Numbers from 1 to 9.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            shuffleOperands: true,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 0,
            findBothNumbers: false, // else find both numbers
            minimumFirstValue: 1,
            maximumFirstValue: 9
        },
        {
            randomValues: true,
            shuffleOperands: true,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 3,
            findBothNumbers: false,
            minimumFirstValue: 1,
            maximumFirstValue: 9
        }
    ]
}
