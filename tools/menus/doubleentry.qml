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
  name: "doubleentry/Doubleentry.qml"
  difficulty: 2
  icon: "doubleentry/doubleentry.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Double-entry table")
  description: qsTr("Drag and Drop the items in the double-entry table")
  goal: qsTr("Move the items on the left to their proper position in the double-entry table.")
  prerequisite: qsTr("Basic counting skills")
  manual: qsTr("Drag and Drop each proposed item on its destination")
  credit: ""
  section: "/discovery/miscellaneous"
}
