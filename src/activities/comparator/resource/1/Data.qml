/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

/*
Here is an example of what data is expected for a level with specific numbers:
[
    {
        "shuffle": true,
        "subLevels":  [
        {
            "leftNumber": "1",
            "rightNumber": "2"
        },
        {
            "leftNumber": "3",
            "rightNumber": "4"
        },
        {
            "leftNumber": "4",
            "rightNumber": "3"
        }
        ]
    },
    {
        "shuffle": true,
        "subLevels":  [
        {
            "leftNumber": "2",
            "rightNumber": "2"
        },
        {
            "leftNumber": "3",
            "rightNumber": "6"
        },
        {
            "leftNumber": "4",
            "rightNumber": "1.1"
        }
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
