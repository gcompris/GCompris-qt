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
  name: "memory-enumerate/MemoryEnumerate.qml"
  difficulty: 2
  icon: "memory-enumerate/memory-enumerate.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Enumeration memory game")
  //: Help title
  description: qsTr("Flip the cards to match a number with a picture.")
//  intro: "Match a number card with a card displaying the same number of butterflies."
  //: Help goal
  goal: qsTr("Numeration training, memory.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Each card is hiding either a picture with a number of items, or a number. You have to match the numbers with the corresponding pictures.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
