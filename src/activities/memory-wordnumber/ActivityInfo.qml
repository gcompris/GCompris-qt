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
  demo: false
  //: Activity title
  title: qsTr("Wordnumber memory game")
  //: Help title
  description: qsTr("Turn the cards over to match the number with the word matching it.")
//  intro: "Match the numeric with the word."
  //: Help goal
  goal: qsTr("Reading numbers, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Reading")
  //: Help manual
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding the numeral form of a number, or the word to write it.")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
}
