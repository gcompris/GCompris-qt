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
    objective: qsTr("Basic decimal numbers.")
    difficulty: 1
    data: [
        {
            "numberOfSubLevels": 5,
            "minValue" : 0,
            "maxValue" : 1
        },
        {
            "numberOfSubLevels": 10,
            "minValue" : 1,
            "maxValue" : 5
        }
    ]
}
