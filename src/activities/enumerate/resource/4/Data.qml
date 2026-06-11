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
    objective: qsTr("Group %1 types of fruit and enumerate each group (%2 fruits max).").arg("4").arg("9")
    difficulty: 3
    data: [
        {
            "subLevels" : 5,
            "numberOfItemType" : 4,
            "numberOfItemMax"  : 6
        },
        {
            "subLevels" : 5,
            "numberOfItemType" : 4,
            "numberOfItemMax"  : 7
        },
        {
            "subLevels" : 5,
            "numberOfItemType" : 4,
            "numberOfItemMax"  : 8
        },
        {
            "subLevels" : 5,
            "numberOfItemType" : 4,
            "numberOfItemMax"  : 9
        }
    ]
}
