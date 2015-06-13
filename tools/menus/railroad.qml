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
  name: "railroad/Railroad.qml"
  difficulty: 1
  icon: "railroad/railroad.svg"
  author: "Pascal Georges &lt;pascal.georges1@free.fr&gt;"
  demo: true
  title: qsTr("Railway")
  description: qsTr("A memory game based on trains")
  goal: qsTr("Memory-training")
  prerequisite: qsTr("None")
  manual: qsTr("A train - a locomotive and carriage(s) - is displayed at the top of the main area for a few seconds. Rebuild it at the top of the screen by selecting the appropriate carriages and locomotive. Deselect an item by clicking on it again. Check your construction by clicking on the hand at the bottom.")
  credit: ""
  section: "/discovery/memory_group"
}
