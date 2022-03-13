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
    objective: qsTr("fixed dataset")
    difficulty: 1

    data: [
        {
            random: false,
            values: [[11, 55] , [88, 22], [11, 44]]
        },
        {
            random: false,
            values: [[11, 99] , [44, 22], [33, 44]]
        }
    ]
}

