/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 * When fitLimits is true:
 *  - the number of steps must be a divisor of the upper limit
 *  - segments is not used (empty)
 * range[min, max] (pair) ruler's min and max values
 * steps[a, b, c, ...] (list) of possible step values
 * segments[min, max] (pair) number of segments (random within interval). Unused when fitLimits is true
 *
 * Number of graduations = number of segments + 1
 * Constraint : segments[max] * steps[max] <= range[max] (Minimal check made with js: console warning and values adjusted)
 */
import GCompris 1.0

Data {
    objective: qsTr("Graduation to find between 1 and 5.")
    difficulty: 1
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 6,
                "fitLimits": true,
                "range": [1,5],
                "steps": [1],
                "segments": []
            }
        }
    ]
}
