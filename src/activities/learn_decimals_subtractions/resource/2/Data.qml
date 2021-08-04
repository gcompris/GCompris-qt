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
    objective: qsTr("Subtract decimal numbers up to 3.")
    difficulty: 5
    data: [
        // maxValue represents the maximum decimal number generated.
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 1.8
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 2
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.5,
            "maxValue" : 2.4
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 2.8
        },
        {
            "numberOfSubLevels": 1,
            "minValue" : 0.1,
            "maxValue" : 3
        }
    ]
}
