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
    objective: qsTr("Add decimal numbers up to 3.")
    difficulty: 1
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
                    "minValue": 0.3,
                    "maxValue": 1.5
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 2
                },
                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 2.5
                },

                {
                    "inputType": "range",
                    "minValue": 0.1,
                    "maxValue": 3
                },

            ]
        }
    ]
}
