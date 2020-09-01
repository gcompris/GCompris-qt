/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Arkit Vora <arkitvora123@gmail.com>
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
  name: "braille_alphabets/BrailleAlphabets.qml"
  difficulty: 5
  icon: "braille_alphabets/braille_alphabets.svg"
  author: "Arkit Vora &lt;arkitvora123@gmail.com&gt;"
  //: Activity title
  title: qsTr("Discover the braille system")
  //: Help title
  description: qsTr("Learn and memorize the braille system.")
  //intro: "Click on Tux to start and then re-create the Braille cells."
  //: Help goal
  goal: qsTr("Let children discover the braille system.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("The screen has 3 sections: an interactive braille cell, an instruction telling you the character to reproduce, and at the top the braille characters to use as a reference. Each level teaches a set of 10 characters.") + " " +  qsTr("Reproduce the requested character in the interactive braille cell.") + ("<br><br>") +
  qsTr("You can open the braille chart by clicking on the blue braille cell icon.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: 1 to 6 select/deselect the corresponding dots") + ("</li><li>") +
          qsTr("Space: open or close the braille chart") + ("</li></ul>")
  credit: ""
  section: "reading letters braille"
  createdInVersion: 0
}
