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
    objective: qsTr("Additions with 1, 2, 3 and 4.")
    difficulty: 3

    data: [
        {
            questionsArray: ["1 + 1", "1 + 2", "1 + 3", "1 + 4", "2 + 2", "2 + 3", "2 + 4", "3 + 3", "3 + 4", "4 + 4"],
            answersArray: [2,3,4,5,4,5,6,6,7,8],
            circlesModel: 9

        }
    ]
}
