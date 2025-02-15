/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Graduation to find between 1 and 10.")
    difficulty: 2
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [1, 10],
                "steps": [1],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [1, 10],
                "steps": [1],
                "segments": [5, 9]
            }
        }
    ]
}
