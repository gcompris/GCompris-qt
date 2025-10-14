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
    objective: qsTr("Count up to 3 (without counter and with values visible).")
    difficulty: 1
    data: [
        {
            "shuffle": true,
            "bulbCount": 2,
            "numbersToBeConverted": [1, 2, 3],
            "enableHelp": false,
            "bulbValueVisible": true
        }
    ]
}
