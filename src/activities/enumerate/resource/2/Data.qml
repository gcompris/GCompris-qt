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
    objective: qsTr("Group %1 types of fruit and enumerate each group (%2 fruits max).").arg(2).arg(5)
    difficulty: 2
    data: [
        {
            "subLevels" : 4,
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 3
        },
        {
            "subLevels" : 4,
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 4
        },
        {
            "subLevels" : 4,
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 5
        }
    ]
}
