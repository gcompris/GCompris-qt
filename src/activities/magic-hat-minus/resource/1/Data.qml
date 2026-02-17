/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/* Dataset details:

    data: [
        {
            // Maximum result value.
            "maxValue": 3,
            // minimum number of stars for each row.
            "minStars": [2, 0, 0],
            // maximum number of stars for each row.
            "maxStars": [3, 0, 0],
            // option to use different set of stars with different shape/color for each row.
            // set to false by default.
            // If true, maxValue and all minStars and maxStars values should not be more than 10.
            "useDifferentStars": false
        }

    ]
*/

Data {
    objective: qsTr("Calculate remaining stars up to 3.")
    difficulty: 1
    data: [
        {
            "maxValue": 3,
            "minStars" : [2, 0, 0],
            "maxStars" : [4, 0, 0]
        },
        {
            "maxValue": 3,
            "minStars" : [2, 0, 0],
            "maxStars" : [3, 0, 0]
        }
    ]
}
