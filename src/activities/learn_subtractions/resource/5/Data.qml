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
    objective: qsTr("Subtractions with 1, 2, 3, 4, 5, 6, 7, 8 and 9.")
    difficulty: 3

    data: [
        {
            questionsArray: ["9 - 2", "6 - 3", "8 - 5", "9 - 6", "9 - 5", "8 - 3", "6 - 5", "4 - 1", "8 - 2", "9 - 7"],
            answersArray: [7,3,3,3,4,5,1,3,6,2],
            circlesModel: 9
        }
    ]
}
