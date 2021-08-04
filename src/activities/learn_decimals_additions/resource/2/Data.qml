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
    difficulty: 5
    data: [
        // maxValue represents the maximum addition result.
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 1
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.3,
            "maxValue" : 1.5
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 2
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 2.5
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 3
        }
    ]
}
