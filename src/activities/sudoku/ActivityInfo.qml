/* gcompris - Sudoku.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import GCompris 1.0

ActivityInfo {
  name: "sudoku/Sudoku.qml"
  difficulty: 4
  icon: "sudoku/sudoku.svg"
  author: "Johnny Jazeix <jazeix@gmail.com>"
  demo: false
  title: qsTr("Sudoku, place unique symbols in a square.")
  description: qsTr("Symbols must be unique in a row, in a column, and (if defined) each region.")
//  intro: "For the first levels, select a symbol and click its target area, for the following levels, type a number in each area. Each symbol must appear only once in a row, in a column and in a subregion if any."
  goal: qsTr("The aim of the puzzle is to enter a symbol or numeral from 1 through 9 in each cell of a grid, most frequently a 9x9 grid made up of 3x3 subgrids (called 'regions'), starting with various symbols or numerals given in some cells (the 'givens'). Each row, column and region must contain only one instance of each symbol or numeral (Source &lt;http://en.wikipedia.org/wiki/Sudoku&gt;).")
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability")
  manual: qsTr("For the first level with colored symbols, select a symbol on the left and click on its target position. For the higher levels, click on an empty square to give it the keyboard focus. Then enter a possible letter or number. GCompris will not let you enter invalid data.")
  credit: ""
  section: "/puzzle"
}
