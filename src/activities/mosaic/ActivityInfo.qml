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
  name: "mosaic/Mosaic.qml"
  difficulty: 1
  icon: "mosaic/mosaic.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Rebuild the mosaic")
  //: Help title
  description: qsTr("Put each item at the same place as in the given example.")
//  intro: "Put each item at the same place as in the given example."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("First select an item from the list, and then click on a spot of the mosaic to place the item.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate inside an area") + ("</li><li>") +
          qsTr("Space or Enter: select or place an item") + ("</li><li>") +
          qsTr("Tab: navigate between the item list and the mosaic") + ("</li></ul>")
  credit: ""
  section: "puzzle"
  createdInVersion: 0
  levels: "1,2,3,4"
}
