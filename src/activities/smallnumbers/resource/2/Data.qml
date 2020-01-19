/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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
    objective: qsTr("Select a number on dice up to 4")
    difficulty: 2
    data: [
      {
         "objective" : qsTr("Select the number 4"),
         "sublevels" : "6",
         "words" : [
            "4",
            "4"
        ]
      },
      {
         "objective" : qsTr("Select the number on dice from 3 to 4"),
         "sublevels" : "8",
         "words" : [
            "3",
            "4"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 2 to 4"),
         "sublevels" : "10",
         "words" : [
            "2",
            "3",
            "4"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 1 to 4"),
         "sublevels" : "12",
         "words" : [
            "1",
            "2",
            "3",
            "4"
         ]
      }
   ]
}
