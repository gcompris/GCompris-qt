/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Enumerate up to %1 fruits.").arg("4")
    difficulty: 1
    data: [
        {
            "subLevels" : 4,
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 2
        },
        {
            "subLevels" : 4,
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 3
        },
        {
            "subLevels" : 4,
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 4
        }
    ]
}
