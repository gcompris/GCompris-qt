/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "vertical_subtraction/VerticalSubtraction.qml"
  difficulty: 1
  icon: "vertical_subtraction/vertical_subtraction.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Vertical subtraction")
  //: Help title
  description: qsTr("Solve the given subtraction.")
  //intro: "Solve the given subtraction."
  //: Help goal
  goal: qsTr("Learn to solve vertical subtractions, with the borrowing by regrouping method.")
  //: Help prerequisite
  prerequisite: qsTr("Subtraction tables.")
  //: Help manual
  manual: qsTr("In a vertical subtraction, numbers are written one below the other. They need to be lined-up properly, starting from the column on the right-hand side. The top number is called the minuend: it is the amount that we are starting with, that another number is being subtracted from to get the difference. The number below is called the subtrahend: it is the amount to substract from the minuend to get the difference. The result is written on the bottom line. To solve the subtraction, start by subtracting the bottom number of the first column from the top number of the first column (on the right-hand side), and write the result on the bottom line of the same column. If the top number is smaller than the bottom number, you can borrow from the minuend on the next column: for example, if you add 10 units to the top number, you need to remove one unit from the top number of the next column. This is called the borrowing by regrouping method. To do that in this activity, click on the empty rectangle on the left of the top number, select 1, and on the next column click on the empty rectangle on the right of the top number and select -1. Then write the result of the column on the bottom line, and do the same on the next columns until the operation is finished. Once you have found the result, click on the OK button to validate your answer. In some levels, you will be need to write the given operation before solving it; in this case, click on the Ready button when the operation is written correctly and then solve it.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 250000
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
}
