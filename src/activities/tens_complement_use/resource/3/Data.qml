/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Result between 30 and 50.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 30,
            maxResult: 50
        },
        {
            randomValues: true,
            numberOfSublevels: 5,
            numberOfEquations: 2,
            numberOfNumbersInLeftContainer: 6,
            minResult: 30,
            maxResult: 50
        }
    ]
}

