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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "smallnumbers2/Smallnumbers2.qml"
  difficulty: 2
  icon: "smallnumbers2/smallnumbers2.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Numbers with Dominoes")
  //: Help title
  description: qsTr("Count the number on the domino before it reaches the ground.")
//  intro: "Count the numbers on the dominoes then type the result on your keyboard."
  //: Help goal
  goal: qsTr("Count a number in a limited time.")
  //: Help prerequisite
  prerequisite: qsTr("Counting skills")
  //: Help manual
  manual: qsTr("Type the number you see on each falling domino.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
