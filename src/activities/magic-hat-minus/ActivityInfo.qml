/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Thibaut ROMAIN <thibrom@gmail.com>
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
  name: "magic-hat-minus/MagicHat.qml"
  difficulty: 2
  icon: "magic-hat-minus/magic-hat-minus.svg"
  author: "Thibaut ROMAIN &lt;thibrom@gmail.com&gt;"
  demo: true
  title: qsTr("The magician hat")
  description: qsTr("Count how many items are under the magic hat after some have got away")
//  intro: "Click on the hat. How many stars are still hiding under the hat."
  goal: qsTr("Learn subtraction")
  prerequisite: qsTr("Subtraction")
  manual: qsTr("Look at the magician, he tells the number of stars that are under his magic hat. Then, click on the hat to open it. A few stars escape. Click again on the hat to close it. You have to count how many are still under the hat. Click on the bottom area to answer.")
  credit: ""
  section: "math numeration"
}
