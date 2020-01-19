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
    objective: qsTr("Select a number on dice up to 9")
    difficulty: 3
    data: [
      {
         "objective" : qsTr("Select the number 9"),
         "sublevels" : "6",
         "words" : [
            "9",
            "9"
        ]
      },
      {
         "objective" : qsTr("Select the number on dice from 8 to 9"),
         "sublevels" : "8",
         "words" : [
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 7 to 9"),
         "sublevels" : "10",
         "words" : [
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 6 to 9"),
         "sublevels" : "12",
         "words" : [
            "6",
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 5 to 9"),
         "sublevels" : "14",
         "words" : [
            "5",
            "6",
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 4 to 9"),
         "sublevels" : "16",
         "words" : [
            "4",
            "5",
            "6",
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 3 to 9"),
         "sublevels" : "18",
         "words" : [
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 2 to 9"),
         "sublevels" : "20",
         "words" : [
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9"
         ]
      },
      {
         "objective" : qsTr("Select the number on dice from 1 to 9"),
         "sublevels" : "22",
         "words" : [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9"
         ]
      }
   ]
}
