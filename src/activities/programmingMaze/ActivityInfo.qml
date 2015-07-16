/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
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
  name: "programmingMaze/ProgrammingMaze.qml"
  difficulty: 3
  icon: "maze/maze.svg"
  author: "Siddhesh Suthar &lt;siddhesh.it@gmail.com&gt;"
  demo: false
  title: qsTr("ProgrammingMaze activity")
  description: qsTr("This activity teaches the kid to program the Tux to its goal using
simple instructions like move forward, turn left etc")
  goal: qsTr("Tux is hungry. Help him find fish by programming him to the correct ice spot.")
  prerequisite: qsTr("Can read instructions. Thinking of the path logically")
  manual: qsTr("Choose the instructions from given menu. Arrange the instruction in an
order so that they can make the tux reach to its goal")
  credit: ""
  section: "fun"
}
