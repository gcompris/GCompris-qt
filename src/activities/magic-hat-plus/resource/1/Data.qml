/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/* Dataset details:
 *
 *  data: [
 *
 *      { // Example without coefficients ("useCoefficients": false, or not defined).
 *
 *          // Maximum number of stars for each row of the result. Must be between 1 and 10.
 *          "maxResultPerRow": 3,
 *          // If true, each row uses a different set of stars. (initialized to false by default if not defined)
 *          "useDifferentStars": false,
 *          // maximum number of stars for each row of first operand. First number should be at least 1 for additions, others between 0 and 10.
 *          "maxStars": [3, 0, 0],
 *          // minimum number of stars for each row of first operand. First number should be at least 1 for additions, others between 0 and 10.
 *          // All numbers should not be larger than the corresponding ones in maxStars.
 *          "minStars": [1, 0, 0]
 *      },
 *      { // Example with coefficients ("useCoefficients": true)
 *        // (maxResultPerRow, maxStars and minStars are auto-generated, useDifferentStars is not used).
 *
 *          "useCoefficients:" false,
 *          // "multiplier" can use the following values: 1, 10, 100.
 *          // Coefficients are generated for each row depending on given values (see rowCoefficients).
 *          // The maximum result will then be (multiplier * 100).
 *          "multiplier": 1,
 *          // Base coefficient for each row. First number should be at least 1, others between 0 and 10.
 *          // Each row's coefficient will be equal to the given number * multiplier.
 *          // If a row's base coefficient is 0, it will not have any stars.
 *          // IMPORTANT: The 3 values added together must not be greater than 10!
 *          "rowCoefficients": [4, 4, 2],
 *      }
 *
 *  ]
 */

Data {
    objective: qsTr("Add stars up to 3.")
    difficulty: 1
    data: [
        {
            "maxResultPerRow": 3,
            "minStars": [1, 0, 0],
            "maxStars": [1, 0, 0]
        },
        {
            "maxResultPerRow": 3,
            "minStars" : [1, 0, 0],
            "maxStars" : [2, 0, 0]
        }
    ]
}
