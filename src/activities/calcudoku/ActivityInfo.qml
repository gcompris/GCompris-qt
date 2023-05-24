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
  title: qsTr("CalcuDoku")
  //: Help title
  description: qsTr("Symbols must be unique in a row, in a column, and each cage must produce its result.")
  //intro: "Select a number and click its target area. Each number must appear only once in a row and in a column and the result of the combination of all the numbers of a cage associated with its operator must give the cage result."
  //: Help goal
  goal: qsTr("The aim of the puzzle is to enter each number from 1 to the number of lines in each cell of a grid. Each number can only appear once on the same line or column. Cages are groups of cells that provide information on how to fill the grid. Either it is a single number which is the value of this cell or there is both an operator and a result and all the numbers of the cage, when combined with this operator must produce the result.")
  //: Help prerequisite
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability.")
  //: Help manual
  manual: qsTr("Select a number or a symbol on the left and click on its target position. GCompris will not let you enter invalid answer.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 40000
  levels: "1,2,3,4,5"
}
