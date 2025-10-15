/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Graduation to find between 1 and 7.")
    difficulty: 2
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [1, 7],
                "steps": [1],
                "segments": [],
                "denominator": 7,
                "useFractions": true
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0,8],
                "steps": [1],
                "segments": [4, 6],
                "denominator": 2,
                "useFractions": false
            }
        }
    ]
}
