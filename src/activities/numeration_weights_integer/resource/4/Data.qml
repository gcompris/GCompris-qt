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
    objective: qsTr("Drag the different numbers weights to obtain a number between 1 and 999 999 999.")
    difficulty: 1
    data: [
      {
         "level" : "1",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 999 999 999"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         "biggerNumberClass": "Million class",
         "numbers" : [
            "123456789",
            "465465444",
            "132465423",
            "432321123",
            "254213212",
            "132132215",
            "2578",
            "1237",
            "2186",
            "1199"
         ]
      },
      {
         "level" : "2",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 15 000."),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         "biggerNumberClass": "Thousand class",
         "numbers" : [
            "11155",
            "203",
            "12500",
            "11256",
            "10900",
            "5641",
            "101",
            "12856",
            "12389",
            "11200"
         ]
      },
      {
         "level" : "3",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 300 000"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         "biggerNumberClass": "Thousand class",
         "numbers" : [
            "232256",
            "126122",
            "152385",
            "2155",
            "28855",
            "123105",
            "245203",
            "289158",
            "250489",
            "109000"
         ]
      },
      {
         "level" : "4",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 600 000"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         "biggerNumberClass": "Thousand class",
         "numbers" : [
            "546556",
            "422454",
            "285454",
            "415456",
            "235588",
            "10555",
            "3034",
            "125358",
            "565689",
            "213699"
         ]
      },
      {
         "level" : "5",
         "objective" : qsTr("Drag the number weights in the right cells to create numbers up to 999 999"),
         //possible smallerNumberClass are "Decimal Part","Unit class","Thousand class","Million class","Milliard class"
         "smallerNumberClass": "Unit class",
         "biggerNumberClass": "Thousand class",
         "numbers" : [
            "995662",
            "822654",
            "900564",
            "600454",
            "645489",
            "544",
            "685554",
            "945456",
            "145423",
            "955599"
         ]
      }
    ]
}
