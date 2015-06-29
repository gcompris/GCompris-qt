/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "braille_lotto/BrailleLotto.qml"
  difficulty: 6
  icon: "braille_lotto/braille_lotto.svg"
  author: "Srishti Sethi &lt;srishakatux@gmail.com&gt;"
  demo: true
  title: qsTr("Braille Lotto")
  description: qsTr("Discover the Braille system for numbers.")
  goal: ""
  prerequisite: ""
  manual: qsTr("Each player must find if the proposed number is in their board. If the code is in the board, just click on it in order to validate it. The player who crosses all the Braille numbers correctly wins the game. Check the Braille table by clicking on the toggle button in the control bar.")
  credit: ""
  section: "/discovery/braille"
}
