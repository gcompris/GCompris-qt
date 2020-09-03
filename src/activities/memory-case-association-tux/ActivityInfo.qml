/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
  name: "memory-case-association-tux/MemoryCaseAssociationTux.qml"
  difficulty: 2
  icon: "memory-case-association-tux/memory-case-association-tux.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Case association memory game against Tux")
  //: Help title
  description: qsTr("Flip the cards to find the uppercase and lowercase of the same letter, playing against Tux.")
  //intro: "Match the upper case card with its lower case pair."
  //: Help goal
  goal: qsTr("Learning lowercase and uppercase letters, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Knowing alphabets")
  //: Help manual
  manual: qsTr("Each card is hiding a letter, lowercase or uppercase. You have to match the lowercase and uppercase of the same letter.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "reading letters"
  createdInVersion: 9000
}
