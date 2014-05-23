import GCompris 1.0

ActivityInfo {
  name: "sudoku/Sudoku.qml"
  difficulty: 4
  icon: "sudoku/sudoku.svgz"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Sudoku, place unique symbols in a square.")
  description: qsTr("Symbols must be unique in a row, in a column, and (if defined) each region.")
  goal: qsTr("The aim of the puzzle is to enter a symbol or numeral from 1 through 9 in each cell of a grid, most frequently a 9x9 grid made up of 3x3 subgrids (called 'regions'), starting with various symbols or numerals given in some cells (the 'givens'). Each row, column and region must contain only one instance of each symbol or numeral (Source &lt;http://en.wikipedia.org/wiki/Sudoku&gt;).")
  prerequisite: qsTr("Completing the puzzle requires patience and logical ability")
  manual: qsTr("For the first level with colored symbols, select a symbol on the left and click on its target position. For the higher levels, click on an empty square to give it the keyboard focus. Then enter a possible letter or number. GCompris will not let you enter invalid data.")
  credit: ""
  section: "/puzzle"
}
