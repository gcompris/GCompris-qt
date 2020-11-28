/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 * Authors:
 *   Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("Guess a number between 1 and %1.").arg(100)
    difficulty: 2
    data: [
        {
            // first number is the minimum number and second is the maximum number
            "objective" : qsTr("Guess a number between 1 and %1.").arg(10),
            "maxNumber" : 10
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1.").arg(100),
            "maxNumber" : 100
        }
    ]
}
