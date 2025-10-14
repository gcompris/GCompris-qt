/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Count up to 15 (without counter and without values visible).")
    difficulty: 1
    data: [
        {
            "shuffle": true,
            "bulbCount": 4,
            "numbersToBeConverted": [3, 12, 5, 10, 15, 11],
            "enableHelp": false,
            "bulbValueVisible": false
        }
    ]
}
