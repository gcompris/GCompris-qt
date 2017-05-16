/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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
  name: "share/Share.qml"
  difficulty: 2
  icon: "share/share.svg"
  author: "Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  demo: true
  title: qsTr("Share the candies")
  description: qsTr("Try to split the candies to a given number of children")
  //intro: "Share the candies equally among the specified number of children and notice that there may be a rest left"
  goal: qsTr("Learn the division of numbers")
  prerequisite: qsTr("Know how to count")
  manual: qsTr("Follow the instructions shown on the screen: first, drag the given number of boys/girls to the middle, then drag candies to each child's rectangle.")
  credit: ""
  section: "math"
  createdInVersion: 7000
}
