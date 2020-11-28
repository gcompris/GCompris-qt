/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Numbers between 1 and 8.")
    difficulty: 1
    data: [
    {
        "minNumber": 1,
        "maxNumber": 1, /* Max number on each domino side */
        "numberOfFish": 3
    },
    {
        "minNumber": 1,
        "maxNumber": 2,
        "numberOfFish": 4
    },
    {
        "minNumber": 1,
        "maxNumber": 3,
        "numberOfFish": 5
    },
    {
        "minNumber": 1,
        "maxNumber": 4,
        "numberOfFish": 5
    }
    ]
}
