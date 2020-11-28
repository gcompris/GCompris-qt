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
    objective: qsTr("Numbers up to 4.")
    difficulty: 2
    data: [
      {
         "objective" : qsTr("Type the number on the dice, from 1 to 4."),
         "sublevels" : "12",
         "words" : [
            "1",
            "2",
            "3",
            "4",
            "4",
            "4"
         ]
      }
   ]
}
