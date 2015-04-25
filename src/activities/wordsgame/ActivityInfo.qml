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
  name: "wordsgame/Wordsgame.qml"
  difficulty: 2
  icon: "wordsgame/wordsgame.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: true
  title: qsTr("Falling Words")
  description: qsTr("Type the falling words before they reach the ground")
//  intro: "Type the words on your keyboard before they reach the ground."
  goal: qsTr("Keyboard training")
  prerequisite: qsTr("Keyboard manipulation")
  manual: qsTr("Type the complete word as it falls, before it reaches the ground")
  credit: ""
  section: "computer keyboard reading"
}
