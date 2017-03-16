/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 SOURADEEP BARUA <sourad97@gmail.com>
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
  name: "morse_code/MorseCode.qml"
  difficulty: 1
  icon: "morse_code/morse_code.svg"
  author: "Souradeep Barua &lt;sourad97@gmail.com&gt;"
  demo: true
  title: qsTr("Morse code activity")
  description: qsTr("Learn Morse code for alphabets and digits")
  //intro: "Click on Tux and then type morse code with the help of the instruction"
  goal: qsTr("You have to send and receive alphabets and digits from Tux in Morse code")
  prerequisite: qsTr("Knowledge of alphabets and digits")
  manual: qsTr("When you are asked to send Tux a message in Morse, you have to look for the corresponding morse code for required alphabet or digit. When Tux sends a message in morse, you have to type the corresponding alphabet or digit")
  credit: ""
  section: "fun"
  createdInVersion: 8000
}
