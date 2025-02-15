/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Number to find between 0 and 10 000.")
    difficulty: 4
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 10000],
                "steps": [500, 1000],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 10000],
                "steps": [500, 1000, 2000],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 10000],
                "steps": [100, 1000],
                "segments": [5, 10]
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 15,
                "fitLimits": false,
                "range": [0, 10000],
                "steps": [100, 1000, 2000],
                "segments": [4, 12]
            }
        }
    ]
}
