/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Graduation to find between 0 and 1 000.")
    difficulty: 4
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 1000],
                "steps": [50, 100],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 1000],
                "steps": [50, 100],
                "segments": [5, 10]
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 15,
                "fitLimits": false,
                "range": [0, 1000],
                "steps": [10, 100, 200],
                "segments": [4, 12]
            }
        }
    ]
}
