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
    objective: qsTr("Numbers up to 5.")
    difficulty: 2
    data: [
      {
         "objective" : qsTr("Type the number on the dice, from 1 to 5."),
         "sublevels" : "14",
         "words" : [
            "1",
            "2",
            "3",
            "4",
            "5",
            "5",
            "5",
            "5"
         ]
      }
   ]
}
