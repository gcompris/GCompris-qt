/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 *
 * Authors:
 *   Alexandre Laurent <littlewhite.dev@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Subtractions from number up to 100.")
    difficulty: 6
    data: [
        {
            "min": 0,
            "max": 100,
            "limit": 0,
        }
    ]
}
