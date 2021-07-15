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
    objective: qsTr("Add stars up to 3.")
    difficulty: 1
    data: [
        {
            "maxValue": 3,
            "minStars" : [1, 0, 0],
            "maxStars" : [2, 0, 0]
        },
        {
            "maxValue": 3,
            "minStars" : [2, 0, 0],
            "maxStars" : [3, 0, 0]
        }
    ]
}
