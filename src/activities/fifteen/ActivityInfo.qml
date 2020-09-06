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
  name: "fifteen/Fifteen.qml"
  difficulty: 5
  icon: "fifteen/fifteen.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("The fifteen game")
  //: Help title
  description: qsTr("Move each item to recreate the image.")
  //intro: "Click or drag an element next to a free space, the element will move and release its space. You must put all the pieces in the correct order. The numbers on the pieces can help you."
  //: Help goal
  goal: qsTr("Arrange the pieces in the right order.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click or drag on any piece next to the empty space, and it will move to the empty space.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move a piece to the empty space.") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 0
}
