/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Graduation to find between 0 and 20.")
    difficulty: 3
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 8,
                "fitLimits": true,
                "range": [0, 20],
                "steps": [1],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 8,
                "fitLimits": true,
                "range": [0, 20],
                "steps": [2],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 20],
                "steps": [1, 2, 4],
                "segments": [5, 10]
            }
        }
    ]
}
