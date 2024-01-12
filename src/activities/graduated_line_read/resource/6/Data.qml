/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Number to find between 0 and 100.")
    difficulty: 4
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 100],
                "steps": [10],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 100],
                "steps": [5, 10],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 100],
                "steps": [10],
                "segments": [3, 10]
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 15,
                "fitLimits": false,
                "range": [0, 100],
                "steps": [10, 20],
                "segments": [2, 8]
            }
        }
    ]
}
