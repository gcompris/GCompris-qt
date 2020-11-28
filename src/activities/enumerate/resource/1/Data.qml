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
    objective: qsTr("Enumerate up to 4 fruit.")
    difficulty: 1
    data: [
        {
            "objective": qsTr("Enumerate up to 2 fruit."),
            "sublevels" : "4",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 2
        },
        {
            "objective": qsTr("Enumerate up to 3 fruit."),
            "sublevels" : "4",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 3
        },
        {
            "objective": qsTr("Enumerate up to 4 fruit."),
            "sublevels" : "4",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 4
        }
    ]
}
