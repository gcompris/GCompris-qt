/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Subtractions with left-operand up to 20.")
    difficulty: 6
    data: [
        {
            "min": 0,
            "max": 20,
            "limit": 0,
        }
    ]
}
