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
  name: "memory-wordnumber/MemoryWordnumber.qml"
  difficulty: 3
  icon: "memory-wordnumber/memory-wordnumber.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Wordnumber memory game")
  //: Help title
  description: qsTr("Flip the cards to match a numeral with its number name.")
//  intro: "Match the numeric with the word."
  //: Help goal
  goal: qsTr("Reading numbers, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("Each card is hiding either a numeral (a number written in figures), or a number name (a number written in words). You have to match the numerals with the corresponding number names.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
}
