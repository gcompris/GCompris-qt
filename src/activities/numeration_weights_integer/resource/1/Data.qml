/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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
    objective: qsTr("Drag the different numbers weights to obtain a number between 1 and 99.")
    difficulty: 1
    data: [
      {
         "level" : "1",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 9"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         //"smallerNumberClass": "Decimal Part",
         "biggerNumberClass": "Milliard class",
         "numbers" : [
            "4",
            "1",
            "5",
            "6",
            "8",
            "2",
            "9",
            "3",
            "7",
            "10"
         ]
      },
      {
         "level" : "2",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 20."),
         "numbers" : [
            "14",
            "2",
            "11",
            "2",
            "7",
            "18",
            "5",
            "19",
            "13",
            "20"
         ]
      },
      {
         "level" : "3",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 40"),
         "numbers" : [
            "14",
            "2",
            "22",
            "2",
            "37",
            "38",
            "5",
            "29",
            "13",
            "40"
         ]
      },
      {
         "level" : "4",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 60"),
         "numbers" : [
            "54",
            "23",
            "22",
            "2",
            "43",
            "57",
            "5",
            "39",
            "53",
            "60"
         ]
      },
      {
         "level" : "5",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 99"),
         "numbers" : [
            "64",
            "13",
            "82",
            "92",
            "44",
            "77",
            "85",
            "9",
            "53",
            "99"
         ]
      }
    ]
}
