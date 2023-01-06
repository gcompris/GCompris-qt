 /* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("3 decimal places between 0 and 999.999.")
    difficulty: 6

    data: [
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 0.05,
            precision: 0.001,
            minValue: 0.0,
            maxValue: 999.999,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 0.5,
            precision: 0.001,
            minValue: 0.0,
            maxValue: 999.999,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 1,
            precision: 0.001,
            minValue: 0.0,
            maxValue: 999.999,
            numberOfEquations: 5
        }
    ]
}

