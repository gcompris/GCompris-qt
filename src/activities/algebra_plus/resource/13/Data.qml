/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Additions resulting up to 100.")
    difficulty: 6
    data: [
        {
            "min": 0,
            "max": 100,
            "limit": 100
        }
    ]
}
