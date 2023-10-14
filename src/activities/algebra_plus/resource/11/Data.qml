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
    objective: qsTr("Additions with numbers up to 10.")
    difficulty: 5
    data: [
        {
            "min": 0,
            "max": 10,
            "limit": 0,
        }
    ]
}
