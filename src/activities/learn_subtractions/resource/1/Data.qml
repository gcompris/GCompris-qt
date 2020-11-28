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
    objective: qsTr("Subtractions with 1, 2 and 3.")
    difficulty: 2

    data: [
        {
            questionsArray: ["2 - 1", "3 - 1", "3 - 2"],
            answersArray: [1,2,1],
            circlesModel: 3

        }
    ]
}
