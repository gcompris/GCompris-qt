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
  icon: "programmingMaze/programmingMaze.svg"
  author: "Siddhesh Suthar &lt;siddhesh.it@gmail.com&gt;"
  demo: false
  title: qsTr("Programming Maze")
  description: qsTr("This activity teaches the kid to program the Tux to its goal using
                    simple instructions like move forward, turn left etc")
  goal: qsTr("Tux is hungry. Help him find fish by programming him to the correct ice spot.")
  prerequisite: qsTr("Can read instructions. Thinking of the path logically")
  manual: qsTr("Choose the instructions from given menu. Arrange the instruction in an
                order so that they can make the tux reach to its goal<br><br>") +
          qsTr("<b>Keyboard Controls:</b><br>") +
          qsTr("1. <b>SPACE</b> to select an instruction.<br>") +
          qsTr("2. <b>TAB</b> to switch to different code areas.<br>") +
          qsTr("3. <b>SPACE</b> to add/edit the selected instruction from instruction area to the current code area (main/procedure)<br>") +
          qsTr("4. <b>Arrow keys</b> to navigate instructions in the current code area having keyboard focus.<br>") +
          qsTr("5. <b>DELETE</b> to delete the current navigated instruction in the code area.<br>") +
          qsTr("6. <b>ENTER</b> or <b>RETURN</b> to run the code or reset Tux when it fails to reach the fish.")
  credit: ""
  section: "fun"
}
