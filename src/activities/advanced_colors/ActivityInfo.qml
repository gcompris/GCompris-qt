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
  name: "advanced_colors/AdvancedColors.qml"
  difficulty: 6
  icon: "advanced_colors/advanced_colors.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Advanced colors")
  //: Help title
  description: qsTr("Select the butterfly of the correct color")
  //intro: "click on the required color"
  //: Help goal
  goal: qsTr("Learn to recognize unusual colors.")
  //: Help prerequisite
  prerequisite: qsTr("Can read")
  //: Help manual
  manual: qsTr("You will see dancing butterflies of different colors and a question. You have to find the correct butterfly and touch it.")
  credit: ""
  section: "reading colors vocabulary"
  createdInVersion: 0
}
