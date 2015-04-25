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
  name: "advanced_colors/AdvancedColors.qml"
  difficulty: 6
  icon: "advanced_colors/advanced_colors.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Advanced colors")
  description: qsTr("Select the butterfly of the correct color")
  //intro: "find the dancing butterfly having the requested color"
  goal: qsTr("Learn to recognize unusual colors.")
  prerequisite: qsTr("Can read")
  manual: qsTr("You will see dancing butterflies of different colors and a question. You have to find the correct butterfly and touch it.")
  credit: ""
  section: "discovery colors"
}
