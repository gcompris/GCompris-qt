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
    objective: qsTr("Numbers between %1 and %2.").arg(1).arg(2)
    difficulty: 1
    data: [
    {
        "maxNumber": 1, /* Max number on each domino side */
        /* One of the values is picked from this array randomly
         * increase the frequency of value that you want to be picked more frequently
         */
        "values" : [1,2],   /* Special case, size 2 */
        "numberOfFish": 5
    }
    ]
}
