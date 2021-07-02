/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Add decimal numbers up to 3.")
    difficulty: 2
    data: [
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 0.5
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.3,
            "maxValue" : 0.6
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 0.9
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 1
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 1.5
        }
    ]
}
