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
    objective: qsTr("Descending order, 8 random numbers between 2 and 30.")
    difficulty: 4
    data: [
        {
            mode: "descending",
            random: true,           // Set this true to override values array with random values
            minNumber: 2,
            maxNumber: 30,
            numberOfElementsToOrder: 8
        }
    ]
}
