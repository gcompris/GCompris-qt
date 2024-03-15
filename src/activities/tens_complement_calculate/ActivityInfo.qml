/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "tens_complement_calculate/Tens_complement_calculate.qml"
  difficulty: 4
  icon: "tens_complement_calculate/tens_complement_calculate.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Calculate with ten's complement")
  //: Help title
  description: qsTr("Swap the numbers to create pairs equal to ten and input the answer of the final sum.")
  //intro: "Create pairs of numbers equal to ten. Select a number, then select another number of the same operation to swap their position. Then, select the result box to type the result."
  //: Help goal
  goal: qsTr("Learn to use ten's complement to optimize the order of numbers in an operation and calculate the result.")
  //: Help prerequisite
  prerequisite: qsTr("Numbers from 1 to 30 and additions.")
  //: Help manual
  manual: qsTr("Create pairs of numbers equal to ten within each parentheses. Select a number, then select another number of the same operation to swap their position. On each line, input the final sum in last box. When all the lines are completed, press the OK button to validate the answers. If some answers are incorrect, a cross icon will appear on the corresponding lines. Correct the errors, then press the OK button again.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 50000
  levels: "1,2"
}
