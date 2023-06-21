/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "sudoku/Sudoku.qml"
  difficulty: 4
  icon: "sudoku/sudoku.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Sudoku, place unique symbols in a grid")
  //: Help title
  description: qsTr("Symbols must be unique in a row, in a column, and (if defined) in each region.")
//  intro: "Select a number or a symbol and click its target area. Each symbol must appear only once in a row, in a column and in a subregion if any."
  //: Help goal
  goal: qsTr("The aim of the puzzle is to enter a symbol or numeral from 1 to 9 in each cell of a grid. In the official Sudoku the grid is 9×9 and made up of 3×3 subgrids (called 'regions'). In GCompris we start at lower levels with a simpler version using symbols and with no regions. In all cases the grid is presented with various symbols or numerals given in some cells (the 'givens'). Each row, column and region must contain only one instance of each symbol or numeral (Source &lt;https://en.wikipedia.org/wiki/Sudoku&gt;).")
  //: Help prerequisite
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability.")
  //: Help manual
  manual: qsTr("Select a number or a symbol in the list and click on its target position. GCompris will not let you enter an invalid answer.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 0
  levels: "1,2,3,4"
}
