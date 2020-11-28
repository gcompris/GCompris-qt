/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("Subtractions with 1, 2, 3 and 4.")
    difficulty: 3

    data: [
        {
            questionsArray: ["2 - 1", "3 - 1", "3 - 2", "4 - 1", "4 - 2", "4 - 3"],
            answersArray: [1,2,1,3,2,1],
            circlesModel: 4

        }
    ]
}
