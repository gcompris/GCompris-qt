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
    objective: qsTr("Additions with 1 and 2.")
    difficulty: 2

    data: [
        {
            questionsArray: ["1 + 1", "1 + 2", "2 + 2"],
            answersArray: [2,3,4],
            circlesModel: 4

        }
    ]
}
