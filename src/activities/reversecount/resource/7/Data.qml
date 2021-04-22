/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Numbers between %1 and %2.").arg(4).arg(8)
    difficulty: 2
    data: [
    {
        "maxNumber": 4, /* Max number on each domino side */
        /* One of the values is picked from this array randomly
         * increase the frequency of value that you want to be picked more frequently
         */
        "values" : [4,5,6,7,7,8,8,8],
        "numberOfFish": 5
    }
    ]
}
