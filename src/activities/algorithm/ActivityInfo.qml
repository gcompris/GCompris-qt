/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bharath M S <brat.197@gmail.com>
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
  name: "algorithm/Algorithm.qml"
  difficulty: 2
  icon: "algorithm/algorithm.svg"
  author: "Bharath M S &lt;brat.197@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Logical associations")
  //: Help title
  description: qsTr("Complete the arrangement of fruits")
//  intro: "Click on the missing items on the table and follow the logical sequence displayed above it."
  //: Help goal
  goal: qsTr("Logic training activity")
  //: Help manual
  manual: qsTr("Look at the two sequences. Each fruit in the first sequence has been replaced by another fruit in the second sequence. Complete the second sequence by using the correct fruits, after studying this pattern.")
  credit: ""
  section: "discovery"
}
