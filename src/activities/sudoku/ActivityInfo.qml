/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
  name: "sudoku/Sudoku.qml"
  difficulty: 4
  icon: "sudoku/sudoku.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Sudoku, place unique symbols in a grid")
  //: Help title
  description: qsTr("Symbols must be unique in a row, in a column, and (if defined) each region.")
//  intro: "Select a number or a symbol and click its target area. Each symbol must appear only once in a row, in a column and in a subregion if any."
  //: Help goal
  goal: qsTr("The aim of the puzzle is to enter a symbol or numeral from 1 through 9 in each cell of a grid. In the official Sudoku the grid is 9x9 made up of 3x3 subgrids (called 'regions'). In GCompris we start at lower levels with a simpler version using symbols and with no regions. In all cases the grid is presented with various symbols or numerals given in some cells (the 'givens'). Each row, column and region must contain only one instance of each symbol or numeral (Source &lt;http://en.wikipedia.org/wiki/Sudoku&gt;).")
  //: Help prerequisite
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability")
  //: Help manual
  manual: qsTr("Select a number or a symbol on the left and click on its target position. GCompris will not let you enter invalid data.")
  credit: ""
  section: "puzzle"
}
