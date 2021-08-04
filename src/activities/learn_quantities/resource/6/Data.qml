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
    objective: qsTr("Between 10 and 20.")
    difficulty: 2
    data: [
        {
            "numberOfSubLevels": 5,
            "minValue" : 10,
            "maxValue" : 20
        }
    ]
}
