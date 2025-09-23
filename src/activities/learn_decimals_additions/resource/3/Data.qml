/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Add decimal numbers up to 5.")
    difficulty: 5
    data: [
        {
            "shuffle": true,
            "subLevels":  [
                {
                    "inputType": "range",
                    "minValue": 0.6,
                    "maxValue": 2.5
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 3
                },
                {
                    "inputType": "range",
                    "minValue": 1,
                    "maxValue": 3.5
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 4
                },
                {
                    "inputType": "range",
                    "minValue": 2,
                    "maxValue": 4.5
                },
            ]
        }
    ]
}
