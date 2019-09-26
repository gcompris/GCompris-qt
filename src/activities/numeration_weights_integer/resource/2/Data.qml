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
    objective: qsTr("Drag the different numbers weights to obtain a number between 1 and 999.")
    difficulty: 1
    data: [
      {
         "level" : "1",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 99"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         //"smallerNumberClass": "Decimal Part",
         "biggerNumberClass": "Milliard class",
         "numbers" : [
            "40",
            "10",
            "50",
            "65",
            "82",
            "95",
            "25",
            "37",
            "86",
            "99"
         ]
      },
      {
         "level" : "2",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 199."),
         "numbers" : [
            "155",
            "10",
            "125",
            "15",
            "109",
            "56",
            "101",
            "158",
            "89",
            "112"
         ]
      },
      {
         "level" : "3",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 300"),
         "numbers" : [
            "256",
            "122",
            "85",
            "215",
            "288",
            "105",
            "203",
            "158",
            "89",
            "109"
         ]
      },
      {
         "level" : "4",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 700"),
         "numbers" : [
            "556",
            "422",
            "285",
            "615",
            "588",
            "105",
            "303",
            "358",
            "689",
            "699"
         ]
      },
      {
         "level" : "5",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 999"),
         "numbers" : [
            "62",
            "822",
            "900",
            "600",
            "689",
            "5",
            "685",
            "956",
            "123",
            "999"
         ]
      }
    ]
}
