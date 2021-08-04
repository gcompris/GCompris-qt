/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Between 20 and 50.")
    difficulty: 3
    data: [
        {
            "numberOfSubLevels": 5,
            "minValue" : 20,
            "maxValue" : 50
        }
    ]
}
