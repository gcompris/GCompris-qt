/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import "../../../../core"

Dataset {
    objective: qsTr("Group 2 types of fruits and Enumerate each group (6 fruits max)")
    difficulty: 2
    data: [
        {
            "objective": qsTr("Enumerate up to 4 fruits"),
            "sublevels" : "4",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 4
        },
        {
            "objective": qsTr("Group 2 types of fruits and enumerate each group (4 fruits max)"),
            "sublevels" : "4",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 4
        },
        {
            "objective": qsTr("Enumerate up to 5 fruits"),
            "sublevels" : "5",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 5
        },
        {
            "objective": qsTr("Group 2 types of fruits and enumerate each group (5 fruits max)"),
            "sublevels" : "5",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 5
        },
        {
            "objective": qsTr("Enumerate up to 6 fruits"),
            "sublevels" : "6",
            "numberOfItemType" : 1,
            "numberOfItemMax"  : 6
        },
        {
            "objective": qsTr("Group 2 types of fruits and enumerate each group (6 fruits max)"),
            "sublevels" : "6",
            "numberOfItemType" : 2,
            "numberOfItemMax"  : 6
        }
    ]
}
