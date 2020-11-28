/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Numbers up to 6.")
    difficulty: 3
    data: [
      {
         "objective" : qsTr("Type the number on the dice, from 1 to 6."),
         "sublevels" : "16",
         "words" : [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "6",
            "6",
            "6",
            "6"
         ]
      }
   ]
}
