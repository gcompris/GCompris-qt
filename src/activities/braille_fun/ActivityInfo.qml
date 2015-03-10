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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "braille_fun/BrailleFun.qml"
  difficulty: 6
  icon: "braille_fun/braille_fun.svg"
  author: "Arkit Vora <arkitvora123@gmail.com>"
  demo: true
  title: qsTr("Braille Fun")
  description: qsTr("Braille the falling letters")
  goal: qsTr("")
  prerequisite: qsTr("Braille Alphabet Codes")
  manual: qsTr("Enter the braille code in the tile for the corresponding falling letters. Check the braille chart by clicking on the toggle button for help.")
  credit: qsTr("")
  section: "discovery braille"
}
