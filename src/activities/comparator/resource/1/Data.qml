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
    objective: qsTr("Numbers from 1 to 9.")
    difficulty: 1

    data: [
        {
            random: true,
            minValue: 1,
            maxValue: 6,
            count: 5
        },
        {
            random: true,
            minValue: 5,
            maxValue: 9,
            count: 5
        }
    ]
}
