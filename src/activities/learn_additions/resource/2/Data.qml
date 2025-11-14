/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

Data {
    objective: qsTr("Additions with 1, 2 and 3.")
    difficulty: 3

    data: [
        {
            questionsArray: ["1 + 1", "1 + 2", "1 + 3", "2 + 2", "2 + 3", "3 + 3"],
            circlesModel: 6,
            randomOrder: true
        }
    ]
}
