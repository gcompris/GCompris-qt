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
  name: "hanoi/Hanoi.qml"
  difficulty: 2
  icon: "hanoi/hanoi.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Simplified Tower of Hanoi")
  description: qsTr("Reproduce the given tower")
  goal: qsTr("Reproduce the tower on the right in the empty space on the left")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Drag and Drop one top piece at a time, from one peg to another, to reproduce the tower on the right in the empty space on the left.")
  credit: qsTr("Concept taken from EPI games.")
  section: "/puzzle"
}
