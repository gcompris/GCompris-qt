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
    objective: qsTr("Calculate remaining stars up to 4.")
    difficulty: 1
    data: [
        {
            "maxValue": 4,
            "minStars" : [2, 0, 0],
            "maxStars" : [4, 0, 0]
        },
        {
            "maxValue": 4,
            "minStars" : [2, 0, 0],
            "maxStars" : [5, 0, 0]
        }
    ]
}
