/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2025 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Decimal number to find between 0 and 4.")
    difficulty: 2
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 5,
                "fitLimits": true,
                "range": [0, 40],
                "steps": [1],
                "segments": [],
                "denominator": 10
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 5,
                "fitLimits": false,
                "range": [0,40],
                "steps": [1],
                "segments": [10,10],
                "denominator": 10
            }
        }
    ]
}
