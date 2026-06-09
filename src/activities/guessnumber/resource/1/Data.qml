/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 * Authors:
 *   Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

Data {
    objective: qsTr("Guess a number between %1 and %2.").arg(1).arg(20)
    difficulty: 1
    data: [
        {
            "minNumber" : 1,
            "maxNumber" : 10
        },
        {
            "minNumber" : 1,
            "maxNumber" : 15
        },
        {
            "minNumber" : 1,
            "maxNumber" : 20
        }
    ]
}
