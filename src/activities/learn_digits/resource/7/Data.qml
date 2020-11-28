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
    objective: qsTr("Digits from 1 to 8.")
    difficulty: 3

    data: [
        {
            questionsArray: [1, 2, 3, 4, 5, 6, 7, 8],
            circlesModel: 9
        }
    ]
}
