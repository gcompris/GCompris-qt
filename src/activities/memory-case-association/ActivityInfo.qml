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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-case-association/MemoryCaseAssociation.qml"
  difficulty: 2
  icon: "memory-case-association/memory-case-association.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Case association memory game")
  //: Help title
  description: qsTr("Turn the cards over to match the alphabet with its lower/uppercase value.")
  //intro: "Match the alphabet with its upper/lower case alphabet."
  //: Help goal
  goal: qsTr("Learning lower and upper case alphabets, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Knowing alphabets")
  //: Help manual
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding the lower/uppercase of an alphabet, and you have to associate all the upper case letters with its lower case and vice versa.")
  credit: ""
  section: "reading"
  createdInVersion: 9000
}
