/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
  name: "hanoi/Hanoi.qml"
  difficulty: 2
  icon: "hanoi/hanoi.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Simplified Tower of Hanoi")
  //: Help title
  description: qsTr("Reproduce the given tower")
  //intro: "Rebuild the same tower in the empty area as the one you see on the right hand side."
  //: Help goal
  goal: qsTr("Reproduce the tower on the right in the empty space on the left")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation")
  //: Help manual
  manual: qsTr("Drag and Drop one top piece at a time, from one peg to another, to reproduce the tower on the right in the empty space on the left.")
  credit: qsTr("Concept taken from EPI games.")
  section: "discovery logic"
  createdInVersion: 4000
}
