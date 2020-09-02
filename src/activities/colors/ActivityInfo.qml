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
  name: "colors/Colors.qml"
  difficulty: 1
  icon: "colors/colors.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Colors")
  //: Help title
  description: qsTr("Click on the right color.")
//  intro: "Click on the right color"
  //: Help goal
  goal: qsTr("This activity teaches you to recognize different colors.")
  //: Help prerequisite
  prerequisite: qsTr("Identifying colours.")
  //: Help manual
  manual: qsTr("Listen to the color and click on the matching duck.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an answer") + ("</li></li>") +
          qsTr("Tab: repeat the question") + ("</li></li>")
  credit: ""
  section: "reading color vocabulary"
  createdInVersion: 0
}
