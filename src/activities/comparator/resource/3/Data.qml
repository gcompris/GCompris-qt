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
    objective: qsTr("Numbers from 1 to 100.")
    difficulty: 2

    data: [
        {
            random: true,
            numberOfSublevels: 5,
            minValue: 1,
            maxValue: 100,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 30,
            minValue: 1,
            maxValue: 100,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            maxDistanceBetweenNumbers: 5,
            minValue: 1,
            maxValue: 100,
            numberOfEquations: 5
        }
    ]
}

