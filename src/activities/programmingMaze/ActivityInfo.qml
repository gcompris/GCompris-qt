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
  //: Activity title
  title: qsTr("Programming Maze")
  //: Help title
  description: qsTr("This activity teaches to program Tux to reach its goal using simple instructions like move forward, turn left and right.")
  // intro: "Arrange the instructions and traverse the correct path to reach the fish."
  //: Help goal
  goal: qsTr("Tux is hungry. Help him find fish by programming him to the correct ice spot.")
  //: Help prerequisite
  prerequisite: qsTr("Can read instructions, and think logically to find a path.")
  //: Help manual
  manual: qsTr("Choose the instructions from the menu, and arrange them in order to lead Tux to his goal.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<br><i><u>") +
          qsTr("1. To navigate through the instructions in the selected area:") + "</i></u><ul><li>" +
          qsTr("Use the ARROW keys") + "</li></ul><i><u>" +
          qsTr("2. To append an instruction from the instruction area to the main/procedure code area:") + "</i></u><ul><li>" +
          qsTr("Select an instruction from the instruction area by pressing SPACE.") + "</li><li>" +
          qsTr("Navigate to the code area by pressing TAB, then press SPACE to append the instruction.") + "</li></ul><i><u>" +
          qsTr("3. To add an instruction at any particular position in the main/procedure code area:") + "</i></u><ul><li>" +
          qsTr("Navigate to the instruction at this position and press SPACE to add the selected instruction from the instruction area.") + "</li></ul><i><u>" +
          qsTr("4. To delete the selected instruction in the main/procedure code area:") + "</i></u><ul><li>" +
          qsTr("Press DELETE.") + "</li></ul><i><u>" +
          qsTr("5. To edit an instruction in the main/procedure code area:") + "</i></u><ul><li>" +
          qsTr("Navigate to the instruction to edit using the ARROW keys.") + "</li><li>" +
          qsTr("Press SPACE to select it.") + "</li><li>" +
          qsTr("Then navigate to the instruction area using TAB and select the new instruction by pressing SPACE.") + "</li></ul><i><u>" +
          qsTr("6. To run the code or reset Tux when it fails to reach the fish:") + "</i></u><ul><li>" +
          qsTr("Press ENTER or RETURN.")+ "</li></ul>"
  credit: ""
  section: "fun"
  createdInVersion: 9700
}
