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
  name: "multiplication-tables/MultiplicationTables.qml"
  difficulty: 2
  icon: "multiplication-tables/multiplication-tables.svg"
  author: "Varun Kumar &lt;varun13169@iiitd.ac.in&gt;"
  demo: true
  title: qsTr("Let's Break Some Tables")
  description: qsTr("Count and color square boxes based on the table shown on the right side")
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("Understand crux of multiplication and memoorization of essential multiplication tables")
  prerequisite: qsTr("Familiarisation with concept of multiplication and tables")
  manual: qsTr("Number for which multiplication table will be made is shown on upper-right of the screen.
Multiplicand and multiplier along with result are shown one by one, each time child has to count number of squares and fill them with red color, then 'click to verify your answer button'.
If child colored apropriate squares then next iteration of the table is shown, and so on.
After 10 iterations level is incremented.
For better understanding of this game please go through: http://www.infomontessori.com/mathematics/tables-of-arithmetic-multiplication-board.htm" )
  credit: "http://www.infomontessori.com/mathematics/tables-of-arithmetic-multiplication-board.htm"
  section: "math"
  createdInVersion: 6000
}
