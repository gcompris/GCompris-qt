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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "maze3D/Maze3D.qml"
  difficulty: 2
  icon: "maze3D/maze3D.svg"
  author: "Christof Petig &lt;christof@petig-baender.de&gt;"
  demo: true
  title: qsTr("3D Maze")
  description: qsTr("Find your way out of the 3D maze")
  goal: qsTr("Help Tux get out of this maze.")
  prerequisite: qsTr("Can use the keyboard arrow to move an object.")
  manual: qsTr("Use the keyboard arrows to move Tux up to the door. Use the spacebar to switch between 2D and 3D modes. 2D mode just gives you an indication of your position, like a map. You cannot move Tux in 2D mode.")
  credit: ""
  section: "/discovery/mazeMenu"
}
