/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Group 2 types of fruit and enumerate each group (5 fruit max).")
    difficulty: 2
    data: [
        {
            "objective": qsTr("Group 2 types of fruit and enumerate each group (3 fruit max)."),
            "sublevels" : "4",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 3
        },
        {
            "objective": qsTr("Group 2 types of fruit and enumerate each group (4 fruit max)."),
            "sublevels" : "4",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 4
        },
        {
            "objective": qsTr("Group 2 types of fruit and enumerate each group (5 fruit max)."),
            "sublevels" : "4",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 5
        }
    ]
}
