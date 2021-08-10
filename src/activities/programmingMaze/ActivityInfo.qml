/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "programmingMaze/ProgrammingMaze.qml"
  difficulty: 3
  icon: "programmingMaze/programmingMaze.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Programming maze")
  //: Help title
  description: qsTr("This activity teaches to program Tux to reach its goal using simple instructions like move forward, turn left or right.")
  // intro: "Arrange the instructions and traverse the correct path to reach the fish."
  //: Help goal
  goal: qsTr("Tux is hungry. Help him find fish by programming him to the correct ice spot.")
  //: Help prerequisite
  prerequisite: qsTr("Can read instructions, and think logically to find a path.")
  //: Help manual
  manual: qsTr("Choose the instructions from the menu, and arrange them in order to lead Tux to his goal.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Left and Right arrows: navigate inside selected area") + ("</li><li>") +
          qsTr("Up and Down arrows: increase or decrease the loop counter if the loop area is selected") + ("</li><li>") +
          qsTr("Space: select an instruction or append selected instruction in main/procedure/loop area") + ("</li><li>") +
          qsTr("Tab: switch between instructions area and main/procedure/loop area") + ("</li><li>") +
          qsTr("Delete: remove selected instruction from main/procedure/loop area") + ("</li><li>") +
          qsTr("Enter: run the code or reset Tux when it fails to reach the fish") + ("</li></ul><br>") +
          qsTr("To add an instruction in main/procedure/loop area, select it from instructions area, then switch to the main/procedure/loop area and press Space.") + ("<br><br>") +
          qsTr("To modify an instruction in main/procedure/loop area, select it from main/procedure/loop area, then switch to instructions area, choose the new instruction and press Space.")
  credit: ""
  section: "fun"
  createdInVersion: 9700
  levels: "1,2,3"
}
