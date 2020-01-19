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
    objective: qsTr("Select a number on dominoes up to 8")
    difficulty: 3
    data: [
      {
         "objective" : qsTr("Select the number 8"),
         "sublevels" : "6",
         "words" : [
            "8",
            "8"
        ]
     },
     {
        "objective" : qsTr("Select the number on dominoes from 7 to 8"),
        "sublevels" : "8",
        "words" : [
           "7",
           "8"
        ]
     },
     {
         "objective" : qsTr("Select the number on dominoes from 6 to 8"),
         "sublevels" : "10",
         "words" : [
            "6",
            "7",
            "8"
         ]
      },
      {
         "objective" : qsTr("Select the number on dominoes from 5 to 8"),
         "sublevels" : "12",
         "words" : [
            "5",
            "6",
            "7",
            "8"
         ]
      },
      {
         "objective" : qsTr("Select the number on dominoes from 4 to 8"),
         "sublevels" : "14",
         "words" : [
            "4",
            "5",
            "6",
            "7",
            "8"
         ]
      },
      {
         "objective" : qsTr("Select the number on dominoes from 3 to 8"),
         "sublevels" : "16",
         "words" : [
            "3",
            "4",
            "5",
            "6",
            "7",
            "8"
         ]
      },
      {
         "objective" : qsTr("Select the number on dominoes from 2 to 8"),
         "sublevels" : "18",
         "words" : [
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8"
         ]
      },
      {
         "objective" : qsTr("Select the number on dominoes from 1 to 8"),
         "sublevels" : "20",
         "words" : [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8"
         ]
      }
   ]
}
