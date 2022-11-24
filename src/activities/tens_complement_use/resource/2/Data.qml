/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Result between 20 and 29.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 20,
            maxResult: 29
        },
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 20,
            maxResult: 29
        }
    ]
}

