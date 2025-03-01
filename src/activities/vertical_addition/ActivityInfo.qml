/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "vertical_addition/VerticalAddition.qml"
  difficulty: 1
  icon: "vertical_addition/vertical_addition.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Vertical addition")
  //: Help title
  description: qsTr("Solve the given addition.")
  //intro: "Solve the given addition."
  //: Help goal
  goal: qsTr("Learn to solve vertical additions.")
  //: Help prerequisite
  prerequisite: qsTr("Addition tables.")
  //: Help manual
  manual: qsTr("In a vertical addition, numbers are written one below the other. They need to be lined-up properly, starting from the column on the right-hand side. The result is written on the bottom line. To solve the addition, start by adding up the numbers of the first column (on the right-hand side), and write the result on the bottom line of the same column. If the result gives a two digit number, write only the units digit on the result, and add the tens digit next to the top number of the next column: this is called the carry. Then add up the numbers of the next column, including the carry number, and repeat the process until the operation is finished. Once you have found the result, click on the OK button to validate your answer. In some levels, you will be need to write the given operation before solving it; in this case, click on the Ready button when the operation is written correctly and then solve it.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 250000
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
}
