/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Numbers up to 3.")
    difficulty: 1
    data: [
      {
        "objective" : qsTr("Type the number on the dice, 1 or 2."),
        "sublevels" : "8",
        "words" : [
           "1",
           "2"
        ]
      },
      {
         "objective" : qsTr("Type the number on the dice, from 1 to 3."),
         "sublevels" : "10",
         "words" : [
            "1",
            "2",
            "3",
            "3"
         ]
      }
   ]
}
