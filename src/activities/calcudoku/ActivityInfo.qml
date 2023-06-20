/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "calcudoku/Calcudoku.qml"
  difficulty: 4
  icon: "calcudoku/calcudoku.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title - the game is the KenKen but we cannot use KenKen as it is a trademark name
  title: qsTr("Calcudoku")
  //: Help title
  description: qsTr("Solve the Calcudoku.")
  //intro: "Select a number and click on its target position. Each number must appear only once in a row and in a column. The numbers in the cells of a cage must produce the given result when combined using the given operator."
  //: Help goal
  goal: qsTr("Develop your logical reasoning skills: data linking, deduction and spatial location while using calculation.")
  //: Help prerequisite
  prerequisite: qsTr("Completing the puzzle requires patience and arithmetic abilities.")
  //: Help manual
  manual: qsTr("Select a number in the list and click on its target position to fill the grid. Each number must appear only once in a row and in a column. Cages are groups of cells providing information on how to fill them. Cages made of more than one cell provide a result and an operator: all the numbers in the cage, when combined using the operator, must produce the result. Cages made of only one cell directly provide the number to enter.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 40000
  levels: "1,2,3,4,5"
}
