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
    objective: qsTr("Numbers from 1 to 1000000.")
    difficulty: 3

    data: [
        {
            random: true,
            minValue: 1,
            maxValue: 500000,
            count: 5
        },
        {
            random: true,
            minValue: 500001,
            maxValue: 1000000,
            count: 5
        }
    ]
}

