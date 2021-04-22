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
    objective: qsTr("Numbers between %1 and %2.").arg(11).arg(15)
    difficulty: 3
    data: [
    {
        "maxNumber": 9, /* Max number on each domino side */
        /* One of the values is picked from this array randomly
         * increase the frequency of value that you want to be picked more frequently
         */
        "values" : [11,12,13,14,14,15,15,15],
        "numberOfFish": 5
    }
    ]
}
