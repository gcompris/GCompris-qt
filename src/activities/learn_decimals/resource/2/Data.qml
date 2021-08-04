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
    objective: qsTr("Between 1 and 5.")
    difficulty: 5
    data: [
        // maxValue represents the maximum decimal number generated.
        {
            "numberOfSubLevels": 10,
            "minValue" : 1,
            "maxValue" : 5
        }
    ]
}
