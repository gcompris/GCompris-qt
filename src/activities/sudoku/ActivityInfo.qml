/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "sudoku/Sudoku.qml"
  difficulty: 4
  icon: "sudoku/sudoku.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Sudoku")
  //: Help title
  description: qsTr("Solve the Sudoku.")
//  intro: "Select a number or a symbol and click its target area. Each symbol must appear only once in a row, in a column and in a subregion if any."
  //: Help goal
  goal: qsTr("Develop some skills in logical thinking (data linking, deduction) and spatial visualization.")
  //: Help prerequisite
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability.")
  //: Help manual
  manual: qsTr("Select a number or a symbol and click its target position. Each symbol must appear only once in a row, in a column and in a subregion if any. If an action is not allowed, the game will show why. But beware: if you can place something in a square, it might not be correct for the whole Sudoku. It can still be a mistake.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 0
  levels: ["1", "2", "3", "4"]
}
