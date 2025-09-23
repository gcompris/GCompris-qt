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
    objective: qsTr("Between 0.1 and 1.")
    difficulty: 5
    data:  [
        {
            "shuffle": true,
            "subLevels":  [
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 1
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 1
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 1
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 1
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 1
                },

            ]
        }
    ]
}
