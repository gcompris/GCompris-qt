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

/*
Here is an example of what data is expected for a level with specific numbers:
    data: [
        {
            random: false,
            values: [
                // First sublevel
                [[11, 55], [88, 22], [11, 44]],
                // Second sublevel
                [[23, 8], [855, 252], [115, 115], [1996, 1987], [1996, 2003]]
            ]
        },
        {
            random: false,
            values: [
                [[822, 99], [4432, 4431], [5252, 2525]],
                [[11, 23], [3523, 51], [33, 33]],
                [[73, 2], [201, 532], [4215, 241]]
            ]
        }
    ]
*/
Data {
    objective: qsTr("Numbers from 1 to 9.")
    difficulty: 1

    data: [
        {
            random: true,
            numberOfSublevels: 5,
            minValue: 1,
            maxValue: 9,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            minValue: 1,
            maxValue: 9,
            numberOfEquations: 5
        },
        {
            random: true,
            numberOfSublevels: 5,
            minValue: 1,
            maxValue: 9,
            numberOfEquations: 5
        }
    ]
}
