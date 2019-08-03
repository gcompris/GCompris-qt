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
import QtQuick 2.6
import GCompris 1.0
import "../../../../core"

Dataset {
    objective: qsTr("Select a number on dominoes up to 4")
    difficulty: 1
    data: [
      {
         "level" : "1",
         "objective" : qsTr("Select the number on dominoes up to 2"),
         "words" : [
            "1",
            "2"
         ]
      },
      {
         "level" : "2",
         "objective" : qsTr("Select the number on dominoes up to 3"),
         "words" : [
            "1",
            "2",
            "3",
         ]
      },
      {
         "level" : "3",
         "objective" : qsTr("Select the number on dominoes up to 4"),
         "words" : [
            "1",
            "2",
            "3",
            "4"
         ]
      }
   ]
}
