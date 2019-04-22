/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
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
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: false
  //: Activity title
  title: qsTr("Programming Maze")
  //: Help title
  description: qsTr("This activity teaches the kid to program the Tux to its goal using
                    simple instructions like move forward, turn left etc")
  // intro: "Arrange the instructions and traverse the correct path to reach the fish."
  //: Help goal
  goal: qsTr("Tux is hungry. Help him find fish by programming him to the correct ice spot.")
  //: Help prerequisite
  prerequisite: qsTr("Can read instructions. Thinking of the path logically")
  //: Help manual
  manual: qsTr("Choose the instructions from given menu. Arrange the instruction in an
                order so that they can make the Tux reach to his goal.<br><br>") +
          qsTr("<b>Keyboard Controls:</b><br><br>") +
          qsTr("1. <i><u>To navigate through instructions in the current code area having keyboard focus</i></u>:") +
          qsTr("<ul><li><b>Arrow keys</b></li></ul><br>") +
          qsTr("2. <i><u>To append an instruction from instruction area to the main/procedure code area</i></u>:") +
          qsTr("<ul><li>Select an instruction from the instruction area by pressing <b>SPACE</b>.</li>") +
          qsTr("<li>Navigate to the code areas by pressing <b>TAB</b>, then press <b>SPACE</b> to append the instruction.</li></ul><br>") +
          qsTr("3. <i><u>To add an instruction at any particular position in the main/procedure code area</i></u>:") +
          qsTr("<ul><li>Navigate to the instruction at that position and press <b>SPACE</b> to add the selected instruction from the instruction area.</li></ul><br>") +
          qsTr("4. <i><u>To delete the current navigated instruction in the main/procedure code area</i></u>:") +
          qsTr("<ul><li><b>DELETE</b>.</li></ul><br>") +
          qsTr("5. <i><u>To edit an instruction in the main/procedure code area</i></u>:") +
          qsTr("<ul><li>Navigate to the instruction to edit using <b>Arrow keys</b>.</li>") +
          qsTr("<li>Press <b>SPACE</b> to select it.</li>") +
          qsTr("<li>Then navigate to the instruction area using <b>TAB</b> and select the new instruction by pressing <b>SPACE</b>.</li></ul><br>") +
          qsTr("6. <i><u>To run the code or reset Tux when it fails to reach the fish</i></u>:") +
          qsTr("<ul><li><b>ENTER</b> or <b>RETURN</b>.</li></ul>")
  credit: ""
  section: "fun"
  createdInVersion: 9800
}
