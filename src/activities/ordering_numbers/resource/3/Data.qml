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
    objective: qsTr("Ascending order, 5 random numbers between 2 and 10.")
    difficulty: 4
    data: [
        {
            mode: "ascending",
            random: true,          // Set this true to override values array with random values
            minNumber: 2,
            maxNumber: 10,
            numberOfElementsToOrder: 5
        }
    ]
}
