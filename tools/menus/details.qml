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
  name: "details/Details.qml"
  difficulty: 2
  icon: "details/details.svg"
  author: "Marc Levivier <malev@free.fr>"
  demo: true
  title: qsTr("Find the details")
  description: qsTr("Drag and Drop the shapes on their respective targets")
  goal: ""
  prerequisite: qsTr("Good mouse-control")
  manual: qsTr("Complete the puzzle by dragging each piece from the set of pieces on the left, to the matching space in the puzzle.")
  credit: qsTr("The images are from Wikimedia Commons.")
  section: "/discovery/miscellaneous"
}
