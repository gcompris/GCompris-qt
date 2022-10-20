/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "tens_complement_swap/Tens_complement_swap.qml"
  difficulty: 4
  icon: "tens_complement_swap/tens_complement_swap.svg"
  author: "Samarth Raj &lt;mailforsamarth@gmail.com&gt;"
  //: Activity title
  title: qsTr("Swap ten's complement")
  //: Help title
  description: qsTr("Swap the numbers to create pairs equal to ten.")
  //intro: "Create pairs of numbers equal to ten. Select a number, then select another number of the same operation to swap their position."
  //: Help goal
  goal: qsTr("Learn to use ten's complement to optimize the order of numbers in an operation.")
  //: Help prerequisite
  prerequisite: qsTr("Numbers from 1 to 30 and additions.")
  //: Help manual
  manual: qsTr("Create pairs of numbers equal to ten within each parentheses. Select a number, then select another number of the same operation to swap their position. When all the lines are completed, press the OK button to validate the answers. If some answers are incorrect, a cross icon will appear on the corresponding lines. Correct the errors, then press the OK button again.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 30000
  levels: "1,2,3"
}
