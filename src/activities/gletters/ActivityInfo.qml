/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
  name: "gletters/Gletters.qml"
  difficulty: 2
  icon: "gletters/gletters.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: true
  title: qsTr("Simple Letters")
  description: qsTr("Type the falling letters before they reach the ground")
//  intro: "Type the letters on your keyboard before they reach the ground."
  goal: qsTr("Letter association between the screen and the keyboard")
  prerequisite: ""
  manual: qsTr("Type the falling letters before they reach the ground")
  credit: ""
  section: "computer keyboard reading"
}
