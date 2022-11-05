/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Edgar Hipp <hipp.edg@gmail.com>
 *
 * Authors:
 *   Edgar Hipp <hipp.edg@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("Subtractions with 1, 2, 3, 4, 5, 6 and 7.")
    difficulty: 3

    data: [
        {
            questionsArray: ["7 - 4", "7 - 7", "4 - 2", "7 - 1", "7 - 3", "6 - 4", "5 - 1", "7 - 2", "5 - 3", "6 - 1"],
            answersArray: [3,0,2,6,4,2,4,5,2,5],
            circlesModel: 7

        }
    ]
}
