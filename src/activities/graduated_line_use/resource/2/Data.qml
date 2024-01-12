/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

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
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [1,7],
                "steps": [1],
                "segments": [4, 6]
            }
        }
    ]
}
