/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "smallnumbers2/Smallnumbers2.qml"
  difficulty: 2
  icon: "smallnumbers2/smallnumbers2.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Numbers with dominoes")
  //: Help title
  description: qsTr("Count the number of dots on the dominoes before they reach the ground")
//  intro: "Count the number of the points on the dominoes then type the result on your keyboard."
  //: Help goal
  goal: qsTr("In a limited time, count the number of dots")
  //: Help prerequisite
  prerequisite: qsTr("Counting skills")
  //: Help manual
  manual: qsTr("With the keyboard, type the number of dots you see on the falling dominoes.")
  credit: ""
  section: "math numeration"
}
