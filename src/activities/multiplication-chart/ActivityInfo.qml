/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Varun Kumar <varun13169@iiitd.ac.in>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "multiplication-chart/MultiplicationChart.qml"
  difficulty: 1
  icon: "multiplication-chart/multiplication-chart.svg"
  author: "Varun Kumar &lt;varun13169@iiitd.ac.in&gt;"
  demo: true
  title: qsTr("Multiplication Chart")
  description: qsTr("Simple Multiplication of numbers from 1-10")
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("To multiply the given operands, select them on the board and state the answer")

  prerequisite: qsTr("Simple Intro to multiplication (not a necessity)")

  manual: qsTr(" Multiplicand x Multiplier = Answer\n")+
          qsTr("    1) Select the Column\n")+
          qsTr("    2) Select the Row\n")+
          qsTr("    3) State the answer\n")+
          qsTr("    4) Press Enter\n")

  credit: qsTr("Montessori Multiplication Charts: http://www.infomontessori.com/mathematics/tables-of-arithmetic-multiplication-charts.htm")

  section: "math"
  createdInVersion: 6000
}
