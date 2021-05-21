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
    objective: qsTr("Ascending order, 8 random numbers between 2 and 30.")
    difficulty: 4
    data: [
        {
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            mode: "ascending",      // Either ascending or descending
            random: true,           // Set this true to override values array with random values
            minNumber: 2,
            maxNumber: 30,
            numberOfElementsToOrder: 8
        }
    ]
}
