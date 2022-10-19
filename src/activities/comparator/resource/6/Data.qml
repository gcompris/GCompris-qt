 /* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("Numbers from 1 to 1 billion.")
    difficulty: 3

    data: [
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 10000000,
            minValue: 1,
            maxValue: 1000000000,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 100000,
            minValue: 1,
            maxValue: 1000000000,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 1000,
            minValue: 1,
            maxValue: 1000000000,
            numberOfEquations: 5
        }
    ]
}

